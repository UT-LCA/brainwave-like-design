import struct
import math

AWIDTH = 10
num_ldpes = 32
num_tiles = 4
max_mem_to_initialize = 300
data_width = 32
TWIDTH = int(math.log2(num_ldpes*num_tiles+8)+1)
print(TWIDTH)

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

vrf_id_dict = dict({
    "V0ADD":bin(num_tiles).replace("0b",'').zfill(TWIDTH),
    "V0MUL":bin(num_tiles+1).replace("0b",'').zfill(TWIDTH),
    "V1ADD":bin(num_tiles+2).replace("0b",'').zfill(TWIDTH),
    "V1MUL":bin(num_tiles+3).replace("0b",'').zfill(TWIDTH),
    "VMUX":bin(num_tiles+4).replace("0b",'').zfill(TWIDTH),
    "VNULL":bin(num_tiles+5).replace("0b",'').zfill(TWIDTH)
})

for i in range(num_tiles):
    vrf_id_dict["VMV"+str(i)] = bin(i).replace("0b",'').zfill(TWIDTH)

mrf_id_dict = dict(zip([("M"+str(int(i))) for i in range(num_ldpes*num_tiles)],[bin(int(i)).replace("0b",'').zfill(TWIDTH) for i in range(num_ldpes*num_tiles)]))

mfu_id_dict = {
    "MF0": bin(0).replace("0b",'').zfill(TWIDTH),
    "MF1": bin(1).replace("0b",'').zfill(TWIDTH)
}

dstn_id_dict = dict({
    "V0ADD":bin(num_tiles).replace("0b",'').zfill(TWIDTH),
    "V0MUL":bin(num_tiles+1).replace("0b",'').zfill(TWIDTH),
    "V1ADD":bin(num_tiles+2).replace("0b",'').zfill(TWIDTH),
    "V1MUL":bin(num_tiles+3).replace("0b",'').zfill(TWIDTH),
    "VMUX":bin(num_tiles+4).replace("0b",'').zfill(TWIDTH),
    "DRAM":bin(num_tiles+5).replace("0b",'').zfill(TWIDTH),
    "MF0":bin(num_tiles+6).replace("0b",'').zfill(TWIDTH),
    "MF1":bin(num_tiles+7).replace("0b",'').zfill(TWIDTH)
})

for i in range(num_tiles):
    dstn_id_dict["VMV"+str(i)] = bin(i).replace("0b",'').zfill(TWIDTH)

data = None
with open("program_gen.bwave",'r') as assembly_code, open("instructions_binary.txt",'w') as machine_code:

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
            num_iter=0
            
            if(opcode=="VRD" or opcode=="VWR"):
                if(opcode == "VWR"):
                    instruction += opcode_dict[opcode] + vrf_id_dict[a[1]].zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + "0".zfill(TWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH)
                else:
                    instruction += opcode_dict[opcode] + "0".zfill(TWIDTH) + bin(int(a[1])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + vrf_id_dict[a[2]].zfill(TWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH)
            elif(opcode=="MRD"):
                instruction += opcode_dict[opcode] + "0".zfill(TWIDTH) + bin(int(a[1])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + mrf_id_dict[a[2]].zfill(TWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH)
            elif(opcode=="MVMUL"):
                if(a[3]!="MF0" and a[3]!="MF1"):
                    instruction += opcode_dict[opcode] + "0".zfill(TWIDTH) + bin(int(a[1])).replace("0b",'').zfill(AWIDTH) +  bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + dstn_id_dict[a[3]].zfill(TWIDTH) + bin(int(a[4])).replace("0b",'').zfill(AWIDTH)
                else:
                    instruction += opcode_dict[opcode] + "0".zfill(TWIDTH) + bin(int(a[1])).replace("0b",'').zfill(AWIDTH) +  bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + dstn_id_dict[a[3]].zfill(TWIDTH) + "0".zfill(AWIDTH)
            elif(opcode=="VVADD" or opcode=="VVMUL" or opcode=="VVSUB" or opcode=="VVPASS" or opcode=="VVRELU" or opcode=="VVSIGM" or opcode=="VVTANH"):
                if(a[1]=="MF0"):
                    vrf_mfu_id = ""

                    if(opcode=="VVADD" or opcode=="VVSUB"):
                        vrf_mfu_id = vrf_id_dict["V0ADD"]
                    elif(opcode=="VVMUL"):
                        vrf_mfu_id = vrf_id_dict["V0MUL"]
                    elif(opcode=="VVRELU" or opcode=="VVSIGM" or opcode=="VVTANH"):
                        vrf_mfu_id = mfu_id_dict["MF0"]
                    else:
                        vrf_mfu_id = "VNULL"

                    if(a[4]=="MF0" or a[4]=="MF1"):
                        instruction += opcode_dict[opcode] + vrf_mfu_id.zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH) + dstn_id_dict[a[4]].zfill(TWIDTH) +  "0".zfill(AWIDTH)
                    else:
                        instruction += opcode_dict[opcode] + vrf_mfu_id.zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + bin(int(a[3])).replace("0b",'').zfill(AWIDTH) + dstn_id_dict[a[4]].zfill(TWIDTH) +  bin(int(a[5])).replace("0b","").zfill(AWIDTH)
                elif(a[1]=="MF1"):
                    vrf_mfu_id = ""
                    
                    if(opcode=="VVADD" or opcode=="VVSUB"):
                            vrf_mfu_id = vrf_id_dict["V1ADD"]
                    elif(opcode=="VVMUL"):
                            vrf_mfu_id = vrf_id_dict["V1MUL"]
                    elif(opcode=="VVRELU" or opcode=="VVSIGM" or opcode=="VVTANH"):
                            vrf_mfu_id = mfu_id_dict["MF1"]
                    else:
                            vrf_mfu_id = "VNULL"

                    if(a[3]=="MF0" or a[3]=="MF1"):
                        instruction += opcode_dict[opcode] + vrf_mfu_id.zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + dstn_id_dict[a[3]].zfill(TWIDTH) +  "0".zfill(AWIDTH)
                    else:
                        instruction += opcode_dict[opcode] + vrf_mfu_id.zfill(TWIDTH) + bin(int(a[2])).replace("0b",'').zfill(AWIDTH) + "0".zfill(AWIDTH) + dstn_id_dict[a[3]].zfill(TWIDTH) +  bin(int(a[4])).replace("0b",'').zfill(AWIDTH)
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
            
            a = [float(k) for k in t[1].split(',')]

            data[int(t[0])] = a

            line = f.readline()


hex_len = 4

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
                    hexa = struct.unpack('H',struct.pack('e',float(data[k][m])))[0]
                    hexa = hex(hexa)
                    hexa = hexa[2:]
            
                    if(data[k][m]==0):
                        f.write("0".zfill(hex_len))
                    else:
                        f .write(hexa)
            f.write("\n")