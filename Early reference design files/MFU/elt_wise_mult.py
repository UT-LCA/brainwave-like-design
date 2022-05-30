design_size = 10
f = open("MFU_gen.v","a")

a = '''module elt_wise_mul(
    input enable_mul,
    input [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp,
    input [`DESIGN_SIZE*`DWIDTH-1:0] secondary_inp,
    output [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output reg output_available_mul,
    input clk
);
    '''
f.write(a)
for i in range(0,design_size):
    a = '''reg [(`DWIDTH>>1)-1:0] x_{i}; 
    reg [(`DWIDTH>>1)-1:0] y_{i};
    
    mult m{i}(.p(out_data[({j}*`DWIDTH)-1:({i}*`DWIDTH)]),.x(x_{i}),.y(y_{i}));
    '''.format(i=i,j=i+1)
    f.write(a)

a = ''' reg[`LOG_MUL_LATENCY-1:0] state;
        always @(posedge clk) begin
        if(enable_mul==1) begin   
                 
                '''
f.write(a)

for j in range(0,design_size):
    a = ''' x_{j} <= primary_inp[{i}*`DWIDTH-1:{j}*`DWIDTH];
            y_{j} <= secondary_inp[{i}*`DWIDTH-1:{j}*`DWIDTH];
        
            '''.format(i=j+1,j=j)
    f.write(a)

a = '''     if(state!=`MUL_LATENCY) begin 
                state<=state+1;
            end
            else begin
                output_available_mul<=1;
                state<=0;
            end
        end
        else begin
          output_available_mul<=0;
          state<=0;
        end
    end

endmodule
'''

f.write(a)