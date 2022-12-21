<%!
    import math

    num_tiles = 2 #CHANGE THIS
    num_ldpes = 16 #CHANGE THIS
    num_dsp_per_ldpe = 0 #Not used
    num_reduction_stages = int(math.log2(num_tiles))
    ts_size = 8
    in_precision = 8
    out_precision = 8

    vec_bram_dwidth = 16
    mat_bram_dwidth = 16
    mac_per_dsp = 2

    target_op_width = int(math.log2(num_ldpes*num_tiles+8)+1)
%>

/* Author: Tanmay Anand, Visiting Student, UT-LCA
Email: tanmay.anand29@gmail.com
GItHub Username: saitama0300 */

`define INT16_MAT_MUL_SIZE 4
`define INT16_DWIDTH 16
`define DTYPE_INT8  2'b00
`define DTYPE_INT16 2'b01
`define DTYPE_FP16  2'b10
`define DTYPE_BF16  2'b11

`define SLICE_MODE_TENSOR 1'b0
`define SLICE_MODE_INDIV_PE 1'b1
`define ELTWISE_MUL 2'b01
`define ELTWISE_ADD 2'b10
`define ELTWISE_SUB 2'b11


`define tensor_slice_hard_block

`define IN_PRECISION ${in_precision}
`define OUT_PRECISION ${out_precision}

`define NUM_TILES ${num_tiles}

`define NUM_LDPES ${num_ldpes}
//`define DSPS_PER_LDPE ${num_dsp_per_ldpe}
//`define DSPS_PER_SUB_LDPE ${num_dsp_per_ldpe}
//`define SUB_LDPES_PER_LDPE (`DSPS_PER_LDPE/`DSPS_PER_SUB_LDPE)

//`define MULTS_PER_DSP 2
//`define DSP_X_AVA_INPUT_WIDTH 18
//`define LDPE_X_AVA_INPUT_WIDTH (`DSP_X_AVA_INPUT_WIDTH * `DSPS_PER_LDPE)
//`define DSP_Y_AVA_INPUT_WIDTH 19
//`define LDPE_Y_AVA_INPUT_WIDTH (`DSP_Y_AVA_INPUT_WIDTH * `DSPS_PER_LDPE)
//
//`define DSP_AVA_OUTPUT_WIDTH 37
//`define LDPE_AVA_OUTPUT_WIDTH `DSP_AVA_OUTPUT_WIDTH

`define DSP_USED_INPUT_WIDTH `IN_PRECISION
`define LDPE_USED_INPUT_WIDTH 32 //half of the tensor slice input width
//`define SUB_LDPE_USED_INPUT_WIDTH (`DSP_USED_INPUT_WIDTH * `DSPS_PER_SUB_LDPE)
//`define DSP_X_ZERO_PAD_INPUT_WIDTH (`DSP_X_AVA_INPUT_WIDTH - `DSP_USED_INPUT_WIDTH)
//`define DSP_Y_ZERO_PAD_INPUT_WIDTH (`DSP_Y_AVA_INPUT_WIDTH - `DSP_USED_INPUT_WIDTH)

`define DSP_USED_OUTPUT_WIDTH 64 //tensor slice output width
`define LDPE_USED_OUTPUT_WIDTH `DSP_USED_OUTPUT_WIDTH
//`define DSP_ZERO_PAD_OUTPUT_WIDTH (`DSP_AVA_OUTPUT_WIDTH - `DSP_USED_OUTPUT_WIDTH)

`define LDPES_PER_MRF 1
//`define DSPS_PER_MRF (`DSPS_PER_LDPE * `LDPES_PER_MRF)
`define MAT_BRAM_AWIDTH 10
`define MAT_BRAM_DWIDTH ${mat_bram_dwidth}
`define MAT_BRAMS_PER_MRF_SUBSET 4
`define MRF_AWIDTH (`MAT_BRAM_AWIDTH)
`define MRF_DWIDTH (`MAT_BRAM_DWIDTH * `MAT_BRAMS_PER_MRF_SUBSET)

`define ORF_DWIDTH ${ts_size*out_precision*num_ldpes} //${max(out_precision*num_ldpes,vec_bram_dwidth*int(num_dsp_per_ldpe*mac_per_dsp*in_precision/vec_bram_dwidth))}

`define MAX_VRF_DWIDTH ${max(out_precision*ts_size*num_ldpes,128)}
`define DRAM_DWIDTH (`MRF_DWIDTH + `ORF_DWIDTH + `VRF_DWIDTH) //KEEP THIS LARGE TO AVOID OPTIMIZATION IN VTR 
`define DRAM_AWIDTH `MRF_AWIDTH

`define LDPES_PER_VRF 1
//`define DSPS_PER_VRF (`DSPS_PER_LDPE * `LDPES_PER_VRF)
`define VEC_BRAM_AWIDTH 10
`define VEC_BRAM_DWIDTH ${vec_bram_dwidth}
`define BRAMS_PER_VRF ${int(128/vec_bram_dwidth)}
`define VRF_AWIDTH `VEC_BRAM_AWIDTH
`define VRF_DWIDTH (`VEC_BRAM_DWIDTH * `BRAMS_PER_VRF)

`define LDPES_PER_ORF 1
`define OUTPUTS_PER_LDPE 1
`define OUT_BRAM_AWIDTH 10
`define OUT_BRAM_DWIDTH 16
`define ORF_AWIDTH `OUT_BRAM_AWIDTH
`define OUT_DWIDTH ${out_precision*ts_size}
//`define ORF_DWIDTH `OUT_DWIDTH*`NUM_LDPES


`define DESIGN_SIZE ${num_ldpes*ts_size}
`define DWIDTH `OUT_PRECISION
`define MASK_WIDTH `OUT_PRECISION

`define ACTIVATION 2'b00
`define ELT_WISE_MULTIPLY 2'b10
`define ELT_WISE_ADD 2'b01
`define BYPASS 2'b11

`define ADD_LATENCY 1
`define LOG_ADD_LATENCY 1
`define MUL_LATENCY 1
`define LOG_MUL_LATENCY 1 
`define ACTIVATION_LATENCY 1
`define TANH_LATENCY `ACTIVATION_LATENCY+1


`define RELU 2'b00
`define TANH 2'b01
`define SIGM 2'b10
//OPCODES

`define V_RD 0
`define V_WR 1
`define M_RD 2
`define M_WR 3
`define MV_MUL 4
`define VV_ADD 5
`define VV_SUB 6 //QUESTIONED
`define VV_PASS 7
`define VV_MUL 8
`define V_RELU 9
`define V_SIGM 10
`define V_TANH 11
`define END_CHAIN 12

//MEM_IDS

% for i in range(num_tiles):
`define VRF_${i} ${i}
% endfor

`define VRF_${num_tiles} ${num_tiles}
`define VRF_${num_tiles+1} ${num_tiles+1}
`define VRF_${num_tiles+2} ${num_tiles+2}
`define VRF_${num_tiles+3} ${num_tiles+3}
`define VRF_MUXED ${num_tiles+4}
`define DRAM_MEM_ID ${num_tiles+5}
`define MFU_0_DSTN_ID ${num_tiles+6}
`define MFU_1_DSTN_ID ${num_tiles+7}


% for i in range(num_tiles*num_ldpes):
`define MRF_${i} ${i}
% endfor

`define MFU_0 0
`define MFU_1 1

`define INSTR_MEM_AWIDTH 10

`define NUM_MVM_CYCLES ${num_dsp_per_ldpe+num_reduction_stages+1}

`define OPCODE_WIDTH 4 
`define TARGET_OP_WIDTH ${target_op_width}

`define INSTR_WIDTH `OPCODE_WIDTH+`TARGET_OP_WIDTH+`DRAM_AWIDTH+`TARGET_OP_WIDTH+`VRF_AWIDTH + `VRF_AWIDTH
