<%!
    import math
    import includes
%>\

module mdpe_group (
    input clk,
    input rst,

    // fsm input
    input start,
    input [15:0] meta_data,
    input [2*`mdpe_num_mvm_ram_per_mdpe-1:0] src1_addr_sel,
    input [`mdpe_num_mvm_ram_per_mdpe-1:0] is_non_zero,
    
    // fsm output
    output get_a0_a1_addr,
    output get_src1_addr_sel,
    output done,

    output out_vld,
    output [`mdpe_group_out_dwidth-1:0] out_data
);

    wire [`num_mdpe-1:0] get_a0_a1_addr_bus;
    assign get_a0_a1_addr = get_a0_a1_addr_bus[0];

    wire [`num_mdpe-1:0] get_src1_addr_sel_bus;
    assign get_src1_addr_sel = get_src1_addr_sel_bus[0];

    wire [`num_mdpe-1:0] done_bus;
    assign done = done_bus[0];

% for ii in range(includes.num_mdpe):
    mdpe u_mdpe_${ii} (
        .clk(clk),
        .rst(rst),
        .start(start),
        .meta_data(meta_data),
        .src1_addr_sel(src1_addr_sel),
        .is_non_zero(is_non_zero),
        .get_a0_a1_addr(get_a0_a1_addr_bus[${ii}]),
        .get_src1_addr_sel(get_src1_addr_sel_bus[${ii}]),
        .done(done_bus[${ii}]),
        .out_vld(out_vld),
        .out_data(out_data[(${ii}+1)*`mdpe_out_dwidth-1:${ii}*`mdpe_out_dwidth])
    );

% endfor
endmodule


module mdpe (
    input clk,
    input rst,

    // fsm input
    input start,
    input [15:0] meta_data,
    input [2*`mdpe_num_mvm_ram_per_mdpe-1:0] src1_addr_sel,
    input [`mdpe_num_mvm_ram_per_mdpe-1:0] is_non_zero,
    
    // fsm output
    output get_a0_a1_addr,
    output get_src1_addr_sel,
    output done,

    output out_vld,
    output [`mdpe_out_dwidth-1:0] out_data
);
    /* MDPE is a group of single ported BRAMs. A perticular column of all BRAMs in an MDPE contain the partial sum corresponding to the same output. Hence, the partial sums in a particular column of all BRAMs must be added to get the full sum (final output). There are NUM_BRAMS_PER_MDPE number of BRAMs in an MDPE
    */

    wire [`mdpe_mvm_ram_unit_dwidth-1:0] instr;
    wire [`mdpe_num_mvm_ram_per_mdpe-1:0] we;
    wire [`mdpe_num_fsm_per_mdpe-1:0] get_a0_a1_addr_bus;
    assign get_a0_a1_addr = get_a0_a1_addr_bus[0];
    wire [`mdpe_num_fsm_per_mdpe-1:0] get_src1_addr_sel_bus;
    assign get_src1_addr_sel = get_src1_addr_sel_bus[0];

    wire [`mdpe_mvm_ram_unit_awidth-1:0] mvm_ram_unit_rd_addr;
    wire [`mdpe_num_fsm_per_mdpe-1:0] adder_tree_unit_inp_vld;
    wire [`mdpe_num_fsm_per_mdpe-1:0] flush_adder_tree;
    wire [`mdpe_num_fsm_per_mdpe-1:0] done_bus;
    assign done = done_bus[0];

//only leaving instance 0 here 
% for ii in range(1):
    fsm_mdpe_top u_fsm_mdpe_top_${ii} (
        .clk(clk),
        .rst(rst),
        .start(start),

        .meta_data(meta_data),
        .src1_addr_sel(src1_addr_sel[(${ii}+1)*`mdpe_fsm_src1_addr_sel_width-1:${ii}*`mdpe_fsm_src1_addr_sel_width]),
        .is_non_zero(is_non_zero[(${ii}+1)*`mdpe_num_mvm_ram_per_fsm-1:${ii}*`mdpe_num_mvm_ram_per_fsm]),
        .instr(instr[(${ii}+1)*`mdpe_fsm_compute_ram_iwidth-1:${ii}*`mdpe_fsm_compute_ram_iwidth]),
        .execute_instr(we[(${ii}+1)*`mdpe_num_mvm_ram_per_fsm-1:${ii}*`mdpe_num_mvm_ram_per_fsm]),
        .get_a0_a1_addr(get_a0_a1_addr_bus[${ii}]),
        .get_src1_addr_sel(get_src1_addr_sel_bus[${ii}]),

        .mvm_ram_unit_rd_addr(mvm_ram_unit_rd_addr),
        .adder_tree_input_valid(adder_tree_unit_inp_vld[${ii}]),
        .flush_adder_tree(flush_adder_tree[${ii}]),

        .done(done_bus[${ii}])
    );
% endfor



    wire [`mdpe_mvm_ram_unit_dwidth-1:0] mvm_ram_unit_rd_data;
    wire [`mdpe_adder_tree_unit_in_width-1:0] adder_tree_unit_in;
    wire [`mdpe_adder_tree_unit_in_width-1:0] wire_rearrager_out;
    wire out_ram_we;
    reg [`mdpe_out_ram_awidth-1:0] out_ram_wr_addr;
    wire [`mdpe_out_dwidth-1:0] out_ram_wr_data;

    mvm_ram_unit u_mvm_ram_unit (
        .clk(clk),
        .rst(rst),
        .wr_addr(9'd511),
        //.wr_data(instr),
        //.we(we),
        //.rd_addr(mvm_ram_unit_rd_addr),
        .start(start),
        .meta_data(meta_data),
        .src1_addr_sel(src1_addr_sel),
        .is_non_zero(is_non_zero),
        .rd_data(mvm_ram_unit_rd_data)
    );

    wire_rearrager u_wire_rearranger (
        .in(mvm_ram_unit_rd_data),
        .out(wire_rearrager_out)
    );

    assign adder_tree_unit_in = flush_adder_tree[0] ? 0 : wire_rearrager_out;

    adder_tree_unit u_adder_tree_unit (
        .clk(clk),
        .rst(rst),
        //.inp_vld(adder_tree_unit_inp_vld[0]),
        .inp_vld(1'b1),  //HACK HACK HACK. For some reason, when this is connected as above, the whole of mvm_ram_unit gets optimized out
        .in(adder_tree_unit_in),
        .outp_vld(out_ram_we), 
        .out(out_ram_wr_data) 
    );

   assign out_data = out_ram_wr_data;
   assign out_vld = out_ram_we;

endmodule

module wire_rearrager (
    input [`mdpe_mvm_ram_unit_dwidth-1:0] in,
    output [`mdpe_adder_tree_unit_in_width-1:0] out
);

    // serial adder number corresponds to compute ram pin number (i)
    // serial adder pin number corresponds to compute ram number (k)

% for kk in range(includes.mdpe_num_mvm_ram_per_mdpe):
    % for ii in range(includes.mdpe_num_adder_tree):
    assign out[${ii}*`mdpe_adder_tree_in_width+${kk}] = in[${kk}*`mdpe_mvm_ram_dwidth+${ii}];
    % endfor
% endfor
endmodule

module adder_tree_unit(
    input clk,
    input rst,
    
    input inp_vld,
    input [`mdpe_adder_tree_unit_in_width-1:0] in,

    output outp_vld,
    output [`mdpe_adder_tree_unit_out_width-1:0] out
);
% for ii in range(includes.mdpe_num_adder_tree):
    popcount u_popcount_${ii} (
        .clk(clk),
        .rst(rst),
        .inp_vld(inp_vld),
        .inp(in[(${ii}+1)*`mdpe_adder_tree_in_width-1:${ii}*`mdpe_adder_tree_in_width]),
        .outp_vld(outp_vld),
        .sum(out[(${ii}+1)*`mdpe_adder_tree_out_width-1:${ii}*`mdpe_adder_tree_out_width])
    );
% endfor
endmodule


module mvm_ram_unit(
    input clk,
    input rst,
    // input (wr) port
    input [`mdpe_mvm_ram_unit_awidth-1:0] wr_addr,
    //input [`mdpe_mvm_ram_unit_dwidth-1:0] wr_data,
    //input [`mdpe_num_mvm_ram_per_mdpe-1:0] we,
   
    input start,
    input [15:0] meta_data,
    input [2*`mdpe_num_mvm_ram_per_mdpe-1:0] src1_addr_sel,
    input [`mdpe_num_mvm_ram_per_mdpe-1:0] is_non_zero,

    // output (rd) port
    //input [`mdpe_mvm_ram_unit_awidth-1:0] rd_addr,
    output [`mdpe_mvm_ram_unit_dwidth-1:0] rd_data
);

<%!
  ratio = int(includes.mdpe_num_mvm_ram_per_mdpe / includes.mdpe_num_fsm_per_mdpe)
%>\

% for ii in range(includes.mdpe_num_fsm_per_mdpe):
    wire [`mdpe_num_mvm_ram_per_fsm*`mdpe_compute_ram_iwidth-1:0] instr_${ii};
    wire [`mdpe_num_mvm_ram_per_fsm-1:0] we_${ii};
    wire [`mdpe_mvm_ram_awidth-1:0] mvm_ram_unit_rd_addr_${ii};
    wire get_a0_a1_addr_${ii}_NC;
    wire get_src1_addr_sel_${ii}_NC;
    wire adder_tree_input_valid_${ii}_NC;
    wire flush_adder_tree_${ii}_NC;
    wire done_${ii}_NC;
    fsm_mdpe_top u_fsm_mdpe_top_${ii} (
        .clk(clk),
        .rst(rst),
        .start(start),

        .meta_data(meta_data),
        .src1_addr_sel(src1_addr_sel[(${ii}+1)*`mdpe_fsm_src1_addr_sel_width-1:${ii}*`mdpe_fsm_src1_addr_sel_width]),
        .is_non_zero(is_non_zero[(${ii}+1)*`mdpe_num_mvm_ram_per_fsm-1:${ii}*`mdpe_num_mvm_ram_per_fsm]),
        //.instr(instr[(${ii}+1)*`mdpe_fsm_compute_ram_iwidth-1:${ii}*`mdpe_fsm_compute_ram_iwidth]),
        .instr(instr_${ii}),
        //.execute_instr(we[(${ii}+1)*`mdpe_num_mvm_ram_per_fsm-1:${ii}*`mdpe_num_mvm_ram_per_fsm]),
        .execute_instr(we_${ii}),
        .get_a0_a1_addr(get_a0_a1_addr_${ii}_NC),
        .get_src1_addr_sel(get_src1_addr_sel_${ii}_NC),

        //.mvm_ram_unit_rd_addr(mvm_ram_unit_rd_addr[(${ii}+1)*`mdpe_fsm_mvm_ram_awidth-1:${ii}*`mdpe_fsm_mvm_ram_awidth]),
        .mvm_ram_unit_rd_addr(mvm_ram_unit_rd_addr_${ii}),
        .adder_tree_input_valid(adder_tree_input_valid_${ii}_NC),
        .flush_adder_tree(flush_adder_tree_${ii}_NC),

        .done(done_${ii}_NC)
    );


% for jj in range(ratio):

<%
  val = ii*ratio + jj 
%>\

    compute_ram_wrapper u_mvm_ram_${val} (
        .clk(clk),
        .wr_addr(wr_addr),
        //.wr_data(wr_data[(${ii}+1)*`mdpe_mvm_ram_dwidth-1:${ii}*`mdpe_mvm_ram_dwidth]),
        .wr_data(instr_${ii}[(${jj}+1)*`mdpe_mvm_ram_dwidth-1:${jj}*`mdpe_mvm_ram_dwidth]),
        //.we(we[${ii}]),
        .we(we_${ii}[${jj}]),
        //.rd_addr(rd_addr),
        .rd_addr(mvm_ram_unit_rd_addr_${ii}),
        .rd_data(rd_data[(${val}+1)*`mdpe_mvm_ram_dwidth-1:${val}*`mdpe_mvm_ram_dwidth])
    );

% endfor

% endfor

endmodule

module compute_ram_wrapper (
    input clk,

    // input (wr) port
    input [`mdpe_compute_ram_awidth-1:0] wr_addr,
    input [`mdpe_compute_ram_dwidth-1:0] wr_data,
    input we,

    // output (rd) port
    input [`mdpe_compute_ram_awidth-1:0] rd_addr,
    output [`mdpe_compute_ram_dwidth-1:0] rd_data
);
    wire pe_out_fake;

    compute_ram u_compute_ram (
        .addr1(wr_addr),
        .d1(wr_data),
        .we1(we),
        .addr2(rd_addr),
        .q2(rd_data),
        .pe_in(1'b0),
        .pe_out(pe_out_fake),
        .clk(clk)
    );

endmodule

module compute_ram (
    //write port
    addr1, 
    d1, 
    we1, 
    //read port
    addr2, 
    q2,  
    //direct interconnect
    pe_in,
    pe_out,
    clk
);

    input [`AWIDTH-1:0] addr1;
    input [`CRAM_DWIDTH-1:0] d1;
    input we1;

    input [`AWIDTH-1:0] addr2;
    output [`CRAM_DWIDTH-1:0] q2;

    input pe_in;
    output reg pe_out;
    input clk;

    `ifdef VCS 
    wire [`CRAM_DWIDTH-1:0] d;
    assign d = d1;
    wire we;
    assign we = we1;
    reg [`CRAM_DWIDTH-1:0] q;
    assign q2 = q;
    wire [`AWIDTH-1:0] addr;
    assign addr = we ? addr1 : addr2;


    //ram that matches external interface
    reg [`CRAM_DWIDTH-1:0] ram[((1<<`AWIDTH)-1):0];

    //ram that is based on the internal configuration
    //a 160x128 ram
    reg [159:0] ram_internal[127:0];

    wire compute_mode;
    assign compute_mode = (addr == `CMD_ADDR);

    /////////////////////////////////////////////////////
    // Compute RAM behavioral model
    /////////////////////////////////////////////////////
    //If Address is `CMD_ADDR, then the data contains the command.

    //Let's say the structure of the commnd is:
    //<PREDICATE> <WRITE_SEL> <PORT> <C_EN> <T_EN> <ALU_TRUTH_TABLE> <dst_row>, <src2_row>, <src1_row>
    //   2 bits     2 bits     1 bit  1 bit  1 bit     4 bits          7 bits     7 bits      7 bits

    //Row addresses are 7 bits because the organization is 128x128
    //In some cases like COPY or SHIFT, one of the
    //src rows will be blank.

    //Example:
    //TAG <> <> <> <> <> ALU_CMD_FOR_ADD 125, 113, 191 
    //This command will run the operation stored in the ALU
    //if TAG is 1 
    //If ALU_CMD_FOR_ADD corresponds to the specific truth table values
    //to perform SUM, this command will add contents of row 191 and row 113
    //and write the result to row 125, if TAG latch was 1.

    wire [1:0] predicate;
    wire [1:0] write_sel;
    wire port;
    wire c_en;
    wire t_en;
    wire [3:0] truth_table;
    wire [6:0] dst;
    wire [6:0] src2;
    wire [6:0] src1;

    assign predicate = d[39:38];
    assign write_sel = d[29:28];
    assign port = d[27];
    assign c_en      = d[26];
    assign t_en      = d[25];
    assign truth_table    = d[24:21];
    assign dst       = d[20:14];
    assign src2      = d[13:7];
    assign src1      = d[6:0];

    //there is one carry latch/ff in each physical ram column
    reg [160:0] carry;

    //temporary
    reg [159:0] temp[127:0];
    integer i;
    //behavioral reset
    initial begin
        carry = 0;
        for (i=0; i<160; i = i +1) begin
            temp[i] = 0;
        end
    end

    wire [5:0] command;
    assign command = {write_sel, truth_table};

    always @(posedge clk) begin 
        //compute mode
        if (compute_mode) begin

            //Look at what the truth_table is and operate accordingly
            case (truth_table) 
                //Just modelling this as if ALU_CMD configured into
                //the compute_ram is actually ADD
                `ALU_CMD : begin          
                    //if predicate condition is true, then...
                    temp[dst] = ram_internal[src2]^ram_internal[src1]^carry;
                    if(c_en) begin
                        carry <= (ram_internal[src2]&ram_internal[src1])|(ram_internal[src2]&carry)|(ram_internal[src1]&carry);
                    end
                    else begin
                        carry <= 0; 
                    end
                    //update ram_internal and ram
                    ram_internal[dst] <= temp[dst];
                    ram[(dst<<2)+0] <= temp[dst][31:0];
                    ram[(dst<<2)+1] <= temp[dst][63:32];
                    ram[(dst<<2)+2] <= temp[dst][95:64];
                    ram[(dst<<2)+3] <= temp[dst][127:96];
                    ram[(dst<<2)+4] <= temp[dst][159:128];
                end
                `COPY_CMD : begin          
                    //if predicate condition is true, then...
                    temp[dst] = ram_internal[src1];
                    //update ram_internal and ram
                    ram_internal[dst] <= temp[dst];
                    ram[(dst<<2)+0] <= temp[dst][31:0];
                    ram[(dst<<2)+1] <= temp[dst][63:32];
                    ram[(dst<<2)+2] <= temp[dst][95:64];
                    ram[(dst<<2)+3] <= temp[dst][127:96];
                    ram[(dst<<2)+4] <= temp[dst][159:128];
                end
                `LSHIFT_CMD: begin
                    //if predicate condition is true, then...
                    temp[dst] = {ram_internal[src1][158:0], pe_in};
                    pe_out <= ram_internal[src1][127];
                    //update ram_internal and ram
                    ram_internal[dst] <= temp[dst];
                    ram[(dst<<2)+0] <= temp[dst][31:0];
                    ram[(dst<<2)+1] <= temp[dst][63:32];
                    ram[(dst<<2)+2] <= temp[dst][95:64];
                    ram[(dst<<2)+3] <= temp[dst][127:96];
                    ram[(dst<<2)+4] <= temp[dst][159:128];
                end
                `RSHIFT_CMD: begin
                    //if predicate condition is true, then...
                    temp[dst] = {pe_in,ram_internal[src1][159:1]};
                    pe_out <= ram_internal[src1][0];
                    //update ram_internal and ram
                    ram_internal[dst] <= temp[dst];
                    ram[(dst<<2)+0] <= temp[dst][31:0];
                    ram[(dst<<2)+1] <= temp[dst][63:32];
                    ram[(dst<<2)+2] <= temp[dst][95:64];
                    ram[(dst<<2)+3] <= temp[dst][127:96];
                    ram[(dst<<2)+4] <= temp[dst][159:128];
                end
                `NOT_CMD: begin
                    temp[dst] = ~ram_internal[src1];

                    //update ram_internal and ram
                    ram_internal[dst] <= temp[dst];
                    ram[(dst<<2)+0] <= temp[dst][31:0];
                    ram[(dst<<2)+1] <= temp[dst][63:32];
                    ram[(dst<<2)+2] <= temp[dst][95:64];
                    ram[(dst<<2)+3] <= temp[dst][127:96];
                    ram[(dst<<2)+4] <= temp[dst][159:128];
                end
                `AND_CMD: begin
                    temp[dst] = ram_internal[src1]&ram_internal[src2];
                    //update ram_internal and ram
                    ram_internal[dst] <= temp[dst];
                    ram[(dst<<2)+0] <= temp[dst][31:0];
                    ram[(dst<<2)+1] <= temp[dst][63:32];
                    ram[(dst<<2)+2] <= temp[dst][95:64];
                    ram[(dst<<2)+3] <= temp[dst][127:96];
                    ram[(dst<<2)+4] <= temp[dst][159:128];
                end
                `XOR_CMD: begin
                    temp[dst] = ram_internal[src1]^ram_internal[src2];
                    //update ram_internal and ram
                    ram_internal[dst] <= temp[dst];
                    ram[(dst<<2)+0] <= temp[dst][31:0];
                    ram[(dst<<2)+1] <= temp[dst][63:32];
                    ram[(dst<<2)+2] <= temp[dst][95:64];
                    ram[(dst<<2)+3] <= temp[dst][127:96];
                    ram[(dst<<2)+4] <= temp[dst][159:128];
                end
                `OR_CMD: begin
                    temp[dst] = ram_internal[src1]|ram_internal[src2];
                    //update ram_internal and ram
                    ram_internal[dst] <= temp[dst];
                    ram[(dst<<2)+0] <= temp[dst][31:0];
                    ram[(dst<<2)+1] <= temp[dst][63:32];
                    ram[(dst<<2)+2] <= temp[dst][95:64];
                    ram[(dst<<2)+3] <= temp[dst][127:96];
                    ram[(dst<<2)+4] <= temp[dst][159:128];
                end
                //Not modelling anything else for now
                default : begin
                    //$display("%h command is not modelled", command);
                end
            endcase

        end

        //memory mode
        else begin 

          if (we) begin
            ram[addr] <= d;
            //Also update ram_internal
            case (addr[1:0]) 
            2'b00 : ram_internal[addr[`AWIDTH-1:2]][1*`CRAM_DWIDTH-1:0*`CRAM_DWIDTH] <= d;
            2'b01 : ram_internal[addr[`AWIDTH-1:2]][2*`CRAM_DWIDTH-1:1*`CRAM_DWIDTH] <= d;
            2'b10 : ram_internal[addr[`AWIDTH-1:2]][3*`CRAM_DWIDTH-1:2*`CRAM_DWIDTH] <= d;
            2'b11 : ram_internal[addr[`AWIDTH-1:2]][4*`CRAM_DWIDTH-1:3*`CRAM_DWIDTH] <= d;
            endcase
          end
          else begin
            q <= ram[addr];
          end

        end  

    end

    `else

    compute_ram_simple_dp u_compute_ram(
    .addr1(addr1),
    .we1(we1),
    .data1(d1),
    .addr2(addr2),
    .out2(q2),
    .pe_in(pe_in),
    .pe_out(pe_out),
    .clk(clk)
    );

    `endif

endmodule



