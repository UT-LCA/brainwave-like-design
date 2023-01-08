import math

#########################
# Keep these consistent with the values in the MDPE's includes.py
#########################
num_mdpe=2
mdpe_bram_dwidth=40

num_tiles = 1 #CHANGE THIS
num_ldpes = 80 #
assert(num_ldpes%4==0), "Currently only supporting multiples of 4 here"

num_dsp_per_ldpe = 8 #CHANGE THIS

num_reduction_stages = int(math.log2(num_tiles))

#For asymmetric fifo
num_inputs = num_ldpes + num_mdpe*mdpe_bram_dwidth
assert(num_inputs%4==0),"Currently only supporting multiples of 4 (we have a 4:1 mux in asym fifo)"
num_outputs = int(num_inputs/4) 


precision = 8
bram_data_width_used = 32 #Forcefully using 32 here for easy data layout
elems_in_each_ram = int(bram_data_width_used / precision)
num_inp_rams = int(num_inputs / elems_in_each_ram)
num_ram_outs = int(num_outputs / elems_in_each_ram)
fifo_ram_addr_width = 9
fifo_ram_data_width = 40

num_elems_mfu = num_outputs
DESIGN_SIZE = num_outputs
out_precision = 8

target_op_width = int(math.log2(num_ldpes*num_tiles+8)+1)

in_precision = 8

vec_bram_dwidth = 20
mat_bram_dwidth = 20
mac_per_dsp = 2

orf_dwidth = out_precision * num_outputs
