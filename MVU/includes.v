`define SIMULATION


`define IN_PRECISION 8
`define OUT_PRECISION 32

`define NUM_LDPES 16
`define DSPS_PER_LDPE 16
`define DSPS_PER_SUB_LDPE 4
`define SUB_LDPES_PER_LDPE (`DSPS_PER_LDPE/`DSPS_PER_SUB_LDPE)

`define LDPES_PER_MRF 1
`define DSPS_PER_MRF (`DSPS_PER_LDPE * `LDPES_PER_MRF)

`define LDPES_PER_VRF 1
`define DSPS_PER_VRF (`DSPS_PER_LDPE * `LDPES_PER_VRF)

`define LDPES_PER_ORF 1
`define OUTPUTS_PER_LDPE 1

`define MAT_BRAM_AWIDTH 9
`define MAT_BRAM_DWIDTH 32

`define VEC_BRAM_AWIDTH 10
`define VEC_BRAM_DWIDTH 16

`define OUT_BRAM_AWIDTH 9
`define OUT_BRAM_DWIDTH 32

`define MULTS_PER_DSP 2
`define DSP_AVA_INPUT_WIDTH 9
`define LDPE_AVA_INPUT_WIDTH (`DSP_AVA_INPUT_WIDTH * `DSPS_PER_LDPE)

`define DSP_AVA_OUTPUT_WIDTH 64
`define LDPE_AVA_OUTPUT_WIDTH `DSP_AVA_OUTPUT_WIDTH

`define DSP_USED_INPUT_WIDTH `IN_PRECISION
`define LDPE_USED_INPUT_WIDTH (`DSP_USED_INPUT_WIDTH * `DSPS_PER_LDPE)
`define SUB_LDPE_USED_INPUT_WIDTH (`LDPE_USED_INPUT_WIDTH/`SUB_LDPES_PER_LDPE)
`define DSP_ZERO_PAD_INPUT_WIDTH (`DSP_AVA_INPUT_WIDTH - `DSP_USED_INPUT_WIDTH)

`define DSP_USED_OUTPUT_WIDTH 32
`define LDPE_USED_OUTPUT_WIDTH `DSP_USED_OUTPUT_WIDTH
`define DSP_ZERO_PAD_OUTPUT_WIDTH (`DSP_AVA_OUTPUT_WIDTH - `DSP_USED_OUTPUT_WIDTH)

// `define MAT_INPUTS_PER_DSP `MULTS_PER_DSP
// `define MAT_BRAMS_PER_DSP ((`DSP_USED_INPUT_WIDTH*`MAT_INPUTS_PER_DSP)/`MAT_BRAM_DWIDTH)
`define MAT_BRAMS_PER_MRF_SUBSET 4
`define BRAMS_PER_MRF 4
`define MRF_AWIDTH (`MAT_BRAM_AWIDTH * `BRAMS_PER_MRF)
`define MRF_DWIDTH (`MAT_BRAM_DWIDTH * `MAT_BRAMS_PER_MRF_SUBSET)

// `define VEC_INPUTS_PER_DSP `MULTS_PER_DSP
// `define VEC_BRAMS_PER_DSP ((`DSP_USED_INPUT_WIDTH*`VEC_INPUTS_PER_DSP)/`VEC_BRAM_DWIDTH)
`define BRAMS_PER_VRF 8
`define VRF_AWIDTH `VEC_BRAM_AWIDTH
`define VRF_DWIDTH (`VEC_BRAM_DWIDTH * `BRAMS_PER_VRF)

`define BRAMS_PER_ORF (`OUT_PRECISION/`OUT_BRAM_DWIDTH)
`define ORF_AWIDTH `OUT_BRAM_AWIDTH
`define ORF_DWIDTH (`OUT_BRAM_DWIDTH * `BRAMS_PER_ORF)