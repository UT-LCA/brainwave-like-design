`define DESIGN_SIZE 10
`define DWIDTH 16
`define MASK_WIDTH 8
`define VRF_AWIDTH 10

`define BRAMS_PER_VRF 10
`define VRF_DWIDTH 160
`define VEC_BRAM_AWIDTH 10
`define VEC_BRAM_DWIDTH 16

`define ACTIVATION 2'b00
`define ELT_WISE_MULTIPY 2'b10
`define ELT_WISE_ADD 2'b01
`define BYPASS 2'b11

`define ADD_LATENCY 1
`define LOG_ADD_LATENCY 1
`define MUL_LATENCY 1
`define LOG_MUL_LATENCY 1 

module MFU( 
    input activation_type,
    input[1:0] operation,
    input in_data_available,
    input [`VRF_AWIDTH-1:0] vrf_addr_read_add,
    input [`VRF_AWIDTH-1:0] vrf_addr_write_add,
    input vrf_read_enable_add,
    input vrf_write_enable_add,
    input [`VRF_AWIDTH-1:0] vrf_addr_read_mul,
    input [`VRF_AWIDTH-1:0] vrf_addr_write_mul,
    input vrf_read_enable_mul,
    input vrf_write_enable_mul,
    input [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp,
    input [`DESIGN_SIZE*`DWIDTH-1:0] secondary_inp,
    output reg [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output out_data_available,
    input clk,
    input resetn);

    wire enable_add;
    wire enable_activation;
    wire enable_mul;
    wire done;

    assign enable_activation = (~operation[0])&(~operation[1])&resetn;
    assign enable_add = (operation[0])&(~operation[1])&resetn;
    assign enable_mul = (~operation[0])&(operation[1])&resetn;

    wire [`VRF_DWIDTH-1:0] ina_fake;
    wire [`VRF_DWIDTH-1:0] outa_add;
    wire [`VRF_DWIDTH-1:0] outa_mul;
    wire [`VRF_DWIDTH-1:0] outb_fake;

    wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data_add;
    wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data_mul;
    wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data_act;


    VRF v0(.clk(clk),.addra(vrf_addr_write_add),.addrb(vrf_addr_read_add),.inb(ina_fake),.ina(secondary_inp),.wea(vrf_write_enable_add),.web(vrf_read_enable_add),.outb(outa_add),.outa(outb_fake));

    VRF v1(.clk(clk),.addra(vrf_addr_write_mul),.addrb(vrf_addr_read_mul),.inb(ina_fake),.ina(secondary_inp),.wea(vrf_write_enable_mul),.web(vrf_read_enable_mul),.outb(outa_mul),.outa(outb_fake));

 
    always@(*) begin
    //$display("enable_add '%'d enable_mul '%'d enable_act '%'d",enable_add,enable_mul,enable_activation);
    
      case(operation) 
         `ACTIVATION: begin out_data = out_data_act;
         end
         `ELT_WISE_ADD: begin out_data = out_data_add;
         end
         `ELT_WISE_MULTIPY: begin out_data = out_data_mul;
         end
         `BYPASS: begin out_data = primary_inp; //Bypass the MFU
         end
         default: begin out_data = 0;
         end
      endcase
    end

    elt_wise_add elt_add0(
        .enable_add(enable_add),
        .primary_inp(primary_inp),
        .secondary_inp(outa_add),
        .out_data(out_data_add),
        .output_available_add(done_add),
        .clk(clk));
   
    elt_wise_mul elt_mul0(
        .enable_mul(enable_mul),
        .primary_inp(primary_inp),
        .secondary_inp(outa_mul),
        .out_data(out_data_mul),
        .output_available_mul(done_mul),
        .clk(clk));

    wire out_data_available_act;

    activation act0(
    .activation_type(activation_type),
    .enable_activation(enable_activation),
    .in_data_available(in_data_available),
    .inp_data(primary_inp),
    .out_data(out_data_act),
    .out_data_available(out_data_available_act),
    .validity_mask(8'b00000000), //TODO: Should this be all 1s ?
    .done_activation(done_activation),
    .clk(clk),
    .reset(reset));
   
   assign done = done_activation|done_add|done_mul;
   //TODO: Replace (operation[0]&operation[1]) with `define for operation - NOT POSSIBLE
   assign out_data_available = done|(operation[0]&operation[1]);

   //TODO: demarcate the nomenclature for out_data_available and done signal separately - DONE.
endmodule
    

module VRF (
    input clk,
    input [`VRF_AWIDTH-1:0] addra, addrb,
    input [`VRF_DWIDTH-1:0] ina, inb,
    input wea, web,
    output [`VRF_DWIDTH-1:0] outa, outb
);

    genvar i;
    generate
        for (i=1; i<=`BRAMS_PER_VRF; i=i+1) begin

            dp_ram # (
                .AWIDTH(`VEC_BRAM_AWIDTH),
                .DWIDTH(`VEC_BRAM_DWIDTH)
            ) vec_mem (
                .clk(clk),
                .addra(addra),
                .ina(ina[i*`VEC_BRAM_DWIDTH-1:(i-1)*`VEC_BRAM_DWIDTH]),
                .wea(wea),
                .outa(outa[i*`VEC_BRAM_DWIDTH-1:(i-1)*`VEC_BRAM_DWIDTH]),
                .addrb(addrb),
                .inb(inb[i*`VEC_BRAM_DWIDTH-1:(i-1)*`VEC_BRAM_DWIDTH]),
                .web(web),
                .outb(outb[i*`VEC_BRAM_DWIDTH-1:(i-1)*`VEC_BRAM_DWIDTH])
            );
        end
    endgenerate
endmodule


module mult(p,x,y); 
    output reg [`DWIDTH-1:0] p;
    input [(`DWIDTH>>1)-1:0] x; 
    input [(`DWIDTH>>1)-1:0] y;
    reg [`DWIDTH-1:0] a;
    integer i; 

    always @(x , y)
        begin 
        a=x;
        p=0; // needs to zeroed
        for(i=0;i<(`DWIDTH>>1);i=i+1)
        begin
            if(y[i]) begin
               p=p+a; // must be a blocking assignment
            end
            else begin
              p = p;
            end
            a=a<<1;
        end
    end
endmodule

module add(p,x,y); 
    output reg [`DWIDTH-1:0] p;
    input [`DWIDTH-1:0] x; 
    input [`DWIDTH-1:0] y;

    always @(x , y) begin 
    //$display("p '%'d a '%'d b '%'d",p,x,y);
        p = x + y;
    end
endmodule

module activation(
    input activation_type,
    input enable_activation,
    input in_data_available,
    input [`DESIGN_SIZE*`DWIDTH-1:0] inp_data,
    output [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output out_data_available,
    input [`MASK_WIDTH-1:0] validity_mask,
    output done_activation,
    input clk,
    input reset
);

reg  done_activation_internal;
reg  out_data_available_internal;
wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data_internal;
reg [`DESIGN_SIZE*`DWIDTH-1:0] slope_applied_data_internal;
reg [`DESIGN_SIZE*`DWIDTH-1:0] intercept_applied_data_internal;
reg [`DESIGN_SIZE*`DWIDTH-1:0] relu_applied_data_internal;
integer i;
integer cycle_count;
reg activation_in_progress;

reg [(`DESIGN_SIZE*4)-1:0] address;
reg [(`DESIGN_SIZE*`DWIDTH)-1:0] data_slope;
reg [(`DESIGN_SIZE*`DWIDTH)-1:0] data_intercept;
reg [(`DESIGN_SIZE*`DWIDTH)-1:0] data_intercept_delayed;

// If the activation block is not enabled, just forward the input data
assign out_data             = enable_activation ? out_data_internal : inp_data;
assign done_activation      = enable_activation ? done_activation_internal : 1'b1;
assign out_data_available   = enable_activation ? out_data_available_internal : in_data_available;

always @(posedge clk) begin
   if (reset || ~enable_activation) begin
      slope_applied_data_internal     <= 0;
      intercept_applied_data_internal <= 0; 
      relu_applied_data_internal      <= 0; 
      data_intercept_delayed      <= 0;
      done_activation_internal    <= 0;
      out_data_available_internal <= 0;
      cycle_count                 <= 0;
      activation_in_progress      <= 0;
   end else if(in_data_available || activation_in_progress) begin
      cycle_count = cycle_count + 1;

      for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
         if(activation_type==1'b1) begin // tanH
            slope_applied_data_internal[i*`DWIDTH +:`DWIDTH] <= data_slope[i*8 +: 8] * inp_data[i*`DWIDTH +:`DWIDTH];
            data_intercept_delayed[i*8 +: 8] <= data_intercept[i*8 +: 8];
            intercept_applied_data_internal[i*`DWIDTH +:`DWIDTH] <= slope_applied_data_internal[i*`DWIDTH +:`DWIDTH] + data_intercept_delayed[i*8 +: 8];
         end else begin // ReLU
            relu_applied_data_internal[i*`DWIDTH +:`DWIDTH] <= inp_data[i*`DWIDTH] ? {`DWIDTH{1'b0}} : inp_data[i*`DWIDTH +:`DWIDTH];
         end
      end   

      //TANH needs 1 extra cycle
      if (activation_type==1'b1) begin
         if (cycle_count==2) begin
            out_data_available_internal <= 1;
         end
      end else begin
         if (cycle_count==1) begin
           out_data_available_internal <= 1;
         end
      end

      //TANH needs 1 extra cycle
      if (activation_type==1'b1) begin
        if(cycle_count==(`DESIGN_SIZE+1)) begin
           done_activation_internal <= 1'b1;
           activation_in_progress <= 0;
        end
        else begin
           activation_in_progress <= 1;
        end
      end else begin
        if(cycle_count==(`DESIGN_SIZE)) begin
           done_activation_internal <= 1'b1;
           activation_in_progress <= 0;
        end
        else begin
           activation_in_progress <= 1;
        end
      end
   end
   else begin
      slope_applied_data_internal     <= 0;
      intercept_applied_data_internal <= 0; 
      relu_applied_data_internal      <= 0; 
      data_intercept_delayed      <= 0;
      done_activation_internal    <= 0;
      out_data_available_internal <= 0;
      cycle_count                 <= 0;
      activation_in_progress      <= 0;
   end
end

assign out_data_internal = (activation_type) ? intercept_applied_data_internal : relu_applied_data_internal;

//Our equation of tanh is Y=AX+B
//A is the slope and B is the intercept.
//We store A in one LUT and B in another.
//LUT for the slope
always @(address) begin
    for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
    case (address[i*4+:4])
      4'b0000: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
      4'b0001: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
      4'b0010: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd2;
      4'b0011: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd3;
      4'b0100: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd4;
      4'b0101: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
      4'b0110: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd4;
      4'b0111: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd3;
      4'b1000: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd2;
      4'b1001: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
      4'b1010: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
      default: data_slope[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
    endcase  
    end
end

//LUT for the intercept
always @(address) begin
    for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
    case (address[i*4+:4])
      4'b0000: data_intercept[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd127;
      4'b0001: data_intercept[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd99;
      4'b0010: data_intercept[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd46;
      4'b0011: data_intercept[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd18;
      4'b0100: data_intercept[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
      4'b0101: data_intercept[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
      4'b0110: data_intercept[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
      4'b0111: data_intercept[i*`DWIDTH+:`DWIDTH] = -`DWIDTH'd18;
      4'b1000: data_intercept[i*`DWIDTH+:`DWIDTH] = -`DWIDTH'd46;
      4'b1001: data_intercept[i*`DWIDTH+:`DWIDTH] = -`DWIDTH'd99;
      4'b1010: data_intercept[i*`DWIDTH+:`DWIDTH] = -`DWIDTH'd127;
      default: data_intercept[i*`DWIDTH+:`DWIDTH] = `DWIDTH'd0;
    endcase  
    end
end

//Logic to find address
always @(inp_data) begin
    for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
        if((inp_data[i*`DWIDTH +:`DWIDTH])>=90) begin
           address[i*4+:4] = 4'b0000;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])>=39 && (inp_data[i*`DWIDTH +:`DWIDTH])<90) begin
           address[i*4+:4] = 4'b0001;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])>=28 && (inp_data[i*`DWIDTH +:`DWIDTH])<39) begin
           address[i*4+:4] = 4'b0010;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])>=16 && (inp_data[i*`DWIDTH +:`DWIDTH])<28) begin
           address[i*4+:4] = 4'b0011;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])>=1 && (inp_data[i*`DWIDTH +:`DWIDTH])<16) begin
           address[i*4+:4] = 4'b0100;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])==0) begin
           address[i*4+:4] = 4'b0101;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])>-16 && (inp_data[i*`DWIDTH +:`DWIDTH])<=-1) begin
           address[i*4+:4] = 4'b0110;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])>-28 && (inp_data[i*`DWIDTH +:`DWIDTH])<=-16) begin
           address[i*4+:4] = 4'b0111;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])>-39 && (inp_data[i*`DWIDTH +:`DWIDTH])<=-28) begin
           address[i*4+:4] = 4'b1000;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])>-90 && (inp_data[i*`DWIDTH +:`DWIDTH])<=-39) begin
           address[i*4+:4] = 4'b1001;
        end
        else if ((inp_data[i*`DWIDTH +:`DWIDTH])<=-90) begin
           address[i*4+:4] = 4'b1010;
        end
        else begin
           address[i*4+:4] = 4'b0101;
        end
    end
end

//Adding a dummy signal to use validity_mask input, to make ODIN happy
//TODO: Need to correctly use validity_mask
wire [`MASK_WIDTH-1:0] dummy;
assign dummy = validity_mask;

// generate multiple ReLU block based on the DESIGN_SIZE
//genvar i;
//generate 
//  for (i = 1; i <= `DESIGN_SIZE; i = i + 1) begin : loop_gen_ReLU
//        ReLU ReLUinst (.inp_data(inp_data[i*`DWIDTH-1 -:`DWIDTH]), .out_data(temp[i*`DWIDTH-1 -:`DWIDTH]));
//  end
//endgenerate

endmodule

module dp_ram # (
    parameter AWIDTH = 10,
    parameter DWIDTH = 16
) (
    input clk,
    input [AWIDTH-1:0] addra, addrb,
    input [DWIDTH-1:0] ina, inb,
    input wea, web,
    output reg [DWIDTH-1:0] outa, outb
);

//`ifdef VCS

reg [DWIDTH-1:0] ram [((1<<AWIDTH)-1):0];

// Port A
always @(posedge clk)  begin

    if (wea) begin
        ram[addra] <= ina;
    end

    outa <= ram[addra];
end

// Port B
always @(posedge clk)  begin

    if (web) begin
        ram[addrb] <= inb;
    end

    outb <= ram[addrb];
end
/*
`else

dual_port_ram u_dual_port_ram(
.addr1(addra),
.we1(wea),
.data1(ina),
.out1(outa),
.addr2(addrb),
.we2(web),
.data2(inb),
.out2(outb),
.clk(clk)
);

`endif
*/
endmodule

module elt_wise_add(
    input enable_add,
    input [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp,
    input [`DESIGN_SIZE*`DWIDTH-1:0] secondary_inp,
    output [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output reg output_available_add,
    input clk
);
    reg [(`DWIDTH)-1:0] x_0; 
    reg [(`DWIDTH)-1:0] y_0;
    
    add a0(.p(out_data[(1*`DWIDTH)-1:(0*`DWIDTH)]),.x(x_0),.y(y_0));
    reg [(`DWIDTH)-1:0] x_1; 
    reg [(`DWIDTH)-1:0] y_1;
    
    add a1(.p(out_data[(2*`DWIDTH)-1:(1*`DWIDTH)]),.x(x_1),.y(y_1));
    reg [(`DWIDTH)-1:0] x_2; 
    reg [(`DWIDTH)-1:0] y_2;
    
    add a2(.p(out_data[(3*`DWIDTH)-1:(2*`DWIDTH)]),.x(x_2),.y(y_2));
    reg [(`DWIDTH)-1:0] x_3; 
    reg [(`DWIDTH)-1:0] y_3;
    
    add a3(.p(out_data[(4*`DWIDTH)-1:(3*`DWIDTH)]),.x(x_3),.y(y_3));
    reg [(`DWIDTH)-1:0] x_4; 
    reg [(`DWIDTH)-1:0] y_4;
    
    add a4(.p(out_data[(5*`DWIDTH)-1:(4*`DWIDTH)]),.x(x_4),.y(y_4));
    reg [(`DWIDTH)-1:0] x_5; 
    reg [(`DWIDTH)-1:0] y_5;
    
    add a5(.p(out_data[(6*`DWIDTH)-1:(5*`DWIDTH)]),.x(x_5),.y(y_5));
    reg [(`DWIDTH)-1:0] x_6; 
    reg [(`DWIDTH)-1:0] y_6;
    
    add a6(.p(out_data[(7*`DWIDTH)-1:(6*`DWIDTH)]),.x(x_6),.y(y_6));
    reg [(`DWIDTH)-1:0] x_7; 
    reg [(`DWIDTH)-1:0] y_7;
    
    add a7(.p(out_data[(8*`DWIDTH)-1:(7*`DWIDTH)]),.x(x_7),.y(y_7));
    reg [(`DWIDTH)-1:0] x_8; 
    reg [(`DWIDTH)-1:0] y_8;
    
    add a8(.p(out_data[(9*`DWIDTH)-1:(8*`DWIDTH)]),.x(x_8),.y(y_8));
    reg [(`DWIDTH)-1:0] x_9; 
    reg [(`DWIDTH)-1:0] y_9;
    
    add a9(.p(out_data[(10*`DWIDTH)-1:(9*`DWIDTH)]),.x(x_9),.y(y_9));
     reg[`LOG_ADD_LATENCY-1:0] state;
        always @(posedge clk) begin
        if(enable_add==1) begin   
                 
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
        
                 if(state!=`ADD_LATENCY) begin 
                state<=state+1;
            end
            else begin
                output_available_add<=1;
                state<=0;
            end
        end
        else begin
          output_available_add<=0;
          state<=0;
        end
    end

endmodule
module elt_wise_mul(
    input enable_mul,
    input [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp,
    input [`DESIGN_SIZE*`DWIDTH-1:0] secondary_inp,
    output [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output reg output_available_mul,
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
        end
    end

endmodule
