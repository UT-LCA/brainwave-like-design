import math

num_tiles = 1 #CHANGE THIS
num_ldpes = 64 #
assert(num_ldpes%4==0), "Currently only supporting multiples of 4 here"

num_dsp_per_ldpe = 24 #CHANGE THIS
num_reduction_stages = int(math.log2(num_tiles))
num_inputs = num_ldpes #every cycle we generate `num_ldpes` worth of items from the MVU
assert(num_inputs%2==0),"Currently only supporting even number of outputs from the MVU"
num_outputs = int(num_ldpes/2) #we are saying half will be processed in the MFU. we will use 2:1 muxes
precision = 8
bram_data_width_used = 32 #Forcefully using 32 here for easy data layout
elems_in_each_ram = int(bram_data_width_used / precision)
num_inp_rams = int(num_inputs / elems_in_each_ram)
num_ram_outs = int(num_outputs / elems_in_each_ram)
fifo_ram_addr_width = 9
fifo_ram_data_width = 40

num_elems_mfu = int(num_ldpes/2)
DESIGN_SIZE = int(num_ldpes/2)
out_precision = 8

target_op_width = int(math.log2(num_ldpes*num_tiles+8)+1)

in_precision = 8

vec_bram_dwidth = 20
mat_bram_dwidth = 20
mac_per_dsp = 2

