<%!
    import includes
%>\


`define mdpe_precision ${includes.mdpe_precision} 
`define mdpe_acc_precision ${includes.mdpe_acc_precision}
`define mdpe_acc_precision_log $clog2(`mdpe_acc_precision)
`define mdpe_in_bram_acc_precision ${includes.mdpe_in_bram_acc_precision}
`define mdpe_in_bram_acc_precision_log $clog2(`mdpe_in_bram_acc_precision)
`define mdpe_adder_tree_stages (`mdpe_acc_precision_log-`mdpe_in_bram_acc_precision_log)

`define mdpe_a0_plus_a1_precision (`mdpe_precision + 1)
`define mdpe_product_precision (2*`mdpe_precision)
`define mdpe_chunk_precision (`mdpe_product_precision + 1)

// BRAM
`define mdpe_bram_dwidth ${includes.mdpe_bram_dwidth}
`define mdpe_bram_awidth ${includes.mdpe_bram_awidth}
`define mdpe_bram_xbar_row_addr_log ${includes.mdpe_bram_xbar_row_addr_log}

// COMPUTE RAM
`define mdpe_compute_ram_dwidth `mdpe_bram_dwidth
`define mdpe_compute_ram_awidth `mdpe_bram_awidth
`define mdpe_compute_ram_iwidth `mdpe_compute_ram_dwidth 

`define CRAM_DWIDTH    40
`define LOGDWIDTH 6
`define AWIDTH    9
`define MEM_SIZE  512

`define CMD_ADDR   9'b111111111
`define ALU_CMD    4'b0000
`define COPY_CMD   4'b0001
`define LSHIFT_CMD 4'b0010
`define RSHIFT_CMD 4'b0011
`define NOT_CMD 4'b0100
`define AND_CMD 4'b0101
`define XOR_CMD 4'b0110
`define OR_CMD 4'b0111
`define OP_BITS 16

// MVM RAM 
`define mdpe_mvm_ram_dwidth `mdpe_compute_ram_dwidth
`define mdpe_mvm_ram_awidth `mdpe_compute_ram_awidth

// MVM RAM UNIT
`define mdpe_num_mvm_ram_per_mdpe ${includes.mdpe_num_mvm_ram_per_mdpe}
`define mdpe_mvm_ram_unit_dwidth (`mdpe_mvm_ram_dwidth * `mdpe_num_mvm_ram_per_mdpe)
`define mdpe_mvm_ram_unit_awidth `mdpe_mvm_ram_awidth

// ADDER_TREE
`define mdpe_adder_tree_in_width `mdpe_num_mvm_ram_per_mdpe
`define mdpe_adder_tree_out_width ${includes.result_width}

// ADDER TREE UNIT
`define mdpe_num_adder_tree `mdpe_mvm_ram_dwidth
`define mdpe_adder_tree_unit_in_width (`mdpe_adder_tree_in_width * `mdpe_num_adder_tree)
`define mdpe_adder_tree_unit_out_width (`mdpe_adder_tree_out_width * `mdpe_num_adder_tree)

// OUT RAM
`define mdpe_num_out_ram_per_mdpe ${includes.mdpe_num_out_ram_per_mdpe} 
`define mdpe_out_ram_dwidth `mdpe_compute_ram_dwidth
`define mdpe_out_ram_awidth `mdpe_compute_ram_awidth

// MDPE
`define mdpe_in_dwidth `mdpe_mvm_ram_unit_dwidth
`define mdpe_in_awidth `mdpe_mvm_ram_unit_awidth
`define mdpe_out_used_dwidth (${includes.mdpe_precision} * `mdpe_out_ram_dwidth)
`define mdpe_out_dwidth (${includes.result_width} * `mdpe_out_ram_dwidth)
`define mdpe_out_awidth `mdpe_out_ram_awidth

// MDPE Group
`define num_mdpe ${includes.num_mdpe} 
`define mdpe_group_in_dwidth `mdpe_in_dwidth
`define mdpe_group_in_awidth `mdpe_in_awidth
`define mdpe_group_out_dwidth (`mdpe_out_dwidth * `num_mdpe)
`define mdpe_group_out_used_dwidth (`mdpe_out_used_dwidth * `num_mdpe)
`define mdpe_group_out_awidth `mdpe_out_awidth

`define mdpe_num_mvm_ram_per_fsm ${includes.mdpe_num_mvm_ram_per_fsm}
`define mdpe_num_fsm_per_mdpe (`mdpe_num_mvm_ram_per_mdpe/`mdpe_num_mvm_ram_per_fsm)
`define mdpe_fsm_mvm_ram_awidth (`mdpe_mvm_ram_awidth*`mdpe_num_mvm_ram_per_fsm)
`define mdpe_fsm_compute_ram_iwidth (`mdpe_compute_ram_iwidth*`mdpe_num_mvm_ram_per_fsm)
`define mdpe_fsm_src1_addr_sel_width (2*`mdpe_num_mvm_ram_per_fsm)

// VRF
`define mdpe_vrf_dwdith (2*`mdpe_num_mvm_ram_per_mdpe)
`define mdpe_vrf_awdith 9
`define mdpe_last_vrf_bram_used_dwidth ${includes.mdpe_last_vrf_bram_used_dwidth}
`define mdpe_num_vrf_brams ${includes.mdpe_num_vrf_brams}
`define mdpe_last_vrf_bram_unused_dwidth (`mdpe_bram_dwidth - `mdpe_last_vrf_bram_used_dwidth)



