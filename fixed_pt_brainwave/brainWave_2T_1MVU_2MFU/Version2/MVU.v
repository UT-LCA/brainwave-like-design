/*******************************************************************************
Baseline architecture for Matrix Vector Multiplication.

precision: 8 bits
FPGA: AGILEX TODO: mention the model
DSP configuration: 4 9*9 multipliers
matrix BRAM configuration: 1024*16 true dual port
vector BRAM configuration: 1024*16 true dual port
output BRAM configuration: 512*32 single port

Each DSP has total 8 inputs: 4 matrix values and 4 vector values. Each BRAM can provide 2 values.

number of DSPs per LDPE = 4
number of BRAMs per DSP = 2
number of LDPEs = 4

For matrix:
number of MRFs per LDPE = 1 (always)
total MRFs = number of MRFs per LDPE * number of LDPEs = 4
number of BRAMs per MRF = number of BRAMs per DSP * number of DSPs per LDPE = 8
total matrix BRAMs = total MRFs * number of BRAMs per MRF = 32

Each DSP requires 4 vector values per cycle. Therefore, each LDPE requires 16 vector values per cycle. Since, each row of matrix is assigned to a LDPE, the same 16 vector values are broadcasted to all LDPEs. Hence the VRF should be able to provide 16 values in 1 cycle. Each BRAM can provide 2 vector values. Hence, VRF requires 8 BRAMs. 

For vector:
number of BRAMs per DSP = 2
total VRFs = 1 (always)
number of BRAMs per VRFs = 8
total vector BRAMs = total VRFs * number of BRAMs per VRFs = 8

We assume 32-bit accumulation. Each LDPE uses 1 BRAM to store the output.

for output:
number of BRAMs per LDPE = 1
total output BRAMs = number of LDPEs = 4


*******************************************************************************/

`include "includes.v"
`define NUM_TILES 2


module MVU (
    input clk,
    input start,
    input reset,
    input done,
    input [`VRF_AWIDTH-1:0] vrf_wr_addr,        
    input [`VRF_AWIDTH-1:0] vrf_read_addr,      
    input [`VRF_DWIDTH-1:0] vec,               
     
    input vrf_wr_enable_tile_0,
    input vrf_readn_enable_tile_0, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_0,
    
    input vrf_wr_enable_tile_1,
    input vrf_readn_enable_tile_1, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_1,
    
    input [`MRF_DWIDTH-1:0] mrf_in,                 
    input[`NUM_TILES*`NUM_LDPES-1:0] mrf_we,               
    input [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr,
    
    output [`ORF_DWIDTH*`NUM_LDPES-1:0] mvm_result
);

    wire[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm_0;
    
    MVU_tile tile_0(.clk(clk),
    .start(start),
    .reset(reset),
    .done(done), //WITH TAG
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .vrf_data_out(vrf_data_out_tile_0), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_0), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_0), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .mrf_in(mrf_in),
    .mrf_we(mrf_we[1*`NUM_LDPES-1:0*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[1*`NUM_LDPES*`MRF_AWIDTH-1:0*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_0) //WITH TAG
    //.result_addr(result_addr_mvu_orf)
    );
   
   wire[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm_1;
   
    MVU_tile tile_1(.clk(clk),
    .start(start),
    .reset(reset),
    .done(done), //WITH TAG
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .vrf_data_out(vrf_data_out_tile_1), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_1), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_1), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .mrf_in(mrf_in),
    .mrf_we(mrf_we[2*`NUM_LDPES-1:1*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[2*`NUM_LDPES*`MRF_AWIDTH-1:1*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_1) //WITH TAG
   // .result_addr(result_addr_mvu_orf)
    );
   
    wire[`NUM_LDPES*`OUT_PRECISION-1:0] reduction_unit_output;
    mvm_reduction_unit mvm_reduction(
      .clk(clk),
      .reset_reduction_mvm(reset),
      .inp0(result_mvm_0),
      .inp1(result_mvm_1),
      .result_mvm_final_stage(reduction_unit_output)
    );
    
    assign mvm_result = reduction_unit_output;
    
endmodule


module MVU_tile (
    input clk,
    input start,
    input reset,
    input done,
    input vrf_wr_enable,
    input [`VRF_AWIDTH-1:0] vrf_wr_addr,
    input [`VRF_AWIDTH-1:0] vrf_read_addr,
    input [`VRF_DWIDTH-1:0] vec,
    output[`VRF_DWIDTH-1:0] vrf_data_out,
    input [`MRF_DWIDTH-1:0] mrf_in,
    input vrf_readn_enable,
    input[`NUM_LDPES-1:0] mrf_we,
    input [`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr,
    output [`ORF_DWIDTH*`NUM_LDPES-1:0] result
    //input [`ORF_AWIDTH-1:0] result_addr
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
                .start(start),
                .reset(reset),
                .done(done),
                .vec(vrf_outa_wire),
                .mrf_in(mrf_in),
                .mrf_we(mrf_we[i-1]),
                .mrf_addr(mrf_addr[i*`MRF_AWIDTH-1:(i-1)*`MRF_AWIDTH]),
                .result(result[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH])
                //.result_addr(result_addr)
            );
        end
    endgenerate
/*
    always @(posedge clk or posedge reset) begin
        if (reset==1'b1) begin
            vrf_rd_addr <= 1;
        end
        else begin
            if (start) begin
                vrf_rd_addr <= vrf_rd_addr + 1;
            end
        end
    end
*/
endmodule

module compute_unit (
    input clk,
    input start,
    input reset,
    input done,
    input [`VRF_DWIDTH-1:0] vec,
    input [`MRF_DWIDTH-1:0] mrf_in,
    input mrf_we,
    input [`MRF_AWIDTH-1:0] mrf_addr,
    output [`ORF_DWIDTH-1:0] result
   // output [`ORF_AWIDTH-1:0] result_addr
);

    // Port A of BRAMs is used for feed DSPs and Port B is used to load matrix from off-chip memory

  
    wire [`MRF_DWIDTH-1:0] mrf_outa_wire;

    wire [`LDPE_USED_INPUT_WIDTH-1:0] ax_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] ay_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] bx_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] by_wire;

    // Wire connecting LDPE output to Output BRAM input
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] ldpe_result;
    
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] inb_fake_wire;
    
    wire [`ORF_DWIDTH-1:0] orf_fake_wire;

    reg [`ORF_AWIDTH-1:0] out_wr_addr;


    // First 4 BRAM outputs are given to ax of 4 DSPs and next 4 BRAM outputs are given to bx of DSPs

    // Connection MRF and LDPE wires for matrix data
    // 'X' pin is used for matrix
    /* If there are 4 DSPSs, bit[31:0] of mrf output contain ax values for the 4 DSPs, bit[63:32] contain bx values and so on. With a group of ax values, bit[7:0] contain ax value for DSP1, bit[15:8] contain ax value for DSP2 and so on. */
    assign ax_wire = mrf_outa_wire[1*`LDPE_USED_INPUT_WIDTH-1:0*`LDPE_USED_INPUT_WIDTH];
    assign bx_wire = mrf_outa_wire[2*`LDPE_USED_INPUT_WIDTH-1:1*`LDPE_USED_INPUT_WIDTH];

    // Connection of VRF and LDPE wires for vector data
    // 'Y' pin is used for vector
    assign ay_wire = vec[`LDPE_USED_INPUT_WIDTH-1:0];
    assign by_wire = vec[2*`LDPE_USED_INPUT_WIDTH-1:1*`LDPE_USED_INPUT_WIDTH];

    MRF mrf (
        .clk(clk),
        .addr(mrf_addr),
        .in(mrf_in),
        .we(mrf_we),
        .out(mrf_outa_wire)
    );
    
    LDPE ldpe (
        .clk(clk),
        .reset(reset),
        .ax(ax_wire),
        .ay(ay_wire),
        .bx(bx_wire),
        .by(by_wire),
        .ldpe_result(ldpe_result)
    );
    assign result = ldpe_result;
    /*
    //TODO - EXPOSE PORT B to TOP of the TILE
    ORF orf (
        .clk(clk),
        .addra(out_wr_addr),
        .addrb(result_addr),
        .ina(ldpe_result),
        .inb(inb_fake_wire),
        .wea(1'b1),
        .web(1'b0),
        .outb(result),
        .outa(orf_fake_wire)
    );
    */
endmodule

module LDPE (
    input clk,
    input reset,
    input [`LDPE_USED_INPUT_WIDTH-1:0] ax,
    input [`LDPE_USED_INPUT_WIDTH-1:0] ay,
    input [`LDPE_USED_INPUT_WIDTH-1:0] bx,
    input [`LDPE_USED_INPUT_WIDTH-1:0] by,
    output [`LDPE_USED_OUTPUT_WIDTH-1:0] ldpe_result
);

    wire [`LDPE_USED_OUTPUT_WIDTH*`SUB_LDPES_PER_LDPE-1:0] sub_ldpe_result;
    //wire [`LDPE_USED_OUTPUT_WIDTH-1:0] ldpe_result;

    SUB_LDPE sub_1(
        .clk(clk),
        .reset(reset),
        .ax(ax[1*`SUB_LDPE_USED_INPUT_WIDTH-1:(1-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .ay(ay[1*`SUB_LDPE_USED_INPUT_WIDTH-1:(1-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .bx(bx[1*`SUB_LDPE_USED_INPUT_WIDTH-1:(1-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .by(by[1*`SUB_LDPE_USED_INPUT_WIDTH-1:(1-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .result(sub_ldpe_result[1*`DSP_USED_OUTPUT_WIDTH-1:(1-1)*`DSP_USED_OUTPUT_WIDTH])
    );
    assign ldpe_result = sub_ldpe_result[(0+1)*`DSP_USED_OUTPUT_WIDTH-1:0*`DSP_USED_OUTPUT_WIDTH];
    /*
    adder_tree reduction_unit(
        .clk(clk),
        .reset(reset),
        .inp0(sub_ldpe_result[(0+1)*`DSP_USED_OUTPUT_WIDTH-1:0*`DSP_USED_OUTPUT_WIDTH]),
        .outp(ldpe_result)
    );
   
    always @(posedge clk) begin
        if (reset==1'b1) begin
            $display("test");
            result <= 16'b0;
        end
        else begin
            // Result of the last DSP is added to the accumulator
            result <= result + ldpe_result;
        end
    end
*/
endmodule
/*
module adder_tree(
  input clk,
  input reset,
  input [`DSP_USED_OUTPUT_WIDTH-1:0] inp0,
  input [`DSP_USED_OUTPUT_WIDTH-1:0] inp1,
  input [`DSP_USED_OUTPUT_WIDTH-1:0] inp2,
  input [`DSP_USED_OUTPUT_WIDTH-1:0] inp3,
  output reg [`DSP_USED_OUTPUT_WIDTH-1:0] outp
);

  wire   [`DSP_USED_OUTPUT_WIDTH-1 : 0] compute0_out_stage0;
  //reg    [`DSP_USED_OUTPUT_WIDTH-1 : 0] outp;
  always @(*) begin
    if (reset) begin
      outp <= 0;
    end
    else begin
    
      outp <= compute0_out_stage0;
    end
  end
    
  myadder compute0_stage0(
    .a(outp),
    .b(inp0),
    .reset(reset),
    .clk(clk),
    .sum(compute0_out_stage0)
  );
endmodule
*/
module myadder(
    input [`DSP_USED_INPUT_WIDTH-1:0] a,
    input [`DSP_USED_INPUT_WIDTH-1:0] b,
    input reset,
    input clk,
    output reg [`DSP_USED_INPUT_WIDTH-1:0] sum
);

    always@(posedge clk) begin
        if(reset) begin
            sum <= 0;
        end
        else begin
            sum <= a+b;
        end
    end

endmodule

module SUB_LDPE (
    input clk,
    input reset,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] ax,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] ay,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] bx,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] by,
    output reg [`LDPE_USED_OUTPUT_WIDTH-1:0] result
);

    wire [`DSP_USED_OUTPUT_WIDTH*`DSPS_PER_SUB_LDPE-1:0] chainin, chainout, dsp_result;

    // Chainin of the first DSP is always zero
    //assign chainin[1*`DSP_AVA_OUTPUT_WIDTH-1:(1-1)*`DSP_AVA_OUTPUT_WIDTH] = {`DSP_AVA_OUTPUT_WIDTH{1'b0}};

    //assign chainin[2*`DSP_USED_OUTPUT_WIDTH-1:(2-1)*`DSP_USED_OUTPUT_WIDTH] = chainout[(2-1)*`DSP_USED_OUTPUT_WIDTH-1:(2-2)*`DSP_USED_OUTPUT_WIDTH];
    
    wire [36:0] chainout_temp_0;
    assign chainout_temp_0 = 37'b0;

    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_1;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_1;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_1;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_1;

    assign ax_wire_1 = {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax[1*`DSP_USED_INPUT_WIDTH-1:(1-1)*`DSP_USED_INPUT_WIDTH]};
    assign ay_wire_1 = {{`DSP_Y_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay[1*`DSP_USED_INPUT_WIDTH-1:(1-1)*`DSP_USED_INPUT_WIDTH]};

    assign bx_wire_1 = {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx[1*`DSP_USED_INPUT_WIDTH-1:(1-1)*`DSP_USED_INPUT_WIDTH]};
    assign by_wire_1 = {{`DSP_Y_ZERO_PAD_INPUT_WIDTH{1'b0}}, by[1*`DSP_USED_INPUT_WIDTH-1:(1-1)*`DSP_USED_INPUT_WIDTH]};

    //wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainin_temp_1;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_1;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_1;

    //assign chainin_temp_1 = {{`DSP_ZERO_PAD_OUTPUT_WIDTH{1'b0}}, chainin[1*`DSP_USED_OUTPUT_WIDTH-1:(1-1)*`DSP_USED_OUTPUT_WIDTH]};
    //assign chainout[1*`DSP_USED_OUTPUT_WIDTH-1:(1-1)*`DSP_USED_OUTPUT_WIDTH] = chainout_temp_1[`DSP_USED_OUTPUT_WIDTH-1:0];
    //assign chainin_temp_1 = chainin[1*`DSP_AVA_OUTPUT_WIDTH-1:(1-1)*`DSP_AVA_OUTPUT_WIDTH];
    //assign chainout[1*`DSP_AVA_OUTPUT_WIDTH-1:(1-1)*`DSP_AVA_OUTPUT_WIDTH] = chainout_temp_1;
    assign dsp_result[1*`DSP_USED_OUTPUT_WIDTH-1:(1-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_1[`DSP_USED_OUTPUT_WIDTH-1:0];

    dsp_block_18_18_int_sop_2 dsp_1 (
        .clk(clk),
        .aclr(reset),
        .ax(ax_wire_1),
        .ay(ay_wire_1),
        .bx(bx_wire_1),
        .by(by_wire_1),
        .chainin(chainout_temp_0),
        .chainout(chainout_temp_1),
        //.chainin(chainin[1*`DSP_AVA_OUTPUT_WIDTH-1:(1-1)*`DSP_AVA_OUTPUT_WIDTH]),
        //.chainout(chainout[1*`DSP_AVA_OUTPUT_WIDTH-1:(1-1)*`DSP_AVA_OUTPUT_WIDTH]),
        .result(result_temp_1)
    );
    
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_2;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_2;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_2;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_2;

    assign ax_wire_2 = {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax[2*`DSP_USED_INPUT_WIDTH-1:(2-1)*`DSP_USED_INPUT_WIDTH]};
    assign ay_wire_2 = {{`DSP_Y_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay[2*`DSP_USED_INPUT_WIDTH-1:(2-1)*`DSP_USED_INPUT_WIDTH]};

    assign bx_wire_2 = {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx[2*`DSP_USED_INPUT_WIDTH-1:(2-1)*`DSP_USED_INPUT_WIDTH]};
    assign by_wire_2 = {{`DSP_Y_ZERO_PAD_INPUT_WIDTH{1'b0}}, by[2*`DSP_USED_INPUT_WIDTH-1:(2-1)*`DSP_USED_INPUT_WIDTH]};

    //wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainin_temp_2;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_2;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_2;

    //assign chainin_temp_2 = {{`DSP_ZERO_PAD_OUTPUT_WIDTH{1'b0}}, chainin[2*`DSP_USED_OUTPUT_WIDTH-1:(2-1)*`DSP_USED_OUTPUT_WIDTH]};
    //assign chainout[2*`DSP_USED_OUTPUT_WIDTH-1:(2-1)*`DSP_USED_OUTPUT_WIDTH] = chainout_temp_2[`DSP_USED_OUTPUT_WIDTH-1:0];
    //assign chainin_temp_2 = chainin[2*`DSP_AVA_OUTPUT_WIDTH-1:(2-1)*`DSP_AVA_OUTPUT_WIDTH];
    //assign chainout[2*`DSP_AVA_OUTPUT_WIDTH-1:(2-1)*`DSP_AVA_OUTPUT_WIDTH] = chainout_temp_2;
    assign dsp_result[2*`DSP_USED_OUTPUT_WIDTH-1:(2-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_2[`DSP_USED_OUTPUT_WIDTH-1:0];

    dsp_block_18_18_int_sop_2 dsp_2 (
        .clk(clk),
        .aclr(reset),
        .ax(ax_wire_2),
        .ay(ay_wire_2),
        .bx(bx_wire_2),
        .by(by_wire_2),
        .chainin(chainout_temp_1),
        .chainout(chainout_temp_2),
        //.chainin(chainin[2*`DSP_AVA_OUTPUT_WIDTH-1:(2-1)*`DSP_AVA_OUTPUT_WIDTH]),
        //.chainout(chainout[2*`DSP_AVA_OUTPUT_WIDTH-1:(2-1)*`DSP_AVA_OUTPUT_WIDTH]),
        .result(result_temp_2)
    );
    
    always @(*) begin
        if (reset) begin
            result <= {`LDPE_USED_OUTPUT_WIDTH{1'd0}};
        end
        else begin
            // Result of the last DSP is added to the accumulator
            result <= dsp_result[`DSPS_PER_SUB_LDPE*`LDPE_USED_OUTPUT_WIDTH-1:(`DSPS_PER_SUB_LDPE-1)*`LDPE_USED_OUTPUT_WIDTH];
            //result <= dsp_result[8-1:0];
        end
    end

endmodule

module ORF (
    input clk,
    input [`ORF_AWIDTH-1:0] addra, addrb,
    input [`ORF_DWIDTH-1:0] ina, inb,
    input wea, web,
    output [`ORF_DWIDTH-1:0] outa, outb
);

    dp_ram # (
        .AWIDTH(`ORF_AWIDTH),
        .DWIDTH(`ORF_DWIDTH)
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

module VRF (
    input clk,
    input [`VRF_AWIDTH-1:0] addra, addrb,
    input [`VRF_DWIDTH-1:0] ina, inb,
    input wea, web,
    output [`VRF_DWIDTH-1:0] outa, outb
);

    dp_ram # (
        .AWIDTH(`VRF_AWIDTH),
        .DWIDTH(`VRF_DWIDTH)
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
    input [`MRF_AWIDTH-1:0] addr,
    input [`MRF_DWIDTH-1:0] in,
    input we,
    output [`MRF_DWIDTH-1:0] out
);

    sp_ram # (
        .AWIDTH(`MRF_AWIDTH),
        .DWIDTH(`MRF_DWIDTH)
    ) mat_mem (
        .clk(clk),
        .addr(addr),
        .in(in),
        .we(we),
        .out(out)
    );
endmodule

module dsp_block_18_18_int_sop_2 (
    input clk,
    input aclr,
    input [`DSP_X_AVA_INPUT_WIDTH-1:0] ax,
    input [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay,
    input [`DSP_X_AVA_INPUT_WIDTH-1:0] bx,
    input [`DSP_Y_AVA_INPUT_WIDTH-1:0] by,
    input [`DSP_AVA_OUTPUT_WIDTH-1:0] chainin,
    output [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout,
    output [`DSP_AVA_OUTPUT_WIDTH-1:0] result
);

`ifdef SIMULATION

reg [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_reg;
reg [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_reg;
reg [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_reg;
reg [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_reg;
reg [`DSP_AVA_OUTPUT_WIDTH-1:0] result_reg;

always @(posedge clk) begin
    if(aclr) begin
        result_reg <= 0;
        ax_reg <= 0;
        ay_reg <= 0;
        bx_reg <= 0;
        by_reg <= 0;
    end
    else begin
        ax_reg <= ax;
        ay_reg <= ay;
        bx_reg <= bx;
        by_reg <= by;
        result_reg <= (ax_reg * ay_reg) + (bx_reg * by_reg) + chainin;
    end
end
assign chainout = result_reg;
assign result = result_reg;

`else

wire [11:0] mode;
assign mode = 12'b0101_0101_0011;

int_sop_2 mac_component (
    .mode_sigs(mode),
    .clk(clk),
    .reset(aclr),
    .ax(ax),
    .ay(ay),
    .bx(bx),
    .by(by),
    .chainin(chainin),
    .result(result),
    .chainout(chainout)
);

`endif

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

`ifdef SIMULATION

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

`ifdef SIMULATION

reg [DWIDTH-1:0] ram [((1<<AWIDTH)-1):0];

always @(posedge clk)  begin

    if (we) begin
        ram[addr] <= in;
    end

    out <= ram[addr];
end

`else

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
    input[`ORF_DWIDTH*`NUM_LDPES-1:0] inp0,
    input[`ORF_DWIDTH*`NUM_LDPES-1:0] inp1,
    output reg[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm_final_stage,
    
    //CONTROL SIGNALS
    input clk,
    //input done,
    //input continue_past_reduction,
   input reset_reduction_mvm
);
    wire[`ORF_DWIDTH*`NUM_LDPES-1:0] reduction_output_wire;
    reg[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm;
    
    always @(*) begin
        if (reset_reduction_mvm) begin
          result_mvm_final_stage <= 0;
        end
        else begin
        
           result_mvm_final_stage <= reduction_output_wire;
        end
     end
     /*
     always @(posedge clk) begin
        if (add_with_prev_mvm_result) begin
          result_mvm <= 0;
        end
        else begin
        
           result_mvm <= reduction_output_wire;
        end
     end
     */
    genvar i;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder adder_units(
              .a(inp0[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH]),
              .b(inp1[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH]),
              .clk(clk),
              .reset(reset_reduction_unit),
              .sum(reduction_output_wire[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH])
            );
        end
        
    endgenerate
    /*
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder adder_units(
              .a(inp0[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH]),
              .b(inp1[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH]),
              .sum(reduction_output_wire[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH])
            );
        end
        
    endgenerate
*/
endmodule
