opcode_dict = {
    "VRD":"0000",
    "VWR":"0001",
    "MRD":"0010",
    "MVMUL":"0011",
    "VVADD":"0100",
    "VVSUB":"0101",
    "VVPASS":"0110",
    "VVMUL":"0111",
    "VVRELU":"1000",
    "VVSIGM":"1001",
    "VVTANH":"1010",
    "ENDCHAIN":"1011"
}

vrf_id_dict = {
    "VMV0":"0000",
    "VMV1":"0001",
    "V0ADD":"0010",
    "V0MUL":"0011",
    "V1ADD":"0100",
    "V1MUL":"0101",
    "VMUX":"0110",
    "VNULL":"1111"
}

mrf_id_dict = {
    "M0":"0000",
    "M1":"0001",
    "M2":"0010",
    "M3":"0011"
}

mfu_id_dict = {
    "MF0":"0000",
    "MF1":"0001"
}

dstn_id_dict = {
    "VMV0":"0000",
    "VMV1":"0001",
    "V0ADD":"0010",
    "V0MUL":"0011",
    "V1ADD":"0100",
    "V1MUL":"0101",
    "VMUX":"0110",
    "DRAM":"0111",
    "MF0":"1000",
    "MF1":"1001"
}
AWIDTH = 10
TWIDTH = 4
max_mem_to_initialize = 30
data_width = 10

data = None
with open("program.bwave",'r') as assembly_code, open("instructions_binary.txt",'w') as machine_code:

    line = assembly_code.readline()
    while (line and line != ".code\n"): 
        line = assembly_code.readline()

    if(line == ".code\n"):
   
        line = assembly_code.readline()
        while line !=".endcode\n":

            if(line[0:2]=="//"):
                #print(line[0:2])
                line = assembly_code.readline()
                continue

            instruction = ""
            a = line.split()
            opcode = a[0]
            
            if(opcode=="VRD" or opcode=="VWR"):
                if(opcode == "VWR"):
                    instruction += opcode_dict[opcode] + vrf_id_dict[a[1]].zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + "0".zfill(TWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH)
                else:
                    instruction += opcode_dict[opcode] + "0".zfill(TWIDTH) + bin(int(a[1])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + vrf_id_dict[a[2]].zfill(TWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH)
            elif(opcode=="MRD"):
                instruction += opcode_dict[opcode] + "0".zfill(TWIDTH) + bin(int(a[1])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + mrf_id_dict[a[2]].zfill(TWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH)
            elif(opcode=="MVMUL"):
                instruction += opcode_dict[opcode] + "0".zfill(TWIDTH) + bin(int(a[1])).replace("0b",'').zfill(AWIDTH) +  bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + dstn_id_dict[a[3]].zfill(TWIDTH) + bin(int(a[4])).replace("0b",'').zfill(AWIDTH)
            elif(opcode=="VVADD" or opcode=="VVMUL" or opcode=="VVSUB" or opcode=="VVPASS" or opcode=="VVRELU" or opcode=="VVSIGM" or opcode=="VVTANH"):
                if(a[1]=="MF0"):
                    if(a[4]=="MF0" or a[4]=="MF1"):
                        vrf_mfu_id = ""
                        if(opcode=="VVADD"):
                            vrf_mfu_id = "V0ADD"
                        elif(opcode=="VVMUL"):
                            vrf_mfu_id = "V0MUL"
                        else:
                            vrf_mfu_id = "VNULL"

                        instruction += opcode_dict[opcode] + vrf_id_dict[vrf_mfu_id].zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH) + dstn_id_dict[a[4]].zfill(TWIDTH) +  "0".zfill(AWIDTH)
                    else:
                        instruction += opcode_dict[opcode] + vrf_id_dict[vrf_mfu_id].zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH) + dstn_id_dict[a[4]].zfill(TWIDTH) +  bin(int(a[5])).replace("0b").zfill(AWIDTH)
                elif(a[1]=="MF1"):
                    vrf_mfu_id = ""
                    if(opcode=="VVADD"):
                        vrf_mfu_id = "V1ADD"
                    elif(opcode=="VVMUL"):
                        vrf_mfu_id = "V1MUL"
                    else:
                        vrf_mfu_id = "VNULL"

                    if(a[3]=="MF0" or a[3]=="MF1"):
                        instruction += opcode_dict[opcode] + vrf_id_dict[vrf_mfu_id].zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + dstn_id_dict[a[3]].zfill(TWIDTH) +  "0".zfill(AWIDTH)
                    else:
                        instruction += opcode_dict[opcode] + vrf_id_dict[vrf_mfu_id].zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + dstn_id_dict[a[3]].zfill(TWIDTH) +  bin(int(a[4])).replace("0b",'').zfill(AWIDTH)
                else:
                    raise Exception
            else:
                instruction += opcode_dict["ENDCHAIN"] + "0".zfill((2*TWIDTH)+(3*AWIDTH))

            machine_code.write(instruction)
            machine_code.write("\n")
            line = assembly_code.readline()

    data = [[None for i in range(data_width)] for j in range(max_mem_to_initialize)]

    f = assembly_code
    while (line and line != ".mem\n"): 
        line = f.readline()

    if line==".mem\n":
       
        line = f.readline()
        
        while line!=".endmem":
            if(line[0:2]=="//"):
                #print(line)
                line = f.readline()
                continue
            t = line.split()

            if((len(t)!=2) or (int(t[0]) >= max_mem_to_initialize)):
                line = f.readline()
                continue
            
            a = [int(k) for k in t[1].split(',')]

            data[int(t[0])] = a

            line = f.readline()


hex_len = 2

with open("dram_data.txt",'w') as f:
    '''
    for j in range(len(vector)):
        f .write(hex(vector[j]).replace('0x','').zfill(hex_len))
    f.write("\n")
    '''
    if data:
        for k in range(len(data)):
            for m in range(data_width):
                
                if(data[k][m]==None):
                    f.write("X".rjust(hex_len,"X"))
                else:
                    f .write(hex(data[k][m]).replace('0x','').zfill(hex_len))
            f.write("\n")