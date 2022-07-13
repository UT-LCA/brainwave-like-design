DWIDTH = 16

with open("./tanh_activation_mem.txt",'w') as f:
    for i in range(1024):
        f.write(bin(i).replace("0b","").zfill(DWIDTH))
        f.write("\n")

with open("./sigmoid_activation_mem.txt",'w') as f:
    for i in range(1024):
        f.write(bin(i).replace("0b","").zfill(DWIDTH))
        f.write("\n")