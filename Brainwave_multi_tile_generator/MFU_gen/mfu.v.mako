<%!
    num_ldpes = 32
%>

`include "includes_gen.v"

`define DESIGN_SIZE `NUM_LDPES
`define DWIDTH `OUT_PRECISION
`define MASK_WIDTH `OUT_PRECISION

`define ACTIVATION 2'b00
`define ELT_WISE_MULTIPY 2'b10
`define ELT_WISE_ADD 2'b01
`define BYPASS 2'b11

`define ADD_LATENCY 1
`define LOG_ADD_LATENCY 1
`define MUL_LATENCY 1
`define LOG_MUL_LATENCY 1 
`define ACTIVATION_LATENCY 1
`define TANH_LATENCY `ACTIVATION_LATENCY+1

module MFU( 
    input activation_type,
    input[1:0] operation,
    input in_data_available,
    input [`ORF_AWIDTH-1:0] vrf_addr_read_add,
    input [`ORF_AWIDTH-1:0] vrf_addr_wr_add,
    input vrf_readn_enable_add,
    input vrf_wr_enable_add,
    input [`ORF_AWIDTH-1:0] vrf_addr_read_mul,
    input [`ORF_AWIDTH-1:0] vrf_addr_wr_mul,
    input vrf_readn_enable_mul,
    input vrf_wr_enable_mul,
    
    input [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp,
    
    input [`ORF_DWIDTH-1:0] secondary_inp,
    output reg [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output done,
    output out_data_available,
    input clk,
    output [`ORF_DWIDTH-1:0] out_vrf_add,
    output [`ORF_DWIDTH-1:0] out_vrf_mul,
    input reset
);

    wire enable_add;
    wire enable_activation;
    wire enable_mul;
    wire done_compute_unit_for_add_mul_act ;

    assign enable_activation = (~operation[0])&(~operation[1])&(~reset);
    
    assign enable_add = (operation[0])&(~operation[1])&(~reset);
    assign enable_mul = (~operation[0])&(operation[1])&(~reset);

    wire [`ORF_DWIDTH-1:0] ina_fake;
    wire [`ORF_DWIDTH-1:0] vrf_outa_add_for_compute;
    wire [`ORF_DWIDTH-1:0] vrf_outa_mul_for_compute;
    //wire [`ORF_DWIDTH-1:0] out_vrf_add;

    wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data_add;
    wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data_mul;
    wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data_act;
    
    wire[`DESIGN_SIZE*`DWIDTH-1:0] compute_operand_1;
    
    assign compute_operand_1 = (in_data_available==1'b1)?primary_inp:'bX;
    
    wire[`DESIGN_SIZE*`DWIDTH-1:0] compute_operand_2_add;                    
                                                                         
    assign compute_operand_2_add = (in_data_available==1'b1)?vrf_outa_add_for_compute:'bX;
    
    wire[`DESIGN_SIZE*`DWIDTH-1:0] compute_operand_2_mul;                    
                                                                         
    assign compute_operand_2_mul = (in_data_available==1'b1)?vrf_outa_mul_for_compute:'bX;
    
    VRF #(.VRF_DWIDTH(`ORF_DWIDTH),.VRF_AWIDTH(`ORF_AWIDTH)) v0(.clk(clk),.addra(vrf_addr_wr_add),.addrb(vrf_addr_read_add),.inb(ina_fake),.ina(secondary_inp),.wea(vrf_wr_enable_add),.web(vrf_readn_enable_add),.outb(vrf_outa_add_for_compute),.outa(out_vrf_add));

    VRF #(.VRF_DWIDTH(`ORF_DWIDTH),.VRF_AWIDTH(`ORF_AWIDTH)) v1(.clk(clk),.addra(vrf_addr_wr_mul),.addrb(vrf_addr_read_mul),.inb(ina_fake),.ina(secondary_inp),.wea(vrf_wr_enable_mul),.web(vrf_readn_enable_mul),.outb(vrf_outa_mul_for_compute),.outa(out_vrf_mul));
 
    always@(*) begin
      if(in_data_available==0) begin
         out_data = 'bX;
      end
      else begin
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
    end
    //FOR ELTWISE ADD-MUL, THE OPERATION IS DONE WHEN THE OUTPUT IS AVAILABLE AT THE OUTPUT PORT
    
    wire done_add;
    elt_wise_add elt_add_unit(
        .enable_add(enable_add),
        .primary_inp(compute_operand_1),
        .in_data_available(in_data_available),
        .secondary_inp(compute_operand_2_add),
        .out_data(out_data_add),
        .output_available_add(done_add),
        .clk(clk)
      );
   
    wire done_mul;
    elt_wise_mul elt_mul_unit(
        .enable_mul(enable_mul),
        .in_data_available(in_data_available),
        .primary_inp(compute_operand_1),
        .secondary_inp(compute_operand_2_mul),
        .out_data(out_data_mul),
        .output_available_mul(done_mul),
        .clk(clk)
      );
    //
    
    wire out_data_available_act;

    wire done_activation;
    activation act_unit(
    .activation_type(activation_type),
    .enable_activation(enable_activation),
    .in_data_available(in_data_available),
    .inp_data(compute_operand_1),
    .out_data(out_data_act),
    .out_data_available(out_data_available_act),
    .validity_mask(8'b00000000), //TODO: Should this be all 1s ?
    .done_activation(done_activation),
    .clk(clk),
    .reset(reset)
    );
   
   //OUT DATA AVAILABLE IS NOT IMPORTANT HERE (CORRESPONDS TO DONE) BUT STILL LETS KEEP IT
   assign done_compute_unit_for_add_mul_act = done_activation|done_add|done_mul;
   assign done = done_compute_unit_for_add_mul_act|(operation==`BYPASS);
   
   assign out_data_available = (out_data_available_act | done_add | done_mul);

   //TODO: demarcate the nomenclature for out_data_available and done signal separately - DONE.
endmodule


module mult(
    input [(`DWIDTH-1)-1:0] x, 
    input [(`DWIDTH-1)-1:0] y,
    input clk,
    input reset,
    output [`DWIDTH-1:0] p
 );
    reg [2*`DWIDTH-1:0] mult_result;

    always @(posedge clk) begin 
    //$display("p '%'d a '%'d b '%'d",p,x,y);
        if(reset==0) begin
            mult_result <= x*y;
        end
    end
    
    //GET TRUNCATED RESULT 
    assign p = mult_result[`DWIDTH-1:0];
    
endmodule

module add( 
    input [`DWIDTH-1:0] x,
    input [`DWIDTH-1:0] y,
    input clk,
    input reset,
    output reg [`DWIDTH-1:0] p
 );
    

    always @(posedge clk) begin 
    //$display("p '%'d a '%'d b '%'d",p,x,y);
        if(reset==0) begin
            p <= x + y;
        end
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
assign out_data             = enable_activation ? out_data_internal : 'bX;
assign done_activation      = enable_activation ? done_activation_internal : 1'b0;
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
         if (cycle_count==`TANH_LATENCY-1) begin
            out_data_available_internal <= 1;
         end
      end else begin
         if (cycle_count==`ACTIVATION_LATENCY-1) begin
           out_data_available_internal <= 1;
         end
      end

      //TANH needs 1 extra cycle
      if (activation_type==1'b1) begin
        if(cycle_count==`TANH_LATENCY-1) begin //REPLACED DESIGN SIZE WITH 1 on the LEFT ****************************************
           done_activation_internal <= 1'b1;
           activation_in_progress <= 0;
        end
        else begin
           activation_in_progress <= 1;
        end
      end else begin
        if(cycle_count==`ACTIVATION_LATENCY-1) begin //REPLACED DESIGN SIZE WITH 1 on the LEFT ************************************
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


module elt_wise_add(
    input enable_add,
    input in_data_available,
    input [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp,
    input [`DESIGN_SIZE*`DWIDTH-1:0] secondary_inp,
    output [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output reg output_available_add,
    input clk
);
% for i in range(num_ldpes):
    wire [(`DWIDTH)-1:0] x_${i}; 
    wire [(`DWIDTH)-1:0] y_${i};
    
    add a${i}(.p(out_data[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)]),.x(x_${i}),.y(y_${i}), .clk(clk), .reset(~enable_add));
% endfor

% for i in range(num_ldpes):
    assign x_${i} = primary_inp[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)];
% endfor

% for i in range(num_ldpes):           
    assign y_${i} = secondary_inp[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)];
% endfor

     reg[`LOG_ADD_LATENCY-1:0] state;
     always @(posedge clk) begin
        if((enable_add==1'b1) && (in_data_available==1'b1)) begin   
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
    input in_data_available,
    input [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp,
    input [`DESIGN_SIZE*`DWIDTH-1:0] secondary_inp,
    output [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output reg output_available_mul,
    input clk
);
% for i in range(num_ldpes):
    wire [(`DWIDTH)-1:0] x_${i}; 
    wire [(`DWIDTH)-1:0] y_${i};
    
    mult m${i}(.p(out_data[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)]),.x(x_${i}),.y(y_${i}), .clk(clk), .reset(~enable_mul));
% endfor

% for i in range(num_ldpes):
    assign x_${i} = primary_inp[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)];
% endfor

% for i in range(num_ldpes):           
    assign y_${i} = secondary_inp[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)];
% endfor
    
     reg[`LOG_MUL_LATENCY-1:0] state;
        always @(posedge clk) begin
        if((enable_mul==1'b1) && (in_data_available==1'b1)) begin   
        
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
