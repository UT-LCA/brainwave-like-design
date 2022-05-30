<%!
    import math

    num_tiles = 4
    num_ldpes = 32
    num_dsp_per_ldpe = 8
    num_reduction_stages = int(math.log2(num_tiles))
    in_precision = 16
    out_precision = 16

    vec_bram_dwidth = 16
    mat_bram_dwidth = 32
    mac_per_dsp = 2

    target_op_width = int(math.log2(num_ldpes*num_tiles+8)+1)

    mac_per_ldpe = num_dsp_per_ldpe*2
    num_comparison_stages = int(math.log2(mac_per_ldpe))
%>

`define SIMULATION

`define IN_PRECISION ${in_precision}
`define OUT_PRECISION ${out_precision}

`define FLOAT_EXP 8
`define FLOAT_MANTISA 7
`define FLOAT_DWIDTH (`FLOAT_EXP+`FLOAT_MANTISA + 1)

`define BFLOAT_EXP 5
`define BFLOAT_MANTISA 5
`define BFLOAT_DWIDTH (`BFLOAT_EXP + `BFLOAT_MANTISA + 1)
`define BFLOAT_MANTISA_WITH_LO (`BFLOAT_MANTISA+1)

`define NUM_LDPES ${num_ldpes}
`define DSPS_PER_LDPE ${num_dsp_per_ldpe}
`define DSPS_PER_SUB_LDPE ${num_dsp_per_ldpe}
`define SUB_LDPES_PER_LDPE (`DSPS_PER_LDPE/`DSPS_PER_SUB_LDPE)

`define MULTS_PER_DSP 2
`define DSP_X_AVA_INPUT_WIDTH 18
`define LDPE_X_AVA_INPUT_WIDTH (`DSP_X_AVA_INPUT_WIDTH * `DSPS_PER_LDPE)
`define DSP_Y_AVA_INPUT_WIDTH 19
`define LDPE_Y_AVA_INPUT_WIDTH (`DSP_Y_AVA_INPUT_WIDTH * `DSPS_PER_LDPE)

`define DSP_AVA_OUTPUT_WIDTH 37
`define LDPE_AVA_OUTPUT_WIDTH `DSP_AVA_OUTPUT_WIDTH

`define DSP_USED_INPUT_WIDTH (`BFLOAT_MANTISA+1)

`define LDPE_USED_INPUT_WIDTH (`FLOAT_DWIDTH * `DSPS_PER_LDPE)
`define SUB_LDPE_USED_INPUT_WIDTH (`BFLOAT_DWIDTH * `DSPS_PER_SUB_LDPE)
`define DSP_X_ZERO_PAD_INPUT_WIDTH (`DSP_X_AVA_INPUT_WIDTH - `DSP_USED_INPUT_WIDTH)
`define DSP_Y_ZERO_PAD_INPUT_WIDTH (`DSP_Y_AVA_INPUT_WIDTH - `DSP_USED_INPUT_WIDTH)

`define DSP_USED_OUTPUT_WIDTH 27
`define LDPE_USED_OUTPUT_WIDTH `DSP_USED_OUTPUT_WIDTH
`define DSP_ZERO_PAD_OUTPUT_WIDTH (`DSP_AVA_OUTPUT_WIDTH - `DSP_USED_OUTPUT_WIDTH)

`define LDPES_PER_MRF 1
`define DSPS_PER_MRF (`DSPS_PER_LDPE * `LDPES_PER_MRF)
`define MAT_BRAM_AWIDTH 9
`define MAT_BRAM_DWIDTH ${mat_bram_dwidth}
`define MAT_BRAMS_PER_MRF_SUBSET ${int(num_dsp_per_ldpe*mac_per_dsp*in_precision/mat_bram_dwidth)}
`define SUBSETS_PER_MRF 1
`define BRAMS_PER_MRF (`MAT_BRAMS_PER_MRF_SUBSET * `SUBSETS_PER_MRF)
`define MRF_AWIDTH (`MAT_BRAM_AWIDTH + $clog2(`SUBSETS_PER_MRF))
`define MRF_DWIDTH (`MAT_BRAM_DWIDTH * `MAT_BRAMS_PER_MRF_SUBSET)

`define LDPES_PER_VRF 1
`define DSPS_PER_VRF (`DSPS_PER_LDPE * `LDPES_PER_VRF)
`define VEC_BRAM_AWIDTH 10
`define VEC_BRAM_DWIDTH ${vec_bram_dwidth}
`define BRAMS_PER_VRF ${int(num_dsp_per_ldpe*mac_per_dsp*in_precision/vec_bram_dwidth)}
`define VRF_AWIDTH `VEC_BRAM_AWIDTH
`define VRF_DWIDTH (`VEC_BRAM_DWIDTH * `BRAMS_PER_VRF)

`define LDPES_PER_ORF 1
`define OUTPUTS_PER_LDPE 1
`define OUT_BRAM_AWIDTH 10
`define OUT_BRAM_DWIDTH 16
`define ORF_AWIDTH `OUT_BRAM_AWIDTH
`define OUT_DWIDTH ${out_precision}
`define ORF_DWIDTH ${max(out_precision*num_ldpes,vec_bram_dwidth*int(num_dsp_per_ldpe*mac_per_dsp*in_precision/vec_bram_dwidth))}

`define DRAM_DWIDTH `ORF_DWIDTH
`define DRAM_AWIDTH `ORF_AWIDTH

`define OPCODE_WIDTH 4 
`define TARGET_OP_WIDTH ${target_op_width}

`define INSTR_WIDTH `OPCODE_WIDTH+`TARGET_OP_WIDTH+`DRAM_AWIDTH+`TARGET_OP_WIDTH+`VRF_AWIDTH + `VRF_AWIDTH

`define ACTIVATION 2'b00
`define ELT_WISE_MULTIPLY 2'b10
`define ELT_WISE_ADD 2'b01
`define BYPASS 2'b11

`define RELU 2'b00
`define TANH 2'b01
`define SIGM 2'b10
//OPCODES

`define V_RD 0
`define V_WR 1
`define M_RD 2
`define MV_MUL 3
`define VV_ADD 4
`define VV_SUB 5 //QUESTIONED
`define VV_PASS 6
`define VV_MUL 7
`define V_RELU 8
`define V_SIGM 9
`define V_TANH 10
`define END_CHAIN 11
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

`define EXPONENT 5
`define MANTISSA 10

`define SIGN 1
`define NUM_COMPARATOR_TREE_CYCLES ${num_comparison_stages+2}
`define NUM_COMPARATOR_TREE_CYCLES_FOR_TILE ${num_reduction_stages+2}
`define NUM_LZD_CYCLES 5

`define DESIGN_SIZE `NUM_LDPES
`define DWIDTH `OUT_PRECISION
`define MASK_WIDTH `OUT_PRECISION

`define ACTIVATION 2'b00
`define ELT_WISE_MULTIPY 2'b10
`define ELT_WISE_ADD 2'b01
`define BYPASS 2'b11

`define ADD_LATENCY 5
`define LOG_ADD_LATENCY 3
`define MUL_LATENCY 5
`define LOG_MUL_LATENCY 3 
`define ACTIVATION_LATENCY 3
`define TANH_LATENCY (`ACTIVATION_LATENCY+1)
`define SIGMOID_LATENCY (`ACTIVATION_LATENCY+1)

`define NUM_TILES ${num_tiles}
`define NUM_REDUCTION_CYCLES ${num_reduction_stages}
`define NUM_MVM_CYCLES ${num_dsp_per_ldpe+12}
`define NUM_NORMALISE_CYCLES 6
