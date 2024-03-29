<%!
    import math

    num_tiles = 2 #CHANGE THIS
    num_ldpes = 16 #CHANGE THIS
    num_dsp_per_ldpe = 0 #NOT USED #CHANGE THIS
    num_reduction_stages = int(math.log2(num_tiles))
%>

module MVU (
    input clk,
    input[`NUM_LDPES-1:0] start,
    input[`NUM_LDPES-1:0] reset,

    input [`VRF_AWIDTH-1:0] vrf_wr_addr,        
    input [`VRF_AWIDTH-1:0] vrf_read_addr,      
    input [`VRF_DWIDTH-1:0] vec,               
     
% for i in range(num_tiles):
    input vrf_wr_enable_tile_${i},
    input vrf_readn_enable_tile_${i}, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_${i},
% endfor
    
    input [`MRF_DWIDTH*`NUM_LDPES*`NUM_TILES-1:0] mrf_in,                 
    input[`NUM_TILES*`NUM_LDPES-1:0] mrf_we,               
    input [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr,

    input [`NUM_TILES*`NUM_LDPES-1:0] mrf_we_for_dram,
    input [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_for_dram,
    output [`NUM_TILES*`MRF_DWIDTH*`NUM_LDPES-1:0] mrf_outa_to_dram,
    
    output [`ORF_DWIDTH-1:0] mvm_result,
    output out_data_available
);
% for i in range(num_tiles):
    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_${i};
    wire[`NUM_LDPES-1:0] out_data_available_mvu_tile_${i};

    MVU_tile tile_${i}(.clk(clk),
    .start(start),
    .reset(reset),
    .out_data_available(out_data_available_mvu_tile_${i}), //WITH TAG
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .vrf_data_out(vrf_data_out_tile_${i}), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_${i}), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_${i}), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .mrf_in(mrf_in[${i+1}*`MRF_DWIDTH*`NUM_LDPES-1:${i}*`MRF_DWIDTH*`NUM_LDPES]),
    .mrf_we(mrf_we[${i+1}*`NUM_LDPES-1:${i}*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[${i+1}*`NUM_LDPES*`MRF_AWIDTH-1:${i}*`NUM_LDPES*`MRF_AWIDTH]),

    .mrf_we_for_dram(mrf_we_for_dram[${i+1}*`NUM_LDPES-1:${i}*`NUM_LDPES]),
    .mrf_addr_for_dram(mrf_addr_for_dram[${i+1}*`NUM_LDPES*`MRF_AWIDTH-1:${i}*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_outa_to_dram(mrf_outa_to_dram[${i+1}*`NUM_LDPES*`MRF_DWIDTH-1:${i}*`NUM_LDPES*`MRF_DWIDTH]),

    .result(result_mvm_${i}) //WITH TAG
    );
%endfor

    wire[`NUM_LDPES*`OUT_DWIDTH-1:0] reduction_unit_output;
    wire[`NUM_LDPES-1:0] out_data_available_reduction_tree;

    mvm_reduction_unit mvm_reduction(
      .clk(clk),
      .start(out_data_available_mvu_tile_0),
      .reset_reduction_mvm(reset),
% for i in range(num_tiles):
      .inp${i}(result_mvm_${i}),
% endfor
      .result_mvm_final_stage(reduction_unit_output),
      .out_data_available(out_data_available_reduction_tree)
    );
    
    assign mvm_result = reduction_unit_output;
    assign out_data_available = out_data_available_reduction_tree[0];
    
endmodule


module MVU_tile (
    input clk,
    input [`NUM_LDPES-1:0] start,
    input [`NUM_LDPES-1:0] reset,
    input vrf_wr_enable,
    input [`VRF_AWIDTH-1:0] vrf_wr_addr,
    input [`VRF_AWIDTH-1:0] vrf_read_addr,
    input [`VRF_DWIDTH-1:0] vec,
    output[`VRF_DWIDTH-1:0] vrf_data_out,
    input [`NUM_LDPES*`MRF_DWIDTH-1:0] mrf_in,
    input vrf_readn_enable,
    input[`NUM_LDPES-1:0] mrf_we,
    input [`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr,

    input[`NUM_LDPES-1:0] mrf_we_for_dram,
    input [`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_for_dram,
    output [`MRF_DWIDTH*`NUM_LDPES-1:0] mrf_outa_to_dram,

    output [`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result,
    output [`NUM_LDPES-1:0] out_data_available
);

    wire [`VRF_DWIDTH-1:0] ina_fake;
   
  
    wire [`VRF_DWIDTH-1:0] vrf_outa_wire;

    //reg [`VRF_AWIDTH-1:0] vrf_rd_addr;

    // Port A is used to feed LDPE and port B to load vector from DRAM.
    VRF vrf (
        .clk(clk),
        .addra(vrf_read_addr),
        .ina(ina_fake),
        .wea(vrf_readn_enable),
        .outa(vrf_outa_wire),
        .addrb(vrf_wr_addr),
        .inb(vec),
        .web(vrf_wr_enable),
        .outb(vrf_data_out) 
    );

    genvar i;
    generate
        for (i=1; i<=`NUM_LDPES; i=i+1) begin
            compute_unit unit (
                .clk(clk),
                .start(start[i-1]),
                .reset(reset[i-1]),
                .out_data_available(out_data_available[i-1]),
                .vec(vrf_outa_wire),
                .mrf_in(mrf_in[i*`MRF_DWIDTH-1:(i-1)*`MRF_DWIDTH]),
                .mrf_we(mrf_we[i-1]),
                .mrf_addr(mrf_addr[i*`MRF_AWIDTH-1:(i-1)*`MRF_AWIDTH]),

                .mrf_addr_for_dram(mrf_addr_for_dram[(i)*`MRF_AWIDTH-1:(i-1)*`MRF_AWIDTH]),
                .mrf_outa_to_dram(mrf_outa_to_dram[(i)*`MRF_DWIDTH-1:(i-1)*`MRF_DWIDTH]),
                .mrf_we_for_dram(mrf_we_for_dram[i-1]),
 
                .result(result[i*`LDPE_USED_OUTPUT_WIDTH-1:(i-1)*`LDPE_USED_OUTPUT_WIDTH])
            );
        end
    endgenerate

endmodule

module compute_unit (
    input clk,
    input start,
    input reset,
    input [`VRF_DWIDTH-1:0] vec,
    input [`MRF_DWIDTH-1:0] mrf_in,
    input [`MRF_AWIDTH-1:0] mrf_addr_for_dram, //new
    input mrf_we, mrf_we_for_dram, //new
    input [`MRF_AWIDTH-1:0] mrf_addr,
    output [`LDPE_USED_OUTPUT_WIDTH-1:0] result,
    output [`MRF_DWIDTH-1:0] mrf_outa_to_dram, //new
    output out_data_available
);

    // Port A of BRAMs is used for feed DSPs and Port B is used to load matrix from off-chip memory
    reg [4:0] num_cycles_mvm; 

    //always@(posedge clk) begin
    //    if((reset==1'b1) || (start==1'b0)) begin
    //        num_cycles_mvm <= 0;
    //        out_data_available <= 0;
    //    end
    //    else begin
    //        if(num_cycles_mvm==`NUM_MVM_CYCLES-1) begin
    //            out_data_available <= 1;
    //        end
    //        else begin
    //            num_cycles_mvm <= num_cycles_mvm + 1;
    //        end
    //    end
    //end
  
    // Port B of BRAMs is used for feed DSPs and Port A is used to interact with DRAM

  
    wire [`MRF_DWIDTH-1:0] mrf_outb_wire;

    wire [`LDPE_USED_INPUT_WIDTH-1:0] ax_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] ay_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] bx_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] by_wire;
    wire [2*`LDPE_USED_INPUT_WIDTH-1:0] ax_bx_wire;
    wire [2*`LDPE_USED_INPUT_WIDTH-1:0] ay_by_wire;
    assign ax_bx_wire = {ax_wire, bx_wire};
    assign ay_by_wire = {ay_wire, by_wire};

    // Wire connecting LDPE output to Output BRAM input
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] ldpe_result;
    
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] inb_fake_wire;

    // First 4 BRAM outputs are given to ax of 4 DSPs and next 4 BRAM outputs are given to bx of DSPs

    // Connection MRF and LDPE wires for matrix data
    // 'X' pin is used for matrix
    /* If there are 4 DSPSs, bit[31:0] of mrf output contain ax values for the 4 DSPs, bit[63:32] contain bx values and so on. With a group of ax values, bit[7:0] contain ax value for DSP1, bit[15:8] contain ax value for DSP2 and so on. */
    assign ax_wire = mrf_outb_wire[1*`LDPE_USED_INPUT_WIDTH-1:0*`LDPE_USED_INPUT_WIDTH];
    assign bx_wire = mrf_outb_wire[2*`LDPE_USED_INPUT_WIDTH-1:1*`LDPE_USED_INPUT_WIDTH];

    // Connection of VRF and LDPE wires for vector data
    // 'Y' pin is used for vector
    assign ay_wire = vec[`LDPE_USED_INPUT_WIDTH-1:0];
    assign by_wire = vec[2*`LDPE_USED_INPUT_WIDTH-1:1*`LDPE_USED_INPUT_WIDTH];

    wire [`MRF_DWIDTH-1:0] mrf_in_fake;
    
    MRF mrf (
        .clk(clk),
        .addra(mrf_addr_for_dram),
        .addrb(mrf_addr),
        .ina(mrf_in),
        .inb(mrf_in_fake),
        .wea(mrf_we_for_dram),
        .web(mrf_we),
        .outa(mrf_outa_to_dram),
        .outb(mrf_outb_wire)
    );

    wire done_tensor_slice_NC;
    wire [63:0] a_data_in_NC;
    wire [63:0] b_data_in_NC;
    wire [63:0] a_data_out_NC;
    wire [63:0] b_data_out_NC;
    wire [3:0] flags_NC;
    wire [35:0] extra_out_NC;

`ifdef tensor_slice_hard_block
    
    tensor_slice_int8 tensor_slice(
      .clk(clk),
      .reset(reset),
      .pe_reset(reset),
      .start_mat_mul(start),
      .done_mat_mul(done_tensor_slice_NC),
      .a_data(ax_bx_wire),         
      .b_data(ay_by_wire),        
      .a_data_in(a_data_in_NC), 
      .b_data_in(b_data_in_NC),
      .c_data_out(ldpe_result), 
      .a_data_out(a_data_out_NC),      //
      .b_data_out(b_data_out_NC),
      .flags(flags_NC),
      .c_data_available(out_data_available),
      .validity_mask_a_rows(8'hff),
      .validity_mask_a_cols_b_rows(8'hff),
      .validity_mask_b_cols(8'hff),
      .slice_mode(`SLICE_MODE_TENSOR),
      .slice_dtype(`DTYPE_INT8),
      .op(3'b000), //matmat
      .preload(1'b0),
      .final_mat_mul_size(8'd8),
      .a_loc(5'd0),
      .b_loc(5'd0),
      .no_rounding(1'b0),
      .extra_out(extra_out_NC)
    );

`else
   //Just for simulation
   assign ldpe_result = ax_bx_wire + ay_by_wire;

`endif


    //LDPE ldpe (
    //    .clk(clk),
    //    .reset(reset),
    //    .ax(ax_wire),
    //    .ay(ay_wire),
    //    .bx(bx_wire),
    //    .by(by_wire),
    //    .ldpe_result(ldpe_result)
    //);
    assign result = ldpe_result;
    
endmodule

module myadder #(
    parameter INPUT_WIDTH = `DSP_USED_INPUT_WIDTH,
    parameter OUTPUT_WIDTH = `DSP_USED_OUTPUT_WIDTH
)
(
    input [INPUT_WIDTH-1:0] a,
    input [INPUT_WIDTH-1:0] b,
    input reset,
    input start,
    input clk,
    output reg [OUTPUT_WIDTH-1:0] sum,
    output reg out_data_available
);

    always@(posedge clk) begin
        if((reset==1) || (start==0)) begin
            sum <= 0;
            out_data_available <= 0;
        end
        else begin
            out_data_available <= 1;
            sum <= {a[INPUT_WIDTH-1],a}+{b[INPUT_WIDTH-1],b};
        end
    end

endmodule


module VRF #(parameter VRF_AWIDTH = `VRF_AWIDTH, parameter VRF_DWIDTH = `VRF_DWIDTH) (
    input clk,
    input [VRF_AWIDTH-1:0] addra, 
    input [VRF_AWIDTH-1:0] addrb,
    input [VRF_DWIDTH-1:0] ina,
    input [VRF_DWIDTH-1:0] inb,
    input wea, web,
    output [VRF_DWIDTH-1:0] outa,
    output [VRF_DWIDTH-1:0] outb
);

    dp_ram # (
        .AWIDTH(VRF_AWIDTH),
        .DWIDTH(VRF_DWIDTH)
    ) vec_mem (
        .clk(clk),
        .addra(addra),
        .ina(ina),
        .wea(wea),
        .outa(outa),
        .addrb(addrb),
        .inb(inb),
        .web(web),
        .outb(outb)
    );
endmodule

module MRF (
    input clk,
    input [`MRF_AWIDTH-1:0] addra, 
    input [`MRF_AWIDTH-1:0] addrb,
    input [`MRF_DWIDTH-1:0] ina, 
    input [`MRF_DWIDTH-1:0] inb,
    input wea, web,
    output [`MRF_DWIDTH-1:0] outa,
    output [`MRF_DWIDTH-1:0] outb
);

    dp_ram # (
            .AWIDTH(`MRF_AWIDTH),
            .DWIDTH(`MRF_DWIDTH)
        ) vec_mem (
            .clk(clk),
            .addra(addra),
            .ina(ina),
            .wea(wea),
            .outa(outa),
            .addrb(addrb),
            .inb(inb),
            .web(web),
            .outb(outb)
        );

endmodule


//////////////////////////////////
// Dual port RAM
//////////////////////////////////

module dp_ram # (
    parameter AWIDTH = 10,
    parameter DWIDTH = 16
) (
    input clk,
    input [AWIDTH-1:0] addra, addrb,
    input [DWIDTH-1:0] ina, inb,
    input wea, web,
    output reg [DWIDTH-1:0] outa, outb
);

`ifndef hard_mem 

reg [DWIDTH-1:0] ram [((1<<AWIDTH)-1):0];

// Port A
always @(posedge clk)  begin

    if (wea) begin
        ram[addra] <= ina;
    end

    outa <= ram[addra];
end

// Port B
always @(posedge clk)  begin

    if (web) begin
        ram[addrb] <= inb;
    end

    outb <= ram[addrb];
end

`else


defparam u_dual_port_ram.ADDR_WIDTH = AWIDTH;
defparam u_dual_port_ram.DATA_WIDTH = DWIDTH;


dual_port_ram u_dual_port_ram(
.addr1(addra),
.we1(wea),
.data1(ina),
.out1(outa),
.addr2(addrb),
.we2(web),
.data2(inb),
.out2(outb),
.clk(clk)
);

`endif
endmodule

//////////////////////////////////
// Single port RAM
//////////////////////////////////

module sp_ram # (
    parameter AWIDTH = 9,
    parameter DWIDTH = 32
) (
    input clk,
    input [AWIDTH-1:0] addr,
    input [DWIDTH-1:0] in,
    input we,
    output reg [DWIDTH-1:0] out
);

`ifndef hard_mem

reg [DWIDTH-1:0] ram [((1<<AWIDTH)-1):0];

always @(posedge clk)  begin

    if (we) begin
        ram[addr] <= in;
    end

    out <= ram[addr];
end

`else

defparam u_single_port_ram.ADDR_WIDTH = AWIDTH;
defparam u_single_port_ram.DATA_WIDTH = DWIDTH;

single_port_ram u_single_port_ram(
.addr(addr),
.we(we),
.data(in),
.out(out),
.clk(clk)
);

`endif
endmodule

module mvm_reduction_unit(
% for i in range(num_tiles):
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp${i},
% endfor
    output [`OUT_DWIDTH*`NUM_LDPES-1:0] result_mvm_final_stage,
    output [`NUM_LDPES-1:0] out_data_available,
    //CONTROL SIGNALS
    input clk,
    input[`NUM_LDPES-1:0] start,
    input[`NUM_LDPES-1:0] reset_reduction_mvm
);

/*
    reg[3:0] num_cycles_reduction;

    always@(posedge clk) begin
        if((reset_reduction_mvm[0]==1'b1) || (start[0]==1'b0)) begin
            num_cycles_reduction<=0;
            out_data_available<=0;
        end
        else begin
            if(num_cycles_reduction==`NUM_REDUCTION_CYCLES-1) begin
                out_data_available <= {`NUM_LDPES{1'b1}};
            end
            else begin
                num_cycles_reduction <= num_cycles_reduction + 1;
            end
        end
    end
*/

    genvar i;

%for i in range(0,num_tiles,2):
    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_${int(i/2)}_stage_1;
    wire[`NUM_LDPES-1:0] out_data_available_${int(i/2)}_stage_1;

    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_initial_${int(i/2)} (
              .a(inp${i}[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .b(inp${i+1}[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .clk(clk),
              .reset(reset_reduction_mvm[i-1]),
              .start(start[i-1]),
              .out_data_available(out_data_available_${int(i/2)}_stage_1[i-1]),
              .sum(reduction_output_${int(i/2)}_stage_1[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH])
            );
        end
    endgenerate
%endfor

% for i in range(1,num_reduction_stages):
% for k in range(num_tiles>>(i+1)):
    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_${k}_stage_${i+1};
    wire[`NUM_LDPES-1:0] out_data_available_${k}_stage_${i+1};

    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_${k}_stage_${i} (
              .a(reduction_output_${2*(k)}_stage_${i}[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)]),
              .b(reduction_output_${(2*k)+1}_stage_${i}[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)]),
              .clk(clk),
              .reset(reset_reduction_mvm[i-1]),
              .start(out_data_available_0_stage_${i}[i-1]),
              .out_data_available(out_data_available_${k}_stage_${i+1}[i-1]),
              .sum(reduction_output_${k}_stage_${i+1}[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)])
            );
        end
    endgenerate
%endfor
%endfor

% for i in range(num_ldpes):
assign result_mvm_final_stage[${i+1}*`OUT_DWIDTH-1:${i}*`OUT_DWIDTH] = reduction_output_0_stage_${num_reduction_stages}[${i}*(`DSP_USED_OUTPUT_WIDTH)+`OUT_DWIDTH-1:${i}*(`DSP_USED_OUTPUT_WIDTH)];
% endfor 
assign out_data_available = out_data_available_0_stage_${num_reduction_stages};
endmodule
