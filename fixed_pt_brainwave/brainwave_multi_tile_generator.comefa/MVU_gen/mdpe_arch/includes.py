import math

mdpe_precision = 8
mdpe_acc_precision = 26
mdpe_in_bram_acc_precision = 18
mdpe_bram_dwidth = 40
mdpe_bram_awidth = 9
mdpe_bram_xbar_row_addr_log = 7
# For 512,25 LSTM, num_mvm_ram_per_mdpe is 188 but we take 184 because we want to have 8 FSMs per mdpe and 188 is not divisible by 188.
# 184 for LSTM
# 256 for GRU 
mdpe_num_mvm_ram_per_mdpe = 210
mdpe_num_adder_tree = mdpe_bram_dwidth
adder_tree_input_size = mdpe_num_mvm_ram_per_mdpe
# 7 for LSTM
# 5 for GRU
num_mdpe = 2
mdpe_num_out_ram_per_mdpe = 1 #Changed to 1. We don't want to keep the data in 4 output rams per mdpe.

# 23 for LSTM
# 32 for GRU
mdpe_num_mvm_ram_per_fsm = 4
mdpe_num_fsm_per_mdpe = int(mdpe_num_mvm_ram_per_mdpe/mdpe_num_mvm_ram_per_fsm)

mdpe_vrf_dwidth = 2 * mdpe_num_mvm_ram_per_mdpe
mdpe_num_vrf_brams = math.ceil(mdpe_vrf_dwidth/mdpe_bram_dwidth)
available_vrf_dwidth = mdpe_bram_dwidth * mdpe_num_vrf_brams
mdpe_last_vrf_bram_used_dwidth = mdpe_vrf_dwidth - (mdpe_bram_dwidth * (mdpe_num_vrf_brams-1))

#popcount related

#this is the precision of the numbers being shifted out of the compute ram.
#it's basically the precision of the result accumulated inside the compute ram.
#say, if the accumulated result is 14 bits, then DEPTH will be 17
depth = mdpe_in_bram_acc_precision
log_depth = math.ceil(math.log2(depth))

#number of comefa rams in 1 mdpe
#this is the number of values being shifted out of the compute rams at the same time.
#we will be finding the sum of these many number of values
num_rams_in_mdpe = mdpe_num_mvm_ram_per_mdpe

#if I add N 17-bit values, then the number of bits required to represent
#the result will be 17 + log2(N)
result_width = depth + math.ceil(math.log2(num_rams_in_mdpe))

#number of bits required for popcount
#for 32 values, the max sum can be 32.
#this needs 6 bits
popcount_width = math.ceil(math.log2(num_rams_in_mdpe)) + 1
