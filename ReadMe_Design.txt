Design status:

Instructions MV_MUL,VV_MUL,VV_ADD,ACTIVATIONS,VRF_IO, MRF_INPUT are implemented.

Need to add more tiles to MVU - Currently only single tile design with 1 MFU unit present

Need to fix - Dont Care in result bits of each ldpe post conversion of instruction decoder to 
	      sequential logic. Thus, dont care is also added  at the start in reduction logic.
	      Results in dont care result value for end due to only a few cycle dont-care latency. 

ALSO ADD FLOATING POINT CONVERTERS LATER.

Verification status:

Whole design has been tested with MVU with 1 tile and 1 MFU.

Instructions VRF_IO, MRF_IO, MFU Instructions (VV_MUL,VV_ADD,activation - sigmoid, tanh, relu) tested
individually for the MFU, MV_MUL - worked for combinatorial instr_decoder but has issues
mentioned above for sequantial design. 