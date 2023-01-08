<%!
    import includes
%>

module fsm_top (
    input clk,
    input rst,
    input start,
    input get_src1_addr_sel,
    input get_a0_a1_addr,
    input [`mdpe_vrf_awdith-1:0] vec_wr_addr,
    input [`mdpe_vrf_dwdith-1:0] wr_vec,
    input we,
    input layer_done,

    output [2*`mdpe_num_mvm_ram_per_mdpe-1:0] src1_addr_sel,
    output [`mdpe_num_mvm_ram_per_mdpe-1:0] is_non_zero,
    output [15:0] meta_data
);

    reg [`mdpe_vrf_awdith-1:0] vec_rd_addr;
    wire [`mdpe_vrf_dwdith-1:0] rd_vec;
    wire get_next_vec_bit;

    always @(posedge clk) begin
        if (get_next_vec_bit) begin
            vec_rd_addr <= vec_rd_addr + 1;
        end
    end

    mdpe_vrf u_mdpe_vrf (
        .clk(clk),
        .vec_wr_addr(vec_wr_addr),
        .wr_vec(wr_vec),
        .we(we),
        .vec_rd_addr(vec_rd_addr),
        .rd_vec(rd_vec)
    );

    src1_addr_selector u_selector (
        .clk(clk),
        .v0(rd_vec[`mdpe_num_mvm_ram_per_mdpe-1:0]),
        .v1(rd_vec[2*`mdpe_num_mvm_ram_per_mdpe-1:`mdpe_num_mvm_ram_per_mdpe]),
        .get_src1_addr_sel(get_src1_addr_sel),
        .src1_addr_sel(src1_addr_sel),
        .is_non_zero(is_non_zero),
        .get_next_vec_bit(get_next_vec_bit)
    );

    mdpe_meta_data_mem u_mdpe_meta_data_mem (
        .clk(clk),
        .rst(rst),
        .start(start),
        .layer_done(layer_done),
        .get_a0_a1_addr(get_a0_a1_addr),
        .meta_data(meta_data)
    ); 
endmodule

module mdpe_meta_data_mem (
    input clk,
    input rst,
    input start,
    input layer_done,
    input get_a0_a1_addr,
    output [15:0] meta_data
);

    localparam first_addr = 9'd0;

    wire pe_out_fake;
    reg [8:0] next_layer_addr, meta_data_addr;
    reg store_next_layer_addr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            meta_data_addr <= first_addr;
            store_next_layer_addr <= 0;
        end
        else if (start) begin
            store_next_layer_addr <= 1;
        end
        else begin
            if (get_a0_a1_addr) begin
                meta_data_addr <= meta_data_addr + 1;
                store_next_layer_addr <= 0;
            end
            else if (layer_done) begin
                meta_data_addr <= next_layer_addr;
                store_next_layer_addr <= 1;
            end
        end
    end

    always @(posedge clk) begin
        if (store_next_layer_addr) begin           
            next_layer_addr <= meta_data[12:4];
        end
    end

    simple_dual_port u_meta_data_mem (
        .wr_en(1'b0),
        .read_address(meta_data_addr),
        .write_address(9'b0),
        .read_data(meta_data),
        .write_data(16'b0),
        .clk(clk)
    );

endmodule

module mdpe_vrf (
    input clk,
    input [`mdpe_vrf_awdith-1:0] vec_wr_addr, 
    input [`mdpe_vrf_dwdith-1:0] wr_vec,
    input we,

    input [`mdpe_vrf_awdith-1:0] vec_rd_addr,
    output [`mdpe_vrf_dwdith-1:0] rd_vec
);

    wire [`mdpe_num_vrf_brams-1:0] pe_out_fake;
    wire [`mdpe_bram_dwidth-1:0] last_bram_out, last_bram_in;

% for ii in range(includes.mdpe_num_vrf_brams-1):
    wire [`mdpe_bram_dwidth-1:0] rd_vec_temp_${ii};
    assign rd_vec[(${ii}+1)*`mdpe_bram_dwidth-1:${ii}*`mdpe_bram_dwidth] = rd_vec_temp_${ii};

    simple_dual_port vec_mem_${ii} (
        .write_address(vec_wr_addr),
        .write_data(wr_vec[(${ii}+1)*`mdpe_bram_dwidth-1:${ii}*`mdpe_bram_dwidth]),
        .wr_en(we),
        .read_address(vec_rd_addr),
        .read_data(rd_vec_temp_${ii}),
        .clk(clk)
    );

% endfor
    simple_dual_port vec_mem_${ii+1} (
        .write_address(vec_wr_addr),
        .write_data(last_bram_in),
        .wr_en(we),
        .read_address(vec_rd_addr),
        .read_data(last_bram_out),
        .clk(clk)
    );
    
    assign last_bram_in = {{`mdpe_last_vrf_bram_unused_dwidth{1'b0}}, wr_vec[(${ii+1}*`mdpe_bram_dwidth) + (`mdpe_last_vrf_bram_used_dwidth-1):${ii+1}*`mdpe_bram_dwidth]};

    assign rd_vec[(${ii+1}*`mdpe_bram_dwidth) + (`mdpe_last_vrf_bram_used_dwidth-1):${ii+1}*`mdpe_bram_dwidth] = last_bram_out[`mdpe_last_vrf_bram_used_dwidth-1:0];
endmodule


module src1_addr_selector(
    input clk,
    input [`mdpe_num_mvm_ram_per_mdpe-1:0] v0,
    input [`mdpe_num_mvm_ram_per_mdpe-1:0] v1,
    input get_src1_addr_sel,
    
    output reg [2*`mdpe_num_mvm_ram_per_mdpe-1:0] src1_addr_sel,
    output reg [`mdpe_num_mvm_ram_per_mdpe-1:0] is_non_zero,
    output reg get_next_vec_bit
);

    always @(posedge clk) begin
        get_next_vec_bit <= get_src1_addr_sel;

% for ii in range(includes.mdpe_num_mvm_ram_per_mdpe):
        src1_addr_sel[(${ii}+1)*2-1:${ii}*2] <= {v1[${ii}], v0[${ii}]};
        is_non_zero[${ii}] <= v1[${ii}] | v0[${ii}];

%endfor
    end

<%doc>
% for ii in range(includes.mdpe_num_mvm_ram_per_fsm): 
    addr_selector u_addr_selector_${ii} (
        .v0(v0[${ii}]),
        .v1(v1[${ii}]),
        .addr_sel(src1_addr[(${ii}+1)*2-1:${ii}*2]),
        .is_non_zero(is_non_zero[${ii}])
    );
% endfor
</%doc>

endmodule

<%doc>
module addr_selector(
    input v0,
    input v1,
    output reg [1:0] addr_sel,
    output is_non_zero
);

    assign is_non_zero = v0 | v1;

    always @(*) begin
        case({v1, v0})
            2'b00: addr_sel <= 2'd0;
            2'b01: addr_sel <= 2'd1;
            2'b10: addr_sel <= 2'd2;
            2'b11: addr_sel <= 2'd3;
        endcase
    end
    
endmodule
</%doc>

<%doc>
module fsm_mdpe_top (
    input clk,
    input rst,
    input start,

    // dot product
    input [15:0] meta_data,
    input [2*`mdpe_num_mvm_ram_per_fsm-1:0] src1_addr_sel,
    input [`mdpe_num_mvm_ram_per_fsm-1:0] is_non_zero,
    output [`mdpe_num_mvm_ram_per_fsm*`mdpe_compute_ram_iwidth-1:0] instr,
    output [`mdpe_num_mvm_ram_per_fsm-1:0] execute_instr,
    output get_a0_a1_addr,
    output get_src1_addr_sel,

    // obras
    output [`mdpe_mvm_ram_awidth-1:0] mvm_ram_unit_rd_addr,
    output adder_tree_input_valid,
    output flush_adder_tree,
    
    output reg done
);

    localparam s_idle = 2'd0;
    localparam s_wait_dot_product = 2'd1;
    localparam s_wait_obras = 2'd2;
    reg [1:0] next_state;

    reg dot_product_start, obras_start;
    wire dot_product_done, obras_done;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dot_product_start <= 0;
            obras_start <= 0;
            done <= 0;
            next_state <= s_idle;
        end
        else begin
            case (next_state)
                s_idle: begin
                    if (start) begin
                        dot_product_start <= 1;
                        next_state <= s_wait_dot_product;
                    end
                    else begin
                        dot_product_start <= 0;
                        obras_start <= 0;
                        done <= 0;
                        next_state <= s_idle;
                    end
                end
                s_wait_dot_product: begin
                    dot_product_start <= 0;
                    if (dot_product_done) begin
                        obras_start <= 1;
                        next_state <= s_wait_obras;
                    end
                    else begin
                        next_state <= s_wait_dot_product;
                    end
                end
                s_wait_obras: begin
                    obras_start <= 0;
                    if (obras_done) begin
                        done <= 1;
                        next_state <= s_idle;
                    end
                    else begin
                        next_state <= s_wait_obras;
                    end
                end
            endcase
        end
    end

    fsm_dot_product u_fsm_dot_product(
        .clk(clk),
        .rst(rst),
        .start(dot_product_start),
        .imac_src1_addr_sel(src1_addr_sel),
        .meta_data(meta_data),
        .is_non_zero(is_non_zero),
        .get_a0_a1_addr(get_a0_a1_addr),
        .execute_instr(execute_instr),
        .get_src1_addr_sel(get_src1_addr_sel),
        .instr(instr),
        .done(dot_product_done)
    );

    fsm_obras u_fsm_obras(
        .clk(clk),
        .rst(rst),
        .start(obras_start),
        .precision(5'd18),
        .rd_addr(mvm_ram_unit_rd_addr),
        .adder_tree_input_valid(adder_tree_input_valid),
        .flush_adder_tree(flush_adder_tree),
        .done(obras_done)
    );

endmodule

module fsm_obras(
    input clk,
    input rst,
    input start,

    input [`mdpe_in_bram_acc_precision_log-1:0] precision,

    output reg [`mdpe_mvm_ram_awidth-1:0] rd_addr,
    output reg adder_tree_input_valid,
    output reg flush_adder_tree,
    output reg done
);

    localparam fmac_addr = 7'd40;
    
    localparam s_idle = 2'd0;
    localparam s_obras_in_progress = 2'd1;
    localparam s_flush_adder_tree = 2'd2;
    localparam s_done = 2'd3;
    reg [1:0] next_state;
    
    reg [`mdpe_in_bram_acc_precision_log-1:0] bits_left;
    reg [1:0] chunks_left;
    reg [1:0] idx;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_addr <= 0;
            adder_tree_input_valid <= 0;
            done <= 0;
            bits_left <= 0;
            flush_adder_tree <= 0;
            next_state <= s_idle;
        end
        else begin
            case (next_state)
                s_idle: begin
                    if (start) begin
                        rd_addr <= fmac_addr;
                        bits_left <= precision;
                        next_state <= s_obras_in_progress;
                        chunks_left <= 2'd3;
                        idx <= 1;
                    end
                    else begin
                        rd_addr <= 0;
                        bits_left <= 0;
                        adder_tree_input_valid <= 0;
                        flush_adder_tree <= 0;
                        next_state <= s_idle;
                    end
                end
                s_obras_in_progress: begin
                    rd_addr <= rd_addr + 1;
                    bits_left <= bits_left - 1;
                    adder_tree_input_valid <= 1;
                    if (bits_left == 0) begin
                        next_state <= s_flush_adder_tree;
                        bits_left <= `mdpe_adder_tree_stages;
                    end
                    else begin
                        next_state <= s_obras_in_progress;
                    end
                end
                s_flush_adder_tree: begin
                    flush_adder_tree <= 1;
                    if (bits_left == 0) begin
                        if (chunks_left == 0) begin
                            next_state <= s_done;
                        end
                        else begin
                            chunks_left <= chunks_left - 1;
                            rd_addr <= fmac_addr + idx;
                            idx <= idx + 1;
                            next_state <= s_obras_in_progress;
                        end
                    end
                    else begin
                        next_state <= s_flush_adder_tree;
                    end
                end
                s_done: begin
                    done <= 1;
                    next_state <= s_idle;
                    adder_tree_input_valid <= 0;
                    flush_adder_tree <= 0;
                end
            endcase
        end
    end
endmodule

module fsm_dot_product (
    input clk,
    input rst,
    input start,

    input [2*`mdpe_num_mvm_ram_per_fsm-1:0] imac_src1_addr_sel,
    input [15:0] meta_data,
    input [`mdpe_num_mvm_ram_per_fsm-1:0] is_non_zero,

    output reg get_a0_a1_addr,
    output reg [`mdpe_num_mvm_ram_per_fsm-1:0] execute_instr,
    output reg get_src1_addr_sel,
    output [`mdpe_compute_ram_iwidth*`mdpe_num_mvm_ram_per_fsm-1:0] instr,
    output reg done
);

    wire [1:0] meta_data_fake;
    assign meta_data_fake = meta_data[15:14];

    // states
    localparam s_idle = 4'b0011;
    localparam s_get_a0_a1_addr = 4'b0110;
    localparam s_calculate_sum = 4'b0101;
    localparam s_add = 4'b1010;
    localparam s_store_carry = 4'b1111;
    localparam s_copy = 4'b0100;
    localparam s_get_src1_addr_1 = 4'b0010;
    localparam s_get_src1_addr_2 = 4'b1010;
    localparam s_reduce_dot_product = 4'b0111;
    localparam s_done = 4'b1011;

    reg [3:0] next_state, n2n_state;

    
    localparam a0_plus_a1_addr = 7'd10;

    localparam imac_addr = 7'd20;
    localparam fmac_addr = 7'd40;

    localparam a0_plus_a1_precision = `mdpe_a0_plus_a1_precision;

    localparam sel_inc_addr = 2'b00;

    // in1
    localparam sel_a0_plus_a1_addr = 2'b01;
    localparam sel_a0_addr = 2'b01;
    localparam sel_a1_addr = 2'b01;

    // in2
    localparam sel_imac_addr = 2'b10;

    // in3
    localparam sel_fmac_addr = 2'b11;
    //localparam sel_vec_addr = 2'b11;

    reg [1:0] predicate;
    reg [1:0] write_sel;
    reg port;
    reg c_rst;
    reg c_en;
    reg m_rst;
    reg m_en;
    reg [3:0] truth_table;
    reg [6:0] dest_addr, src2_addr;
    reg [7*`mdpe_num_mvm_ram_per_fsm-1:0] src1_addr;
    
    reg [3:0] chunks_left;
    reg [6:0] a0_addr, a1_addr;
    reg first_mac;
    reg [`mdpe_in_bram_acc_precision_log-1:0] reduction_precision;
    wire [`mdpe_num_mvm_ram_per_fsm-1:0] execute_instr_wire;
    reg [1:0] execute_instr_reg_sel;
    reg [1:0] dest_addr_sel, src2_addr_sel;
    reg [3-1:0] src1_addr_sel;
    wire all_macs_done;
    assign all_macs_done = (chunks_left == 0);

    reg [1:0] bits_left_sel;
    wire [`mdpe_in_bram_acc_precision_log-1:0] bits_left_wire;
    wire bits_left;
    assign bits_left = (bits_left_wire != 0);

    reg [`mdpe_in_bram_acc_precision_log-1:0] vec_bits_left_reg;
    wire [`mdpe_in_bram_acc_precision_log-1:0] vec_bits_left_wire;
    wire vec_bits_left;
    assign vec_bits_left_wire = vec_bits_left_reg - 1;
    assign vec_bits_left = (vec_bits_left_reg != 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_state <= s_idle;
            n2n_state <= s_idle;
            vec_bits_left_reg <= 0;
            chunks_left <= 0;
            get_src1_addr_sel <= 0;
            get_a0_a1_addr <= 0;
            first_mac <= 1;
            done <= 0;
        end
        else begin
            case (next_state)
                s_idle: begin
                    done <= 0;
                    first_mac <= 1;
                    if (start) begin
                        next_state <= s_get_a0_a1_addr;
                        get_src1_addr_sel <= 1;
                        reduction_precision <= `mdpe_chunk_precision;
                        chunks_left <= meta_data[3:0];
                    end
                    else begin
                        next_state <= s_idle;
                        get_src1_addr_sel <= 0;
                    end
                end
                s_get_a0_a1_addr: begin
                    vec_bits_left_reg <= `mdpe_precision;
                    get_a0_a1_addr <= 1;
                    next_state <= s_calculate_sum;
                end
                s_calculate_sum: begin
                    a0_addr <= meta_data[6:0];
                    a1_addr <= meta_data[13:7];
                    next_state <= s_add;
                    n2n_state <= s_get_src1_addr_1;
                end
                s_add: begin
                    predicate <= 0;
                    write_sel <= 1;
                    port <= 1;
                    c_rst <= 0;
                    c_en <= 0;
                    m_rst <= 0;
                    m_en <= 1;
                    truth_table <= `ALU_CMD;
                    if (bits_left) begin
                        next_state <= s_add;
                    end
                    else begin
                        next_state <= s_store_carry;
                    end
                end
                s_store_carry: begin
                    predicate <= 0;
                    write_sel <= 1;
                    port <= 1;
                    c_rst <= 0;
                    c_en <= 1;
                    m_rst <= 0;
                    m_en <= 1;
                    truth_table <= `ALU_CMD;
                    next_state <= n2n_state;
                end
                s_get_src1_addr_1: begin
                    get_src1_addr_sel <= 1;
                    vec_bits_left_reg <= vec_bits_left_wire;
                    next_state <= s_copy;
                    n2n_state <= s_get_src1_addr_2;
                end
                s_copy: begin
                    get_src1_addr_sel <= 0;
                    predicate <= 0;
                    write_sel <= 1;
                    port <= 1;
                    c_rst <= 0;
                    c_en <= 1;
                    m_rst <= 0;
                    m_en <= 1;
                    truth_table <= `COPY_CMD;
                    if (bits_left) begin
                        next_state <= s_copy;
                    end
                    else begin
                        next_state <= n2n_state;
                    end
                end
                s_get_src1_addr_2: begin
                    get_src1_addr_sel <= 1;
                    next_state <= s_add;
                    if (vec_bits_left) begin
                        n2n_state <= s_get_src1_addr_2;
                        vec_bits_left_reg <= vec_bits_left_wire;
                    end
                    else begin
                        chunks_left <= chunks_left - 1;
                        n2n_state <= s_reduce_dot_product;
                    end
                end
                s_reduce_dot_product: begin
                    first_mac <= 0;
                    reduction_precision <= reduction_precision + 1;
                    case ({first_mac, all_macs_done})
                        2'b00: begin
                            next_state <= s_add;
                            n2n_state <= s_get_a0_a1_addr;
                        end
                        2'b01: begin
                            next_state <= s_add;
                            n2n_state <= s_done;
                        end
                        2'b10: begin
                            next_state <= s_get_a0_a1_addr;
                        end
                        2'b11: begin
                            next_state <= s_done;
                        end
                    endcase
                end
                s_done: begin
                    done <= 1;
                    next_state <= s_idle;
                end
            endcase
        end
    end

    wire is_reduction_dot_product_state;
    assign is_reduction_dot_product_state = ~next_state[3] & (&next_state[2:0]);

    wire is_reduction_dot_product_state_and_first_mac;
    assign is_reduction_dot_product_state_and_first_mac = (is_reduction_dot_product_state & first_mac);

    wire execute_instr_reg_sel_0;
    assign execute_instr_reg_sel_0 = (~is_reduction_dot_product_state & next_state[0]) | (is_reduction_dot_product_state_and_first_mac);

    wire execute_instr_reg_sel_1;
    assign execute_instr_reg_sel_1 = (~is_reduction_dot_product_state & next_state[1] | is_reduction_dot_product_state_and_first_mac);

    always @(posedge clk) begin
        execute_instr <= execute_instr_wire;
        dest_addr_sel <= next_state[1:0];
        src1_addr_sel <= next_state[2:0]; // take outside sel
        src2_addr_sel <= next_state[1:0];
        bits_left_sel <= next_state[1:0];
        execute_instr_reg_sel <= {execute_instr_reg_sel_1, execute_instr_reg_sel_0};
    end

    execute_instr_generator u_execute_instr_generator(
        .clk(clk),
        .sel(execute_instr_reg_sel),
        .is_non_zero(is_non_zero),
        .execute_instr(execute_instr_wire)
    );

    bits_left_calculator u_bits_left_calculator (
        .clk(clk),
        .sel(bits_left_sel),
        .precision(`mdpe_precision),
        .a0_plus_a1_precision(`mdpe_a0_plus_a1_precision),
        .reduction_precision(reduction_precision),
        .bits_left(bits_left_wire)
    );

    addr_generator u_dest_addr (
        .clk(clk),
        .sel(dest_addr_sel),
        .in1(a0_plus_a1_addr),
        .in2(imac_addr),
        .in3(fmac_addr),
        .addr_reg(dest_addr)
    );
    
    addr_generator u_src2_addr (
        .clk(clk),
        .sel(src2_addr_sel),
        .in1(a1_addr),
        .in2(imac_addr),
        .in3(fmac_addr),
        .addr_reg(src2_addr)
    );

% for ii in range(includes.mdpe_num_mvm_ram_per_fsm):
    src1_addr_generator u_src1_addr_${ii} (
        .clk(clk),
        .internal_sel(src1_addr_sel),
        .imac_src1_addr_sel(imac_src1_addr_sel[(${ii}+1)*2-1:${ii}*2]),
        .a0_addr(a0_addr),
        .a1_addr(a1_addr),
        .a0_plus_a1_addr(a0_plus_a1_addr),
        .imac_addr(imac_addr),
        .addr_reg(src1_addr[(${ii}+1)*7-1:${ii}*7])
    );

    assign instr[(${ii}+1)*`mdpe_compute_ram_iwidth-1:${ii}*`mdpe_compute_ram_iwidth] = {predicate, 7'd0, write_sel, port, c_rst, c_en, m_rst, m_en, truth_table, dest_addr, src1_addr[(${ii}+1)*7-1:${ii}*7], src2_addr};

% endfor
endmodule

module execute_instr_generator(
    input clk,
    input [1:0] sel,
    input [`mdpe_num_mvm_ram_per_fsm-1:0] is_non_zero,
    output reg [`mdpe_num_mvm_ram_per_fsm-1:0] execute_instr
);

    reg [`mdpe_num_mvm_ram_per_fsm-1:0] execute_instr_wire;

    always @(*) begin
        case(sel)
            2'b00: execute_instr_wire <= {`mdpe_num_mvm_ram_per_fsm{1'b0}};
            2'b01: execute_instr_wire <= is_non_zero;
            2'b10: execute_instr_wire <= execute_instr;
            2'b11: execute_instr_wire <= {`mdpe_num_mvm_ram_per_fsm{1'b1}};
        endcase
    end

    always @(posedge clk) begin
        execute_instr <= execute_instr_wire;
    end
endmodule

module bits_left_calculator(
    input clk,
    input [1:0] sel,
    input [`mdpe_in_bram_acc_precision_log-1:0] precision,
    input [`mdpe_in_bram_acc_precision_log-1:0] a0_plus_a1_precision,
    input [`mdpe_in_bram_acc_precision_log-1:0] reduction_precision,
    output reg [`mdpe_in_bram_acc_precision_log-1:0] bits_left
);

    reg [`mdpe_in_bram_acc_precision_log-1:0] bits_left_wire;
    wire [`mdpe_in_bram_acc_precision_log-1:0] decremented_bits_left;

    assign decremented_bits_left = bits_left - 1;

    always @(*) begin
        case(sel)
            2'b00: bits_left_wire <= decremented_bits_left;
            2'b01: bits_left_wire <= precision;
            2'b10: bits_left_wire <= a0_plus_a1_precision;
            2'b11: bits_left_wire <= reduction_precision;
        endcase
    end

    always @(posedge clk) begin
        bits_left <= bits_left_wire;
    end
endmodule


module src1_addr_generator(
    input clk,
    input [2:0] internal_sel,
    input [1:0] imac_src1_addr_sel,
    input [6:0] a0_addr,
    input [6:0] a1_addr,
    input [6:0] a0_plus_a1_addr,
    input [6:0] imac_addr,
    output reg [6:0] addr_reg
);

    reg [6:0] addr_wire, imac_src1_addr, internal_addr;
    wire [6:0] incremented_addr;
    
    assign incremented_addr = addr_reg + 1; 
    
    always @(*) begin
        case (imac_src1_addr_sel)
            2'b01: imac_src1_addr <= a0_addr;
            2'b10: imac_src1_addr <= a1_addr;
            2'b11: imac_src1_addr <= a0_plus_a1_addr;
            default: imac_src1_addr <= a0_addr;
        endcase
    end

    always @(*) begin
        case (internal_sel[1:0])
            2'b00: internal_addr <= incremented_addr;
            2'b01: internal_addr <= a0_addr;
            2'b11: internal_addr <= imac_addr;
            default: internal_addr <= imac_addr;
        endcase
    end

    always @(*) begin
        case (internal_sel[2])
            1'b0: addr_wire <= imac_src1_addr;
            1'b1: addr_wire <= internal_addr;
        endcase
    end

    always @(posedge clk) begin
        addr_reg <= addr_wire;
    end

endmodule

module addr_generator(
    input clk,
    input [1:0] sel,
    input [6:0] in1,
    input [6:0] in2,
    input [6:0] in3,
    output reg [6:0] addr_reg
);

    localparam inc_addr = 2'b00;
    localparam in1_sel = 2'b01;
    localparam in2_sel = 2'b10;
    localparam in3_sel = 2'b11;

    reg [6:0] addr_wire;
    wire [6:0] incremented_addr;

    assign incremented_addr = addr_reg + 1; 

    always @(*) begin
        case(sel)
            inc_addr: addr_wire <= incremented_addr;
            in1_sel: addr_wire <= in1;
            in2_sel: addr_wire <= in2;
            in3_sel: addr_wire <= in3;
        endcase
    end

    always @(posedge clk) begin
        addr_reg <= addr_wire;
    end
endmodule
</%doc>
