////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM mvu.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


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
    input vrf_wr_enable_tile_2,
    input vrf_readn_enable_tile_2, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_2,
    input vrf_wr_enable_tile_3,
    input vrf_readn_enable_tile_3, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_3,
    
    input [`MRF_DWIDTH-1:0] mrf_in,                 
    input[`NUM_TILES*`NUM_LDPES-1:0] mrf_we,               
    input [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr,
    
    output [`ORF_DWIDTH-1:0] mvm_result
);
    wire[`ORF_DWIDTH-1:0] result_mvm_0;

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
    );
    wire[`ORF_DWIDTH-1:0] result_mvm_1;

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
    );
    wire[`ORF_DWIDTH-1:0] result_mvm_2;

    MVU_tile tile_2(.clk(clk),
    .start(start),
    .reset(reset),
    .done(done), //WITH TAG
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .vrf_data_out(vrf_data_out_tile_2), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_2), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_2), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .mrf_in(mrf_in),
    .mrf_we(mrf_we[3*`NUM_LDPES-1:2*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[3*`NUM_LDPES*`MRF_AWIDTH-1:2*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_2) //WITH TAG
    );
    wire[`ORF_DWIDTH-1:0] result_mvm_3;

    MVU_tile tile_3(.clk(clk),
    .start(start),
    .reset(reset),
    .done(done), //WITH TAG
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .vrf_data_out(vrf_data_out_tile_3), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_3), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_3), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .mrf_in(mrf_in),
    .mrf_we(mrf_we[4*`NUM_LDPES-1:3*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[4*`NUM_LDPES*`MRF_AWIDTH-1:3*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_3) //WITH TAG
    );
   
    wire[`NUM_LDPES*`OUT_PRECISION-1:0] reduction_unit_output;
    mvm_reduction_unit mvm_reduction(
      .clk(clk),
      .reset_reduction_mvm(reset),
      .inp0(result_mvm_0),
      .inp1(result_mvm_1),
      .inp2(result_mvm_2),
      .inp3(result_mvm_3),
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
    output [`ORF_DWIDTH-1:0] result
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
                .result(result[i*`OUT_DWIDTH-1:(i-1)*`OUT_DWIDTH])
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
    output [`OUT_DWIDTH-1:0] result
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
    
    wire [`OUT_DWIDTH-1:0] orf_fake_wire;

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

endmodule

module myadder #(
    parameter INPUT_WIDTH = `DSP_USED_INPUT_WIDTH,
    parameter OUTPUT_WIDTH = `DSP_USED_INPUT_WIDTH+1
)
(
    input [INPUT_WIDTH-1:0] a,
    input [INPUT_WIDTH-1:0] b,
    input reset,
    input clk,
    output reg [OUTPUT_WIDTH-1:0] sum
);

    always@(posedge clk) begin
        if(reset) begin
            sum <= 0;
        end
        else begin
            sum <= {a[INPUT_WIDTH-1],a}+{b[INPUT_WIDTH-1],b};
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

    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_1;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_1;

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

    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_2;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_2;

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
        .result(result_temp_2)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_3;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_3;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_3;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_3;

    assign ax_wire_3 = {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax[3*`DSP_USED_INPUT_WIDTH-1:(3-1)*`DSP_USED_INPUT_WIDTH]};
    assign ay_wire_3 = {{`DSP_Y_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay[3*`DSP_USED_INPUT_WIDTH-1:(3-1)*`DSP_USED_INPUT_WIDTH]};

    assign bx_wire_3 = {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx[3*`DSP_USED_INPUT_WIDTH-1:(3-1)*`DSP_USED_INPUT_WIDTH]};
    assign by_wire_3 = {{`DSP_Y_ZERO_PAD_INPUT_WIDTH{1'b0}}, by[3*`DSP_USED_INPUT_WIDTH-1:(3-1)*`DSP_USED_INPUT_WIDTH]};

    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_3;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_3;

    assign dsp_result[3*`DSP_USED_OUTPUT_WIDTH-1:(3-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_3[`DSP_USED_OUTPUT_WIDTH-1:0];

    dsp_block_18_18_int_sop_2 dsp_3 (
        .clk(clk),
        .aclr(reset),
        .ax(ax_wire_3),
        .ay(ay_wire_3),
        .bx(bx_wire_3),
        .by(by_wire_3),
        .chainin(chainout_temp_2),
        .chainout(chainout_temp_3),
        .result(result_temp_3)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_4;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_4;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_4;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_4;

    assign ax_wire_4 = {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax[4*`DSP_USED_INPUT_WIDTH-1:(4-1)*`DSP_USED_INPUT_WIDTH]};
    assign ay_wire_4 = {{`DSP_Y_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay[4*`DSP_USED_INPUT_WIDTH-1:(4-1)*`DSP_USED_INPUT_WIDTH]};

    assign bx_wire_4 = {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx[4*`DSP_USED_INPUT_WIDTH-1:(4-1)*`DSP_USED_INPUT_WIDTH]};
    assign by_wire_4 = {{`DSP_Y_ZERO_PAD_INPUT_WIDTH{1'b0}}, by[4*`DSP_USED_INPUT_WIDTH-1:(4-1)*`DSP_USED_INPUT_WIDTH]};

    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_4;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_4;

    assign dsp_result[4*`DSP_USED_OUTPUT_WIDTH-1:(4-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_4[`DSP_USED_OUTPUT_WIDTH-1:0];

    dsp_block_18_18_int_sop_2 dsp_4 (
        .clk(clk),
        .aclr(reset),
        .ax(ax_wire_4),
        .ay(ay_wire_4),
        .bx(bx_wire_4),
        .by(by_wire_4),
        .chainin(chainout_temp_3),
        .chainout(chainout_temp_4),
        .result(result_temp_4)
    );
    
    always @(*) begin
        if (reset) begin
            result <= {`LDPE_USED_OUTPUT_WIDTH{1'd0}};
        end
        else begin
            result <= dsp_result[`DSPS_PER_SUB_LDPE*`LDPE_USED_OUTPUT_WIDTH-1:(`DSPS_PER_SUB_LDPE-1)*`LDPE_USED_OUTPUT_WIDTH];
        end
    end

endmodule

module VRF #(parameter VRF_AWIDTH = `VRF_AWIDTH, parameter VRF_DWIDTH = `VRF_DWIDTH) (
    input clk,
    input [VRF_AWIDTH-1:0] addra, addrb,
    input [VRF_DWIDTH-1:0] ina, inb,
    input wea, web,
    output [VRF_DWIDTH-1:0] outa, outb
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

`ifdef SIMULATION

reg [DWIDTH-1:0] ram [((1<<AWIDTH)-1):0];

always @(posedge clk)  begin

    if (we) begin
        ram[addr] <= in;
    end

    out <= ram[addr];
end

`else


defparam u_dual_port_ram.ADDR_WIDTH = AWIDTH;
defparam u_dual_port_ram.DATA_WIDTH = DWIDTH;

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
    input[`ORF_DWIDTH-1:0] inp0,
    input[`ORF_DWIDTH-1:0] inp1,
    input[`ORF_DWIDTH-1:0] inp2,
    input[`ORF_DWIDTH-1:0] inp3,
    output reg[`ORF_DWIDTH-1:0] result_mvm_final_stage,
    
    //CONTROL SIGNALS
    input clk,
    input reset_reduction_mvm
);
    wire[`ORF_DWIDTH-1:0] reduction_output_final;
 
    always @(*) begin
        if (reset_reduction_mvm) begin
          result_mvm_final_stage <= 0;
        end
        else begin
        
           result_mvm_final_stage <= reduction_output_final;
        end
     end

    genvar i;

    wire[(`OUT_DWIDTH+1)*`NUM_LDPES-1:0] reduction_output_0_stage_1;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`OUT_DWIDTH),.OUTPUT_WIDTH(`OUT_DWIDTH+1)) adder_units_initial_0 (
              .a(inp0[i*`OUT_DWIDTH-1:(i-1)*`OUT_DWIDTH]),
              .b(inp1[i*`OUT_DWIDTH-1:(i-1)*`OUT_DWIDTH]),
              .clk(clk),
              .reset(reset_reduction_mvm),
              .sum(reduction_output_0_stage_1[i*(`OUT_DWIDTH+1)-1:(i-1)*(`OUT_DWIDTH+1)])
            );
        end
    endgenerate
    wire[(`OUT_DWIDTH+1)*`NUM_LDPES-1:0] reduction_output_1_stage_1;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`OUT_DWIDTH),.OUTPUT_WIDTH(`OUT_DWIDTH+1)) adder_units_initial_1 (
              .a(inp2[i*`OUT_DWIDTH-1:(i-1)*`OUT_DWIDTH]),
              .b(inp3[i*`OUT_DWIDTH-1:(i-1)*`OUT_DWIDTH]),
              .clk(clk),
              .reset(reset_reduction_mvm),
              .sum(reduction_output_1_stage_1[i*(`OUT_DWIDTH+1)-1:(i-1)*(`OUT_DWIDTH+1)])
            );
        end
    endgenerate

    wire[(`OUT_DWIDTH+1+1)*`NUM_LDPES-1:0] reduction_output_0_stage_2;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`OUT_DWIDTH+1),.OUTPUT_WIDTH(`OUT_DWIDTH+1+1)) adder_units_0_stage_1 (
              .a(reduction_output_0_stage_1[i*(`OUT_DWIDTH+1)-1:(i-1)*(`OUT_DWIDTH+1)]),
              .b(reduction_output_1_stage_1[i*(`OUT_DWIDTH+1)-1:(i-1)*(`OUT_DWIDTH+1)]),
              .clk(clk),
              .reset(reset_reduction_mvm),
              .sum(reduction_output_0_stage_2[i*(`OUT_DWIDTH+1+1)-1:(i-1)*(`OUT_DWIDTH+1+1)])
            );
        end
    endgenerate

assign reduction_output_final[1*`OUT_DWIDTH-1:0*`OUT_DWIDTH] = reduction_output_0_stage_2[1*(`OUT_DWIDTH+2)-1:0*(`OUT_DWIDTH+2)];
assign reduction_output_final[2*`OUT_DWIDTH-1:1*`OUT_DWIDTH] = reduction_output_0_stage_2[2*(`OUT_DWIDTH+2)-1:1*(`OUT_DWIDTH+2)];
assign reduction_output_final[3*`OUT_DWIDTH-1:2*`OUT_DWIDTH] = reduction_output_0_stage_2[3*(`OUT_DWIDTH+2)-1:2*(`OUT_DWIDTH+2)];
assign reduction_output_final[4*`OUT_DWIDTH-1:3*`OUT_DWIDTH] = reduction_output_0_stage_2[4*(`OUT_DWIDTH+2)-1:3*(`OUT_DWIDTH+2)];
endmodule
