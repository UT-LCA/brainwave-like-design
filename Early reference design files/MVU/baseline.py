from argparse import ArgumentParser
import math

from gen_compute_unit_for_reduction import generate_compute_unit
from gen_compute_unit_for_reduction import generate_instance

NUM_MAT_COLS = 8
LOG_NUM_MAT_COLS = 3
NUM_MAT_ROWS_PER_LDPE = 2
LOG_NUM_MAT_ROWS_PER_LDPE = 1

IN_PRECISION = 8
OUT_PRECISION = 8

NUM_LDPES = 2
DSPS_PER_LDPE = 2
DSPS_PER_SUB_LDPE = 2
SUB_LDPES_PER_LDPE = int(DSPS_PER_LDPE/DSPS_PER_SUB_LDPE)

MULTS_PER_DSP = 2
INPUTS_PER_DSP = 2 * MULTS_PER_DSP
MULTS_PER_LDPE = MULTS_PER_DSP * DSPS_PER_LDPE
INPUTS_PER_LDPE = INPUTS_PER_DSP * DSPS_PER_LDPE

DSP_X_AVA_INPUT_WIDTH = 18
LDPE_X_AVA_INPUT_WIDTH = (DSP_X_AVA_INPUT_WIDTH * DSPS_PER_LDPE)
DSP_Y_AVA_INPUT_WIDTH = 19
LDPE_Y_AVA_INPUT_WIDTH = (DSP_Y_AVA_INPUT_WIDTH * DSPS_PER_LDPE)

DSP_AVA_OUTPUT_WIDTH = 37
LDPE_AVA_OUTPUT_WIDTH = DSP_AVA_OUTPUT_WIDTH

DSP_USED_INPUT_WIDTH = IN_PRECISION
LDPE_USED_INPUT_WIDTH = (DSP_USED_INPUT_WIDTH * DSPS_PER_LDPE)
SUB_LDPE_USED_INPUT_WIDTH = (DSP_USED_INPUT_WIDTH * DSPS_PER_SUB_LDPE)
DSP_X_ZERO_PAD_INPUT_WIDTH = (DSP_X_AVA_INPUT_WIDTH - DSP_USED_INPUT_WIDTH)
DSP_Y_ZERO_PAD_INPUT_WIDTH = (DSP_Y_AVA_INPUT_WIDTH - DSP_USED_INPUT_WIDTH)

DSP_USED_OUTPUT_WIDTH = 32
LDPE_USED_OUTPUT_WIDTH = DSP_USED_OUTPUT_WIDTH
DSP_ZERO_PAD_OUTPUT_WIDTH = (DSP_AVA_OUTPUT_WIDTH - DSP_USED_OUTPUT_WIDTH)

# MAT_INPUTS_PER_DSP = MULTS_PER_DSP
# MAT_BRAMS_PER_DSP = int((DSP_USED_INPUT_WIDTH*MAT_INPUTS_PER_DSP)/MAT_BRAM_DWIDTH)
LDPES_PER_MRF = 1
TOTAL_MRFS = int(1/LDPES_PER_MRF) * NUM_LDPES
DSPS_PER_MRF = (DSPS_PER_LDPE * LDPES_PER_MRF)
MAT_BRAM_AWIDTH = 9
MAT_BRAM_DWIDTH = 32
NUM_MAT_VALS_PER_BRAM = int(MAT_BRAM_DWIDTH/IN_PRECISION)
MAT_BRAMS_PER_MRF_SUBSET = int(DSPS_PER_LDPE/2)
SUBSETS_PER_MRF = 1
BRAMS_PER_MRF = MAT_BRAMS_PER_MRF_SUBSET * SUBSETS_PER_MRF
TOTAL_MAT_BRAMS = BRAMS_PER_MRF * TOTAL_MRFS
MRF_AWIDTH = MAT_BRAM_AWIDTH + math.log2(SUBSETS_PER_MRF)
MRF_DWIDTH = MAT_BRAM_DWIDTH * MAT_BRAMS_PER_MRF_SUBSET

# VEC_INPUTS_PER_DSP = MULTS_PER_DSP
# VEC_BRAMS_PER_DSP = int((DSP_USED_INPUT_WIDTH*VEC_INPUTS_PER_DSP)/VEC_BRAM_DWIDTH)
LDPES_PER_VRF = 1
TOTAL_VRFS = int(1/LDPES_PER_MRF)
DSPS_PER_VRF = (DSPS_PER_LDPE * LDPES_PER_VRF)
BRAMS_PER_VRF = DSPS_PER_LDPE
VEC_BRAM_AWIDTH = 10
VEC_BRAM_DWIDTH = 16
NUM_VEC_VALS_PER_BRAM = int(VEC_BRAM_DWIDTH/IN_PRECISION)
TOTAL_VEC_BRAMS = (BRAMS_PER_VRF * TOTAL_VRFS)
VRF_AWIDTH = VEC_BRAM_AWIDTH
VRF_DWIDTH = (VEC_BRAM_DWIDTH * BRAMS_PER_VRF)

LDPES_PER_ORF = 1
OUTPUTS_PER_LDPE = 1
OUT_BRAM_AWIDTH = 9
OUT_BRAM_DWIDTH = 32
BRAMS_PER_ORF = int(OUT_PRECISION/OUT_BRAM_DWIDTH)
ORF_AWIDTH = OUT_BRAM_AWIDTH
ORF_DWIDTH = (OUT_BRAM_DWIDTH * BRAMS_PER_ORF)

parser = ArgumentParser()
parser.add_argument("--vtr", type=str, help="path to vtr compatible file")

args = parser.parse_args()

############
# Comments #
############

comment = '''
/*******************************************************************************
Baseline architecture for Matrix Vector Multiplication.

precision: 8 bits
FPGA: AGILEX TODO: mention the model
DSP configuration: 4 9*9 multipliers
matrix BRAM configuration: 1024*16 true dual port
vector BRAM configuration: 1024*16 true dual port
output BRAM configuration: 512*32 single port

Each DSP has total {INPUTS_PER_DSP} inputs: {MULTS_PER_DSP} matrix values and {MULTS_PER_DSP} vector values. Each BRAM can provide {NUM_MAT_VALS_PER_BRAM} values.

number of DSPs per LDPE = {DSPS_PER_LDPE}
number of LDPEs = {NUM_LDPES}

For matrix:
number of MRFs per LDPE = 1 (always)
number of BRAMs per MRF per LDPE = number of BRAMs per DSP * number of DSPs per MRF = {BRAMS_PER_MRF}
total matrix BRAMs = total MRFs * number of BRAMs per MRF per LDPE = {TOTAL_MAT_BRAMS}

Each DSP requires {MULTS_PER_DSP} vector values per cycle. Therefore, each LDPE requires {MULTS_PER_LDPE} vector values per cycle. Since, each row of matrix is assigned to a LDPE, the same {MULTS_PER_LDPE} vector values are broadcasted to all LDPEs. Hence the VRF should be able to provide {MULTS_PER_LDPE} values in 1 cycle. Each BRAM can provide {NUM_VEC_VALS_PER_BRAM} vector values. Hence, VRF requires {BRAMS_PER_VRF} BRAMs. 

For vector:
total VRFs = 1 (always)
number of BRAMs per VRF = {BRAMS_PER_VRF}
total vector BRAMs = total VRFs * number of BRAMs per VRFs = {BRAMS_PER_VRF}

We assume {OUT_PRECISION}-bit accumulation. Each LDPE uses 1 BRAM to store the output.

for output:
number of BRAMs per LDPE = {BRAMS_PER_ORF}
total output BRAMs = number of LDPEs = {NUM_LDPES}


*******************************************************************************/
'''.format(INPUTS_PER_DSP=INPUTS_PER_DSP, 
MULTS_PER_DSP=MULTS_PER_DSP, 
NUM_MAT_VALS_PER_BRAM=NUM_MAT_VALS_PER_BRAM, 
DSPS_PER_LDPE=DSPS_PER_LDPE, 
NUM_LDPES=NUM_LDPES, 
BRAMS_PER_MRF=BRAMS_PER_MRF, 
TOTAL_MAT_BRAMS=TOTAL_MAT_BRAMS, 
MULTS_PER_LDPE=MULTS_PER_LDPE, 
NUM_VEC_VALS_PER_BRAM=NUM_VEC_VALS_PER_BRAM,
BRAMS_PER_VRF=BRAMS_PER_VRF,
OUT_PRECISION=OUT_PRECISION,
BRAMS_PER_ORF=BRAMS_PER_ORF)


###########
# Defines #
###########

defines = '''

`define NUM_MAT_COLS {NUM_MAT_COLS} 
`define LOG_NUM_MAT_COLS {LOG_NUM_MAT_COLS}

`define NUM_MAT_ROWS_PER_LDPE {NUM_MAT_ROWS_PER_LDPE}
`define LOG_NUM_MAT_ROWS_PER_LDPE {LOG_NUM_MAT_ROWS_PER_LDPE}

`define IN_PRECISION {IN_PRECISION}
`define OUT_PRECISION {OUT_PRECISION}

`define NUM_LDPES {NUM_LDPES}
`define DSPS_PER_LDPE {DSPS_PER_LDPE}
`define DSPS_PER_SUB_LDPE {DSPS_PER_SUB_LDPE}
`define SUB_LDPES_PER_LDPE (`DSPS_PER_LDPE/`DSPS_PER_SUB_LDPE)

`define MULTS_PER_DSP {MULTS_PER_DSP}
`define DSP_X_AVA_INPUT_WIDTH {DSP_X_AVA_INPUT_WIDTH}
`define LDPE_X_AVA_INPUT_WIDTH (`DSP_X_AVA_INPUT_WIDTH * `DSPS_PER_LDPE)
`define DSP_Y_AVA_INPUT_WIDTH {DSP_Y_AVA_INPUT_WIDTH}
`define LDPE_Y_AVA_INPUT_WIDTH (`DSP_Y_AVA_INPUT_WIDTH * `DSPS_PER_LDPE)

`define DSP_AVA_OUTPUT_WIDTH {DSP_AVA_OUTPUT_WIDTH}
`define LDPE_AVA_OUTPUT_WIDTH `DSP_AVA_OUTPUT_WIDTH

`define DSP_USED_INPUT_WIDTH `IN_PRECISION
`define LDPE_USED_INPUT_WIDTH (`DSP_USED_INPUT_WIDTH * `DSPS_PER_LDPE)
`define SUB_LDPE_USED_INPUT_WIDTH (`DSP_USED_INPUT_WIDTH * `DSPS_PER_SUB_LDPE)
`define DSP_X_ZERO_PAD_INPUT_WIDTH (`DSP_X_AVA_INPUT_WIDTH - `DSP_USED_INPUT_WIDTH)
`define DSP_Y_ZERO_PAD_INPUT_WIDTH (`DSP_Y_AVA_INPUT_WIDTH - `DSP_USED_INPUT_WIDTH)

`define DSP_USED_OUTPUT_WIDTH {DSP_USED_OUTPUT_WIDTH}
`define LDPE_USED_OUTPUT_WIDTH `DSP_USED_OUTPUT_WIDTH
`define DSP_ZERO_PAD_OUTPUT_WIDTH (`DSP_AVA_OUTPUT_WIDTH - `DSP_USED_OUTPUT_WIDTH)

//`define MAT_INPUTS_PER_DSP `MULTS_PER_DSP
//`define MAT_BRAMS_PER_DSP ((`DSP_USED_INPUT_WIDTH*`MAT_INPUTS_PER_DSP)/`MAT_BRAM_DWIDTH)
`define LDPES_PER_MRF {LDPES_PER_MRF}
`define DSPS_PER_MRF (`DSPS_PER_LDPE * `LDPES_PER_MRF)
`define MAT_BRAM_AWIDTH {MAT_BRAM_AWIDTH}
`define MAT_BRAM_DWIDTH {MAT_BRAM_DWIDTH}
`define MAT_BRAMS_PER_MRF_SUBSET {MAT_BRAMS_PER_MRF_SUBSET}
`define SUBSETS_PER_MRF {SUBSETS_PER_MRF}
`define BRAMS_PER_MRF (`MAT_BRAMS_PER_MRF_SUBSET * `SUBSETS_PER_MRF)
`define MRF_AWIDTH (`MAT_BRAM_AWIDTH + $clog2(`SUBSETS_PER_MRF))
`define MRF_DWIDTH (`MAT_BRAM_DWIDTH * `MAT_BRAMS_PER_MRF_SUBSET)

//`define VEC_INPUTS_PER_DSP `MULTS_PER_DSP
//`define VEC_BRAMS_PER_DSP ((`DSP_USED_INPUT_WIDTH*`VEC_INPUTS_PER_DSP)/`VEC_BRAM_DWIDTH)
`define LDPES_PER_VRF {LDPES_PER_VRF}
`define DSPS_PER_VRF (`DSPS_PER_LDPE * `LDPES_PER_VRF)
`define VEC_BRAM_AWIDTH {VEC_BRAM_AWIDTH}
`define VEC_BRAM_DWIDTH {VEC_BRAM_DWIDTH}
`define BRAMS_PER_VRF {BRAMS_PER_VRF}
`define VRF_AWIDTH `VEC_BRAM_AWIDTH
`define VRF_DWIDTH (`VEC_BRAM_DWIDTH * `BRAMS_PER_VRF)

`define LDPES_PER_ORF {LDPES_PER_ORF}
`define OUTPUTS_PER_LDPE {OUTPUTS_PER_LDPE}
`define OUT_BRAM_AWIDTH {OUT_BRAM_AWIDTH}
`define OUT_BRAM_DWIDTH {OUT_BRAM_DWIDTH}
`define BRAMS_PER_ORF (`OUT_PRECISION/`OUT_BRAM_DWIDTH)
`define ORF_AWIDTH `OUT_BRAM_AWIDTH
`define ORF_DWIDTH (`OUT_BRAM_DWIDTH * `BRAMS_PER_ORF)
'''.format(
    NUM_MAT_COLS = NUM_MAT_COLS,
    LOG_NUM_MAT_COLS = LOG_NUM_MAT_COLS,
    NUM_MAT_ROWS_PER_LDPE = NUM_MAT_ROWS_PER_LDPE,
    LOG_NUM_MAT_ROWS_PER_LDPE = LOG_NUM_MAT_ROWS_PER_LDPE,
    IN_PRECISION = IN_PRECISION,
    OUT_PRECISION = OUT_PRECISION,
    NUM_LDPES = NUM_LDPES,
    DSPS_PER_LDPE = DSPS_PER_LDPE,
    DSPS_PER_SUB_LDPE = DSPS_PER_SUB_LDPE,
    LDPES_PER_MRF = LDPES_PER_MRF,
    LDPES_PER_VRF = LDPES_PER_VRF,
    LDPES_PER_ORF = LDPES_PER_ORF,
    OUTPUTS_PER_LDPE = OUTPUTS_PER_LDPE,
    MAT_BRAM_AWIDTH = MAT_BRAM_AWIDTH,
    MAT_BRAM_DWIDTH = MAT_BRAM_DWIDTH,
    VEC_BRAM_AWIDTH = VEC_BRAM_AWIDTH,
    VEC_BRAM_DWIDTH = VEC_BRAM_DWIDTH,
    OUT_BRAM_AWIDTH = OUT_BRAM_AWIDTH,
    OUT_BRAM_DWIDTH = OUT_BRAM_DWIDTH,
    MULTS_PER_DSP = MULTS_PER_DSP,
    DSP_X_AVA_INPUT_WIDTH = DSP_X_AVA_INPUT_WIDTH,
    DSP_Y_AVA_INPUT_WIDTH = DSP_Y_AVA_INPUT_WIDTH,
    DSP_AVA_OUTPUT_WIDTH = DSP_AVA_OUTPUT_WIDTH,
    DSP_USED_OUTPUT_WIDTH = DSP_USED_OUTPUT_WIDTH,
    MAT_BRAMS_PER_MRF_SUBSET=MAT_BRAMS_PER_MRF_SUBSET,
    SUBSETS_PER_MRF=SUBSETS_PER_MRF,
    BRAMS_PER_VRF=BRAMS_PER_VRF
)

####################
# Module: baseline #
####################

baseline = '''
module baseline (
    input clk,
    input start,
    input rst,
    input [`VRF_DWIDTH-1:0] vec,
    output done,
    output [`ORF_DWIDTH*`NUM_LDPES-1:0] result
);

    wire [`VRF_DWIDTH-1:0] ina_fake;
    assign ina_fake = {`VRF_DWIDTH{1'b0}};
    wire [`VRF_DWIDTH-1:0] outb_fake;

    wire [`VRF_DWIDTH-1:0] vrf_outa_wire;

    reg [`VRF_AWIDTH-1:0] vrf_rd_addr;
    reg [`VRF_AWIDTH-1:0] vrf_wr_addr;
    reg vec_we;

    reg [`LOG_NUM_MAT_ROWS_PER_LDPE-1:0] row_counter;
    assign done = (row_counter == `NUM_MAT_ROWS_PER_LDPE);

    reg [`LOG_NUM_MAT_COLS-1:0] column_counter;
    wire row_done;

    assign row_done = (column_counter == `NUM_MAT_COLS);

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
    '''

baseline_compute_unit = ''''''
for i in range(1, NUM_LDPES+1):
    compute_unit_temp = '''
    compute_unit unit_{i} (
        .clk(clk),
        .start(start),
        .rst(rst),
        .done(row_done),
        .vec(vrf_outa_wire),
        .result(result[{i}*`ORF_DWIDTH-1:({i}-1)*`ORF_DWIDTH])
    );
'''.format(i=i)
    baseline_compute_unit += compute_unit_temp

baseline_always = '''
    always @(posedge clk) begin
        if (rst || (!start)) begin
            vrf_rd_addr <= 0;
            vrf_wr_addr <= 0;
            vec_we <= 0;
        end
        else begin
            vrf_rd_addr <= vrf_rd_addr + 1;
            vrf_wr_addr <= vrf_wr_addr + 1;
            vec_we <= 1;
        end
    end

    always @(posedge clk) begin
        if (rst || row_done || (!start)) begin
            column_counter <= 0;
        end
        else begin
            column_counter <= column_counter + 1;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            row_counter <= 0;
        end
        else if (row_done) begin
            row_counter <= row_counter + 1;
        end
    end
endmodule
'''
baseline = baseline + baseline_compute_unit + baseline_always


########################
# Module: compute_unit #
########################
compute_unit = '''
module compute_unit (
    input clk,
    input start,
    input rst,
    input done,
    input [`VRF_DWIDTH-1:0] vec,
    output [`ORF_DWIDTH-1:0] result
);

    // Port A of BRAMs is used for feed DSPs and Port B is used to load matrix from off-chip memory

    wire [`MRF_DWIDTH-1:0] in_fake;
    assign in_fake = {`MRF_DWIDTH{1'b0}};
    wire [`MRF_DWIDTH-1:0] mrf_out_wire;

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

    always@(posedge clk) begin
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
        .in(in_fake),
        .we(1'b0),
        .out(mrf_out_wire)
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
'''

################
# Module: LDPE #
################
ldpe = '''
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
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] ldpe_result;
'''

ldpe_subldpe_gen = ''''''
for i in range(1, SUB_LDPES_PER_LDPE+1):
    ldpe_subldpe_gen_temp = '''
    SUB_LDPE sub_{i}(
        .clk(clk),
        .rst(rst),
        .ax(ax[{i}*`SUB_LDPE_USED_INPUT_WIDTH-1:({i}-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .ay(ay[{i}*`SUB_LDPE_USED_INPUT_WIDTH-1:({i}-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .bx(bx[{i}*`SUB_LDPE_USED_INPUT_WIDTH-1:({i}-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .by(by[{i}*`SUB_LDPE_USED_INPUT_WIDTH-1:({i}-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .result(sub_ldpe_result[{i}*`DSP_USED_OUTPUT_WIDTH-1:({i}-1)*`DSP_USED_OUTPUT_WIDTH])
    );
    '''.format(i=i)
    ldpe_subldpe_gen += ldpe_subldpe_gen_temp

adder_tree1 = '''
    adder_tree reduction_unit(
        .clk(clk),
        .rst(rst),'''

adder_tree_input_gen = ''''''
for i in range(0, SUB_LDPES_PER_LDPE):
    adder_tree_input_gen_temp = '''
        .inp{i}(sub_ldpe_result[({i}+1)*`DSP_USED_OUTPUT_WIDTH-1:{i}*`DSP_USED_OUTPUT_WIDTH]),'''.format(i=i)
    adder_tree_input_gen += adder_tree_input_gen_temp

adder_tree2 = '''
        .outp(ldpe_result)
    );'''
ldpe_adder = adder_tree1 + adder_tree_input_gen + adder_tree2


ldpe_always = '''
    always @(posedge clk) begin
        if (rst) begin
            result <= {`LDPE_USED_OUTPUT_WIDTH{1'd0}};
        end
        else begin
            // Result of the last DSP is added to the accumulator
            result <= result + ldpe_result;
        end
    end

endmodule
'''
ldpe = ldpe + ldpe_subldpe_gen + ldpe_adder + ldpe_always

##########################
# Module: Reduction_unit #
##########################
compute_object = generate_compute_unit(SUB_LDPES_PER_LDPE, "fixed{i}".format(i=IN_PRECISION))
reduction_unit = compute_object.printit()

###############################
# Modules: Adder #
###############################
adder = '''
module myadder(
    input [`DSP_USED_OUTPUT_WIDTH-1:0] a,
    input [`DSP_USED_OUTPUT_WIDTH-1:0] b,
    output [`DSP_USED_OUTPUT_WIDTH-1:0] sum
);

    assign sum = a + b;

endmodule
'''

####################
# Module: SUB_LDPE #
####################
sub_ldpe = '''
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
    //assign chainin[1*`DSP_AVA_OUTPUT_WIDTH-1:(1-1)*`DSP_AVA_OUTPUT_WIDTH] = {`DSP_AVA_OUTPUT_WIDTH{1'b0}};
'''

sub_ldpe_chainin_gen = ''''''
for i in range(2, DSPS_PER_SUB_LDPE+1):
    sub_ldpe_chainin_gen_temp = '''
    //assign chainin[{i}*`DSP_USED_OUTPUT_WIDTH-1:({i}-1)*`DSP_USED_OUTPUT_WIDTH] = chainout[({i}-1)*`DSP_USED_OUTPUT_WIDTH-1:({i}-2)*`DSP_USED_OUTPUT_WIDTH];
    '''.format(i=i)

    sub_ldpe_chainin_gen += sub_ldpe_chainin_gen_temp

sub_ldpe_dsp_gen = '''
    wire [36:0] chainout_temp_0;
    assign chainout_temp_0 = 37'b0;
'''
for i in range(1, DSPS_PER_SUB_LDPE+1):
    sub_ldpe_dsp_gen_temp = '''
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_{i};
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_{i};
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_{i};
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_{i};

    assign ax_wire_{i} = {{{{`DSP_X_ZERO_PAD_INPUT_WIDTH{{1'b0}}}}, ax[{i}*`DSP_USED_INPUT_WIDTH-1:({i}-1)*`DSP_USED_INPUT_WIDTH]}};
    assign ay_wire_{i} = {{{{`DSP_Y_ZERO_PAD_INPUT_WIDTH{{1'b0}}}}, ay[{i}*`DSP_USED_INPUT_WIDTH-1:({i}-1)*`DSP_USED_INPUT_WIDTH]}};

    assign bx_wire_{i} = {{{{`DSP_X_ZERO_PAD_INPUT_WIDTH{{1'b0}}}}, bx[{i}*`DSP_USED_INPUT_WIDTH-1:({i}-1)*`DSP_USED_INPUT_WIDTH]}};
    assign by_wire_{i} = {{{{`DSP_Y_ZERO_PAD_INPUT_WIDTH{{1'b0}}}}, by[{i}*`DSP_USED_INPUT_WIDTH-1:({i}-1)*`DSP_USED_INPUT_WIDTH]}};

    //wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainin_temp_{i};
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_{i};
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_{i};

    //assign chainin_temp_{i} = {{{{`DSP_ZERO_PAD_OUTPUT_WIDTH{{1'b0}}}}, chainin[{i}*`DSP_USED_OUTPUT_WIDTH-1:({i}-1)*`DSP_USED_OUTPUT_WIDTH]}};
    //assign chainout[{i}*`DSP_USED_OUTPUT_WIDTH-1:({i}-1)*`DSP_USED_OUTPUT_WIDTH] = chainout_temp_{i}[`DSP_USED_OUTPUT_WIDTH-1:0];
    //assign chainin_temp_{i} = chainin[{i}*`DSP_AVA_OUTPUT_WIDTH-1:({i}-1)*`DSP_AVA_OUTPUT_WIDTH];
    //assign chainout[{i}*`DSP_AVA_OUTPUT_WIDTH-1:({i}-1)*`DSP_AVA_OUTPUT_WIDTH] = chainout_temp_{i};
    assign dsp_result[{i}*`DSP_USED_OUTPUT_WIDTH-1:({i}-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_{i}[`DSP_USED_OUTPUT_WIDTH-1:0];

    dsp_block_18_18_int_sop_2 dsp_{i} (
        .clk(clk),
        .aclr(rst),
        .ax(ax_wire_{i}),
        .ay(ay_wire_{i}),
        .bx(bx_wire_{i}),
        .by(by_wire_{i}),
        .chainin(chainout_temp_{iminus1}),
        .chainout(chainout_temp_{i}),
        //.chainin(chainin[{i}*`DSP_AVA_OUTPUT_WIDTH-1:({i}-1)*`DSP_AVA_OUTPUT_WIDTH]),
        //.chainout(chainout[{i}*`DSP_AVA_OUTPUT_WIDTH-1:({i}-1)*`DSP_AVA_OUTPUT_WIDTH]),
        .result(result_temp_{i})
    );
    '''.format(i=i, iminus1=i-1)
    sub_ldpe_dsp_gen += sub_ldpe_dsp_gen_temp

sub_ldpe_always = '''
    always @(posedge clk) begin
        if (rst) begin
            result <= {`LDPE_USED_OUTPUT_WIDTH{1'd0}};
        end
        else begin
            // Result of the last DSP is added to the accumulator
            result <= dsp_result[`DSPS_PER_SUB_LDPE*`LDPE_USED_OUTPUT_WIDTH-1:(`DSPS_PER_SUB_LDPE-1)*`LDPE_USED_OUTPUT_WIDTH];
        end
    end

endmodule
'''
sub_ldpe = sub_ldpe + sub_ldpe_chainin_gen + sub_ldpe_dsp_gen + sub_ldpe_always

###############
# Module: ORF #
###############
orf = '''
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
    ) out_mem (
        .clk(clk),
        .addr(addr),
        .in(in),
        .we(we),
        .out(out)
    );
endmodule
'''


###############
# Module: VRF #
###############
vrf = '''
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
'''


###############
# Module: MRF #
###############
mrf = '''
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
'''

###############
# Module: DSP #
###############
dsp_block_18_18_int_sop_2 = '''
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
'''

##################
# Module: dp_ram #
##################
dp_ram = '''
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
'''


##################
# Module: sp_ram #
##################
sp_ram = '''
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
'''

final = comment + defines + baseline + compute_unit + ldpe + reduction_unit +adder + sub_ldpe + orf + vrf + mrf + dsp_block_18_18_int_sop_2 + dp_ram + sp_ram

verilog_file = open("baseline_gen.v", "w")
verilog_file.write(final)
verilog_file.close()
