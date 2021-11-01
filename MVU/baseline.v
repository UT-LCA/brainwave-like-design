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

module baseline (
    input clk,
    input start,
    input rst,
    input done,
    input vec_we,
    input [`VRF_AWIDTH-1:0] vrf_wr_addr,
    input [`VRF_DWIDTH-1:0] vec,
    output [`ORF_DWIDTH*`NUM_LDPES-1:0] result
);

    wire [`VRF_DWIDTH-1:0] ina_fake;
    wire [`VRF_DWIDTH-1:0] outb_fake;

    wire [`VRF_DWIDTH-1:0] vrf_outa_wire;

    reg [`VRF_AWIDTH-1:0] vrf_rd_addr;

    // Port A is used to feed LDPE and port B to load vector from DRAM.
    VRF vrf (
        .clk(clk),
        .addra(vrf_rd_addr),
        .ina(ina_fake),
        .wea(1'b0),
        .outa(vrf_outa_wire),
        .addrb(vrf_wr_addr),
        .inb(vec),
        .web(vec_we),
        .outb(outb_fake) 
    );

    genvar i;
    generate
        for (i=1; i<=`NUM_LDPES; i=i+1) begin
            compute_unit unit (
                .clk(clk),
                .start(start),
                .rst(rst),
                .done(done),
                .vec(vrf_outa_wire),
                .result(result[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH])
            );
        end
    endgenerate

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            vrf_rd_addr <= 0;
        end
        else begin
            if (start) begin
                vrf_rd_addr <= vrf_rd_addr + 1;
            end
        end
    end

endmodule


module compute_unit (
    input clk,
    input start,
    input rst,
    input done,
    input [`VRF_DWIDTH-1:0] vec,
    output [`ORF_DWIDTH-1:0] result
);

    // Port A of BRAMs is used for feed DSPs and Port B is used to load matrix from off-chip memory

    wire [`MRF_DWIDTH-1:0] ina_fake;
    wire [`MRF_DWIDTH-1:0] mrf_outa_wire;

    wire [`LDPE_USED_INPUT_WIDTH-1:0] ax_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] ay_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] bx_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] by_wire;

    // Wire connecting LDPE output to Output BRAM input
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] ldpe_result;

    reg [`ORF_AWIDTH-1:0] out_wr_addr;

    reg [`MRF_AWIDTH-1:0] mrf_rd_addr;

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

    always@(posedge clk or posedge rst) begin
        if (rst) begin
            out_wr_addr <= 0;
            mrf_rd_addr <= 0;
        end
        else begin
            if (start) begin
                mrf_rd_addr <= mrf_rd_addr + 1;
                if (done) begin
                    out_wr_addr <= out_wr_addr + 1;
                end
            end
        end
    end

    MRF mrf (
        .clk(clk),
        .addr(mrf_rd_addr),
        .in(ina_fake),
        .we(1'b0),
        .out(mrf_outa_wire)
    );

    LDPE ldpe (
        .clk(clk),
        .rst(rst),
        .ax(ax_wire),
        .ay(ay_wire),
        .bx(bx_wire),
        .by(by_wire),
        .result(ldpe_result)
    );

    ORF orf (
        .clk(clk),
        .addr(out_wr_addr),
        .in(ldpe_result),
        .we(done),
        .out(result)
    );
endmodule

module LDPE (
    input clk,
    input rst,
    input [`LDPE_USED_INPUT_WIDTH-1:0] ax,
    input [`LDPE_USED_INPUT_WIDTH-1:0] ay,
    input [`LDPE_USED_INPUT_WIDTH-1:0] bx,
    input [`LDPE_USED_INPUT_WIDTH-1:0] by,
    output reg [`LDPE_USED_OUTPUT_WIDTH-1:0] result
);

    wire [`LDPE_USED_OUTPUT_WIDTH*`SUB_LDPES_PER_LDPE-1:0] sub_ldpe_result;

    genvar i;
    generate
        for (i=1; i<=`SUB_LDPES_PER_LDPE; i=i+1) begin
            SUB_LDPE sub(
                .clk(clk),
                .rst(rst),
                .ax(ax_wire[i*`SUB_LDPE_USED_INPUT_WIDTH-1:(i-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
                .ay(ay_wire[i*`SUB_LDPE_USED_INPUT_WIDTH-1:(i-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
                .bx(bx_wire[i*`SUB_LDPE_USED_INPUT_WIDTH-1:(i-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
                .by(by_wire[i*`SUB_LDPE_USED_INPUT_WIDTH-1:(i-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
                .result(sub_ldpe_result[i*`SUB_LDPE_USED_INPUT_WIDTH-1:(i-1)*`SUB_LDPE_USED_INPUT_WIDTH])
            );
        end
    endgenerate


    // Adder tree logic for adding the outputs of a LDPE is generated by python script. Hence it is added in the VTR compatible version of this file called baseline_vtr.v

endmodule

module SUB_LDPE (
    input clk,
    input rst,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] ax,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] ay,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] bx,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] by,
    output reg [`LDPE_USED_OUTPUT_WIDTH-1:0] result
);

    wire [`DSP_USED_OUTPUT_WIDTH*`DSPS_PER_SUB_LDPE-1:0] chainin, chainout, dsp_result;

    // Chainin of the first DSP is always zero
    assign chainin[1*`DSP_USED_OUTPUT_WIDTH-1:(1-1)*`DSP_USED_OUTPUT_WIDTH] = {`DSP_USED_OUTPUT_WIDTH{1'b0}};

    genvar i;

    generate
        for (i=2; i<=`DSPS_PER_SUB_LDPE; i=i+1) begin
            assign chainin[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH] = chainout[(i-1)*`DSP_USED_OUTPUT_WIDTH-1:(i-2)*`DSP_USED_OUTPUT_WIDTH];
        end
    endgenerate

    generate
        for (i=1; i<=`DSPS_PER_SUB_LDPE; i=i+1) begin

            wire [`DSP_AVA_INPUT_WIDTH-1:0] ax_wire;
            wire [`DSP_AVA_INPUT_WIDTH-1:0] ay_wire;
            wire [`DSP_AVA_INPUT_WIDTH-1:0] bx_wire;
            wire [`DSP_AVA_INPUT_WIDTH-1:0] by_wire;

            assign ax_wire = {{`DSP_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax[i*`DSP_USED_INPUT_WIDTH-1:(i-1)*`DSP_USED_INPUT_WIDTH]};
            assign ay_wire = {{`DSP_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay[i*`DSP_USED_INPUT_WIDTH-1:(i-1)*`DSP_USED_INPUT_WIDTH]};

            assign bx_wire = {{`DSP_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx[i*`DSP_USED_INPUT_WIDTH-1:(i-1)*`DSP_USED_INPUT_WIDTH]};
            assign by_wire = {{`DSP_ZERO_PAD_INPUT_WIDTH{1'b0}}, by[i*`DSP_USED_INPUT_WIDTH-1:(i-1)*`DSP_USED_INPUT_WIDTH]};

            wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainin_temp;
            wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp;
            wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp;

            assign chainin_temp = {{`DSP_ZERO_PAD_OUTPUT_WIDTH{1'b0}}, chainin[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]};
            assign chainout[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH] = chainout_temp[`DSP_USED_OUTPUT_WIDTH-1:0];
            assign dsp_result[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp[`DSP_USED_OUTPUT_WIDTH-1:0];

            dsp_block_18_18_int_sop_2 dsp (
                .clk(clk),
                .aclr(rst),
                .ax(ax_wire),
                .ay(ay_wire),
                .bx(bx_wire),
                .by(by_wire),
                .chainin(chainin_temp),
                .chainout(chainout_temp),
                .result(result_temp)
            );
        end
    endgenerate

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= {`LDPE_USED_OUTPUT_WIDTH{1'd0}};
        end
        else begin
            // Chainout of the last DSP is added to the accumulator
            //result <= result + chainout[`DSPS_PER_SUB_LDPE*`LDPE_USED_OUTPUT_WIDTH-1:(`DSPS_PER_SUB_LDPE-1)*`LDPE_USED_OUTPUT_WIDTH];
            result <= dsp_result[`DSPS_PER_SUB_LDPE*`LDPE_USED_OUTPUT_WIDTH-1:(`DSPS_PER_SUB_LDPE-1)*`LDPE_USED_OUTPUT_WIDTH];
        end
    end

endmodule

module dsp_block_18_18_int_sop_2 (
    input clk,
    input aclr,
    input [`DSP_AVA_INPUT_WIDTH-1:0] ax,
    input [`DSP_AVA_INPUT_WIDTH-1:0] ay,
    input [`DSP_AVA_INPUT_WIDTH-1:0] bx,
    input [`DSP_AVA_INPUT_WIDTH-1:0] by,
    input [`DSP_AVA_OUTPUT_WIDTH-1:0] chainin,
    output [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout,
    output [`DSP_AVA_OUTPUT_WIDTH-1:0] result
);

`ifdef SIMULATION

reg [`DSP_AVA_INPUT_WIDTH-1:0] ax_reg;
reg [`DSP_AVA_INPUT_WIDTH-1:0] ay_reg;
reg [`DSP_AVA_INPUT_WIDTH-1:0] bx_reg;
reg [`DSP_AVA_INPUT_WIDTH-1:0] by_reg;
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


module ORF (
    input clk,
    input [`ORF_AWIDTH-1:0] addr,
    input [`ORF_DWIDTH-1:0] in,
    input we,
    output [`ORF_DWIDTH-1:0] out
);

    sp_ram # (
        .AWIDTH(`ORF_AWIDTH),
        .DWIDTH(`ORF_DWIDTH)
    ) mat_mem (
        .clk(clk),
        .addr(addr),
        .in(in),
        .we(we),
        .out(out)
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

initial begin
    $readmemh("mat.txt", ram, 0);
end

always @(posedge clk)  begin

    if (we) begin
        ram[addr] <= in;
    end

    out <= ram[addr];
end

`else

single_port_ram u_dual_port_ram(
.addr(addr),
.we(we),
.data(in),
.out(out),
.clk(clk)
);

`endif
endmodule