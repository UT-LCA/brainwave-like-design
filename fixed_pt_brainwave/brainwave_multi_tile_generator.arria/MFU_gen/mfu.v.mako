<%! 
  from includes import num_ldpes, num_elems_mfu, DESIGN_SIZE, out_precision
%>

module MFU( 
    input[1:0] activation_type,
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
    
    wire[`DESIGN_SIZE*`DWIDTH-1:0] compute_operand_1_add;
    wire[`DESIGN_SIZE*`DWIDTH-1:0] compute_operand_1_mul;
    wire[`DESIGN_SIZE*`DWIDTH-1:0] compute_operand_1_act;
    
    assign compute_operand_1_add = ((in_data_available==1'b1)&enable_add) ? primary_inp : 'bX;
    assign compute_operand_1_mul = ((in_data_available==1'b1)&enable_mul) ? primary_inp : 'bX;
    assign compute_operand_1_act = ((in_data_available==1'b1)&enable_activation) ? primary_inp : 'bX;

    wire[`DESIGN_SIZE*`DWIDTH-1:0] compute_operand_2_add;                    
                                                                         
    assign compute_operand_2_add = ((in_data_available==1'b1)&enable_add) ?vrf_outa_add_for_compute:'bX;
    
    wire[`DESIGN_SIZE*`DWIDTH-1:0] compute_operand_2_mul;                    
                                                                         
    assign compute_operand_2_mul = ((in_data_available==1'b1)&enable_mul) ?vrf_outa_mul_for_compute:'bX;
    
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
            `ELT_WISE_MULTIPLY: begin out_data = out_data_mul;
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
    wire add_or_sub;
    assign add_or_sub = activation_type[0];

    elt_wise_add elt_add_unit(
        .enable_add(enable_add),
        .primary_inp(compute_operand_1_add),
        .in_data_available(in_data_available),
        .secondary_inp(compute_operand_2_add),
        .out_data(out_data_add),
        .add_or_sub(add_or_sub), //IMP
        .output_available_add(done_add),
        .clk(clk)
      );
   
    wire done_mul;
    elt_wise_mul elt_mul_unit(
        .enable_mul(enable_mul),
        .in_data_available(in_data_available),
        .primary_inp(compute_operand_1_mul),
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
    .inp_data(compute_operand_1_act),
    .out_data(out_data_act),
    .out_data_available(out_data_available_act),
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
    input [(`DWIDTH)-1:0] x, 
    input [(`DWIDTH)-1:0] y,
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
    input[1:0] activation_type,
    input enable_activation,
    input in_data_available,
    input [`DESIGN_SIZE*`DWIDTH-1:0] inp_data,
    output [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output out_data_available,
    output done_activation,
    input clk,
    input reset
);

% for i in range(DESIGN_SIZE):
wire out_data_available_${i};
wire done_activation_${i};
% endfor

% for i in range(DESIGN_SIZE):
  activation_unit u_act_${i}(
    .activation_type(activation_type),
    .enable_activation(enable_activation),
    .in_data_available(in_data_available),
    .inp_data(inp_data[${i+1}*`DWIDTH-1 : ${i}*`DWIDTH]),
    .out_data(out_data[${i+1}*`DWIDTH-1 : ${i}*`DWIDTH]),
    .out_data_available(out_data_available_${i}),
    .done_activation(done_activation_${i}),
    .clk(clk),
    .reset(reset)
    );
% endfor

assign out_data_available = 
% for i in range(DESIGN_SIZE):
  % if i==(DESIGN_SIZE-1):
  out_data_available_${i};
  % else:
  out_data_available_${i} &
  % endif
% endfor

assign done_activation = 
% for i in range(DESIGN_SIZE):
  % if i==(DESIGN_SIZE-1):
  done_activation_${i};
  % else:
  done_activation_${i} &
  % endif
% endfor

endmodule


module activation_unit(
    input[1:0] activation_type,
    input enable_activation,
    input in_data_available,
    input [`DWIDTH-1:0] inp_data,
    output [`DWIDTH-1:0] out_data,
    output out_data_available,
    output done_activation,
    input clk,
    input reset
);

reg  done_activation_internal;
reg  out_data_available_internal;
wire [`DWIDTH-1:0] out_data_internal;
reg [`DWIDTH-1:0] slope_applied_data_internal;
reg [`DWIDTH-1:0] intercept_applied_data_internal;
reg [`DWIDTH-1:0] relu_applied_data_internal;
reg[31:0] i;
reg[31:0] cycle_count;
reg activation_in_progress;

reg [(4)-1:0] address;

reg [(`DWIDTH)-1:0] data_slope_tanh;
reg [(`DWIDTH)-1:0] data_intercept_tanh;
reg [(`DWIDTH)-1:0] data_slope_sigmoid;
reg [(`DWIDTH)-1:0] data_intercept_sigmoid;

reg [(`DWIDTH)-1:0] data_intercept_delayed;

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

      //for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
         if(activation_type==1) begin // tanH
            slope_applied_data_internal[`DWIDTH-1:0] <= data_slope_tanh[8-1:0] * inp_data[`DWIDTH-1:0];
            data_intercept_delayed[8-1:0] <= data_intercept_tanh[8-1:0];
            intercept_applied_data_internal[`DWIDTH-1:0] <= slope_applied_data_internal[`DWIDTH-1:0] + data_intercept_delayed[8-1:0];
         end 
         else if(activation_type==2) begin // tanH
            slope_applied_data_internal[`DWIDTH-1:0] <= data_slope_sigmoid[8-1:0] * inp_data[`DWIDTH-1:0];
            data_intercept_delayed[8-1:0] <= data_intercept_sigmoid[8-1:0];
            intercept_applied_data_internal[`DWIDTH-1:0] <= slope_applied_data_internal[`DWIDTH-1:0] + data_intercept_delayed[8-1:0];
         end else begin // ReLU
            relu_applied_data_internal[`DWIDTH-1:0] <= inp_data[`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[`DWIDTH-1:0];
         end
      //end   

      //TANH needs 1 extra cycle
      if ((activation_type==1) || (activation_type==2)) begin
         if (cycle_count==`TANH_LATENCY-1) begin
            out_data_available_internal <= 1;
         end
      end else begin
         if (cycle_count==`ACTIVATION_LATENCY-1) begin
           out_data_available_internal <= 1;
         end
      end

      //TANH needs 1 extra cycle
      if ((activation_type==1) || (activation_type==2)) begin
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
    //for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
    case (address[4-1:0])
      4'b0000: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0001: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0010: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d2;
      4'b0011: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d3;
      4'b0100: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d4;
      4'b0101: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0110: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d4;
      4'b0111: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d3;
      4'b1000: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d2;
      4'b1001: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b1010: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
      default: data_slope_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
    endcase  
    //end
end

//LUT for the intercept
always @(address) begin
    //for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
    case (address[4-1:0])
      4'b0000: data_intercept_tanh[`DWIDTH-1:0] = ${out_precision}'d127;
      4'b0001: data_intercept_tanh[`DWIDTH-1:0] = ${out_precision}'d99;
      4'b0010: data_intercept_tanh[`DWIDTH-1:0] = ${out_precision}'d46;
      4'b0011: data_intercept_tanh[`DWIDTH-1:0] = ${out_precision}'d18;
      4'b0100: data_intercept_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0101: data_intercept_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0110: data_intercept_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0111: data_intercept_tanh[`DWIDTH-1:0] = -${out_precision}'d18;
      4'b1000: data_intercept_tanh[`DWIDTH-1:0] = -${out_precision}'d46;
      4'b1001: data_intercept_tanh[`DWIDTH-1:0] = -${out_precision}'d99;
      4'b1010: data_intercept_tanh[`DWIDTH-1:0] = -${out_precision}'d127;
      default: data_intercept_tanh[`DWIDTH-1:0] = ${out_precision}'d0;
    endcase  
    //end
end

always @(address) begin
    //for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
    case (address[4-1:0])
      4'b0000: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0001: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0010: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d2;
      4'b0011: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d3;
      4'b0100: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d4;
      4'b0101: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0110: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d4;
      4'b0111: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d3;
      4'b1000: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d2;
      4'b1001: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b1010: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
      default: data_slope_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
    endcase  
    //end
end

//LUT for the intercept
always @(address) begin
    //for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
    case (address[4-1:0])
      4'b0000: data_intercept_sigmoid[`DWIDTH-1:0] = ${out_precision}'d127;
      4'b0001: data_intercept_sigmoid[`DWIDTH-1:0] = ${out_precision}'d99;
      4'b0010: data_intercept_sigmoid[`DWIDTH-1:0] = ${out_precision}'d46;
      4'b0011: data_intercept_sigmoid[`DWIDTH-1:0] = ${out_precision}'d18;
      4'b0100: data_intercept_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0101: data_intercept_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0110: data_intercept_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
      4'b0111: data_intercept_sigmoid[`DWIDTH-1:0] = -${out_precision}'d18;
      4'b1000: data_intercept_sigmoid[`DWIDTH-1:0] = -${out_precision}'d46;
      4'b1001: data_intercept_sigmoid[`DWIDTH-1:0] = -${out_precision}'d99;
      4'b1010: data_intercept_sigmoid[`DWIDTH-1:0] = -${out_precision}'d127;
      default: data_intercept_sigmoid[`DWIDTH-1:0] = ${out_precision}'d0;
    endcase  
    //end
end

//Logic to find address
always @(inp_data) begin
    //for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
        if((inp_data[`DWIDTH-1:0])>=90) begin
           address[4-1:0] = 4'b0000;
        end
        else if ((inp_data[`DWIDTH-1:0])>=39 && (inp_data[`DWIDTH-1:0])<90) begin
           address[4-1:0] = 4'b0001;
        end
        else if ((inp_data[`DWIDTH-1:0])>=28 && (inp_data[`DWIDTH-1:0])<39) begin
           address[4-1:0] = 4'b0010;
        end
        else if ((inp_data[`DWIDTH-1:0])>=16 && (inp_data[`DWIDTH-1:0])<28) begin
           address[4-1:0] = 4'b0011;
        end
        else if ((inp_data[`DWIDTH-1:0])>=1 && (inp_data[`DWIDTH-1:0])<16) begin
           address[4-1:0] = 4'b0100;
        end
        else if ((inp_data[`DWIDTH-1:0])==0) begin
           address[4-1:0] = 4'b0101;
        end
        else if ((inp_data[`DWIDTH-1:0])>-16 && (inp_data[`DWIDTH-1:0])<=-1) begin
           address[4-1:0] = 4'b0110;
        end
        else if ((inp_data[`DWIDTH-1:0])>-28 && (inp_data[`DWIDTH-1:0])<=-16) begin
           address[4-1:0] = 4'b0111;
        end
        else if ((inp_data[`DWIDTH-1:0])>-39 && (inp_data[`DWIDTH-1:0])<=-28) begin
           address[4-1:0] = 4'b1000;
        end
        else if ((inp_data[`DWIDTH-1:0])>-90 && (inp_data[`DWIDTH-1:0])<=-39) begin
           address[4-1:0] = 4'b1001;
        end
        else if ((inp_data[`DWIDTH-1:0])<=-90) begin
           address[4-1:0] = 4'b1010;
        end
        else begin
           address[4-1:0] = 4'b0101;
        end
    //end
end

endmodule


module elt_wise_add(
    input enable_add,
    input in_data_available,
    input add_or_sub,
    input [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp,
    input [`DESIGN_SIZE*`DWIDTH-1:0] secondary_inp,
    output [`DESIGN_SIZE*`DWIDTH-1:0] out_data,
    output reg output_available_add,
    input clk
);
% for i in range(num_elems_mfu):
    wire [(`DWIDTH)-1:0] x_${i}; 
    wire [(`DWIDTH)-1:0] y_${i};
    
    add a${i}(.p(out_data[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)]),.x(x_${i}),.y(y_${i}), .clk(clk), .reset(~enable_add));
% endfor

% for i in range(num_elems_mfu):
    assign x_${i} = primary_inp[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)];
% endfor

% for i in range(num_elems_mfu):           
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
% for i in range(num_elems_mfu):
    wire [(`DWIDTH)-1:0] x_${i}; 
    wire [(`DWIDTH)-1:0] y_${i};
    
    mult m${i}(.p(out_data[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)]),.x(x_${i}),.y(y_${i}), .clk(clk), .reset(~enable_mul));
% endfor

% for i in range(num_elems_mfu):
    assign x_${i} = primary_inp[(${i+1}*`DWIDTH)-1:(${i}*`DWIDTH)];
% endfor

% for i in range(num_elems_mfu):           
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
