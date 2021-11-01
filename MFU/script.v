module elt_wise_mult(
    input enable_mul,
    input [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp,
    input [`DESIGN_SIZE*`DWIDTH-1:0] secondary_inp,
    output [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output output_available_mul,
    input clk
);
    reg [(`DWIDTH>>1)-1:0] x_0; 
    reg [(`DWIDTH>>1)-1:0] y_0;
    
    mult m0(.p(out_data[(1*`DWIDTH)-1:(0*`DWIDTH)]),.x(x_0),.y(y_0));
    reg [(`DWIDTH>>1)-1:0] x_1; 
    reg [(`DWIDTH>>1)-1:0] y_1;
    
    mult m1(.p(out_data[(2*`DWIDTH)-1:(1*`DWIDTH)]),.x(x_1),.y(y_1));
    reg [(`DWIDTH>>1)-1:0] x_2; 
    reg [(`DWIDTH>>1)-1:0] y_2;
    
    mult m2(.p(out_data[(3*`DWIDTH)-1:(2*`DWIDTH)]),.x(x_2),.y(y_2));
    reg [(`DWIDTH>>1)-1:0] x_3; 
    reg [(`DWIDTH>>1)-1:0] y_3;
    
    mult m3(.p(out_data[(4*`DWIDTH)-1:(3*`DWIDTH)]),.x(x_3),.y(y_3));
    reg [(`DWIDTH>>1)-1:0] x_4; 
    reg [(`DWIDTH>>1)-1:0] y_4;
    
    mult m4(.p(out_data[(5*`DWIDTH)-1:(4*`DWIDTH)]),.x(x_4),.y(y_4));
    reg [(`DWIDTH>>1)-1:0] x_5; 
    reg [(`DWIDTH>>1)-1:0] y_5;
    
    mult m5(.p(out_data[(6*`DWIDTH)-1:(5*`DWIDTH)]),.x(x_5),.y(y_5));
    reg [(`DWIDTH>>1)-1:0] x_6; 
    reg [(`DWIDTH>>1)-1:0] y_6;
    
    mult m6(.p(out_data[(7*`DWIDTH)-1:(6*`DWIDTH)]),.x(x_6),.y(y_6));
    reg [(`DWIDTH>>1)-1:0] x_7; 
    reg [(`DWIDTH>>1)-1:0] y_7;
    
    mult m7(.p(out_data[(8*`DWIDTH)-1:(7*`DWIDTH)]),.x(x_7),.y(y_7));
    reg [(`DWIDTH>>1)-1:0] x_8; 
    reg [(`DWIDTH>>1)-1:0] y_8;
    
    mult m8(.p(out_data[(9*`DWIDTH)-1:(8*`DWIDTH)]),.x(x_8),.y(y_8));
    reg [(`DWIDTH>>1)-1:0] x_9; 
    reg [(`DWIDTH>>1)-1:0] y_9;
    
    mult m9(.p(out_data[(10*`DWIDTH)-1:(9*`DWIDTH)]),.x(x_9),.y(y_9));
     reg[`LOG_MUL_LATENCY-1:0] state;
        always @(posedge clk) begin
        if(enable_mul==1) begin   
                 
                 x_0 <= primary_inp[1*`DWIDTH-1:0*`DWIDTH];
            y_0 <= secondary_inp[1*`DWIDTH-1:0*`DWIDTH];
        
             x_1 <= primary_inp[2*`DWIDTH-1:1*`DWIDTH];
            y_1 <= secondary_inp[2*`DWIDTH-1:1*`DWIDTH];
        
             x_2 <= primary_inp[3*`DWIDTH-1:2*`DWIDTH];
            y_2 <= secondary_inp[3*`DWIDTH-1:2*`DWIDTH];
        
             x_3 <= primary_inp[4*`DWIDTH-1:3*`DWIDTH];
            y_3 <= secondary_inp[4*`DWIDTH-1:3*`DWIDTH];
        
             x_4 <= primary_inp[5*`DWIDTH-1:4*`DWIDTH];
            y_4 <= secondary_inp[5*`DWIDTH-1:4*`DWIDTH];
        
             x_5 <= primary_inp[6*`DWIDTH-1:5*`DWIDTH];
            y_5 <= secondary_inp[6*`DWIDTH-1:5*`DWIDTH];
        
             x_6 <= primary_inp[7*`DWIDTH-1:6*`DWIDTH];
            y_6 <= secondary_inp[7*`DWIDTH-1:6*`DWIDTH];
        
             x_7 <= primary_inp[8*`DWIDTH-1:7*`DWIDTH];
            y_7 <= secondary_inp[8*`DWIDTH-1:7*`DWIDTH];
        
             x_8 <= primary_inp[9*`DWIDTH-1:8*`DWIDTH];
            y_8 <= secondary_inp[9*`DWIDTH-1:8*`DWIDTH];
        
             x_9 <= primary_inp[10*`DWIDTH-1:9*`DWIDTH];
            y_9 <= secondary_inp[10*`DWIDTH-1:9*`DWIDTH];
        
                 if(state!=`MUL_LATENCY) begin 
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
          out_data<=0;
        end
    end

endmodule
