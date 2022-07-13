////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM mfu.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


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
    wire [(`DWIDTH)-1:0] x_0; 
    wire [(`DWIDTH)-1:0] y_0;
    
    add a0(.p(out_data[(1*`DWIDTH)-1:(0*`DWIDTH)]),.x(x_0),.y(y_0), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_1; 
    wire [(`DWIDTH)-1:0] y_1;
    
    add a1(.p(out_data[(2*`DWIDTH)-1:(1*`DWIDTH)]),.x(x_1),.y(y_1), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_2; 
    wire [(`DWIDTH)-1:0] y_2;
    
    add a2(.p(out_data[(3*`DWIDTH)-1:(2*`DWIDTH)]),.x(x_2),.y(y_2), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_3; 
    wire [(`DWIDTH)-1:0] y_3;
    
    add a3(.p(out_data[(4*`DWIDTH)-1:(3*`DWIDTH)]),.x(x_3),.y(y_3), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_4; 
    wire [(`DWIDTH)-1:0] y_4;
    
    add a4(.p(out_data[(5*`DWIDTH)-1:(4*`DWIDTH)]),.x(x_4),.y(y_4), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_5; 
    wire [(`DWIDTH)-1:0] y_5;
    
    add a5(.p(out_data[(6*`DWIDTH)-1:(5*`DWIDTH)]),.x(x_5),.y(y_5), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_6; 
    wire [(`DWIDTH)-1:0] y_6;
    
    add a6(.p(out_data[(7*`DWIDTH)-1:(6*`DWIDTH)]),.x(x_6),.y(y_6), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_7; 
    wire [(`DWIDTH)-1:0] y_7;
    
    add a7(.p(out_data[(8*`DWIDTH)-1:(7*`DWIDTH)]),.x(x_7),.y(y_7), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_8; 
    wire [(`DWIDTH)-1:0] y_8;
    
    add a8(.p(out_data[(9*`DWIDTH)-1:(8*`DWIDTH)]),.x(x_8),.y(y_8), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_9; 
    wire [(`DWIDTH)-1:0] y_9;
    
    add a9(.p(out_data[(10*`DWIDTH)-1:(9*`DWIDTH)]),.x(x_9),.y(y_9), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_10; 
    wire [(`DWIDTH)-1:0] y_10;
    
    add a10(.p(out_data[(11*`DWIDTH)-1:(10*`DWIDTH)]),.x(x_10),.y(y_10), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_11; 
    wire [(`DWIDTH)-1:0] y_11;
    
    add a11(.p(out_data[(12*`DWIDTH)-1:(11*`DWIDTH)]),.x(x_11),.y(y_11), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_12; 
    wire [(`DWIDTH)-1:0] y_12;
    
    add a12(.p(out_data[(13*`DWIDTH)-1:(12*`DWIDTH)]),.x(x_12),.y(y_12), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_13; 
    wire [(`DWIDTH)-1:0] y_13;
    
    add a13(.p(out_data[(14*`DWIDTH)-1:(13*`DWIDTH)]),.x(x_13),.y(y_13), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_14; 
    wire [(`DWIDTH)-1:0] y_14;
    
    add a14(.p(out_data[(15*`DWIDTH)-1:(14*`DWIDTH)]),.x(x_14),.y(y_14), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_15; 
    wire [(`DWIDTH)-1:0] y_15;
    
    add a15(.p(out_data[(16*`DWIDTH)-1:(15*`DWIDTH)]),.x(x_15),.y(y_15), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_16; 
    wire [(`DWIDTH)-1:0] y_16;
    
    add a16(.p(out_data[(17*`DWIDTH)-1:(16*`DWIDTH)]),.x(x_16),.y(y_16), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_17; 
    wire [(`DWIDTH)-1:0] y_17;
    
    add a17(.p(out_data[(18*`DWIDTH)-1:(17*`DWIDTH)]),.x(x_17),.y(y_17), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_18; 
    wire [(`DWIDTH)-1:0] y_18;
    
    add a18(.p(out_data[(19*`DWIDTH)-1:(18*`DWIDTH)]),.x(x_18),.y(y_18), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_19; 
    wire [(`DWIDTH)-1:0] y_19;
    
    add a19(.p(out_data[(20*`DWIDTH)-1:(19*`DWIDTH)]),.x(x_19),.y(y_19), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_20; 
    wire [(`DWIDTH)-1:0] y_20;
    
    add a20(.p(out_data[(21*`DWIDTH)-1:(20*`DWIDTH)]),.x(x_20),.y(y_20), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_21; 
    wire [(`DWIDTH)-1:0] y_21;
    
    add a21(.p(out_data[(22*`DWIDTH)-1:(21*`DWIDTH)]),.x(x_21),.y(y_21), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_22; 
    wire [(`DWIDTH)-1:0] y_22;
    
    add a22(.p(out_data[(23*`DWIDTH)-1:(22*`DWIDTH)]),.x(x_22),.y(y_22), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_23; 
    wire [(`DWIDTH)-1:0] y_23;
    
    add a23(.p(out_data[(24*`DWIDTH)-1:(23*`DWIDTH)]),.x(x_23),.y(y_23), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_24; 
    wire [(`DWIDTH)-1:0] y_24;
    
    add a24(.p(out_data[(25*`DWIDTH)-1:(24*`DWIDTH)]),.x(x_24),.y(y_24), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_25; 
    wire [(`DWIDTH)-1:0] y_25;
    
    add a25(.p(out_data[(26*`DWIDTH)-1:(25*`DWIDTH)]),.x(x_25),.y(y_25), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_26; 
    wire [(`DWIDTH)-1:0] y_26;
    
    add a26(.p(out_data[(27*`DWIDTH)-1:(26*`DWIDTH)]),.x(x_26),.y(y_26), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_27; 
    wire [(`DWIDTH)-1:0] y_27;
    
    add a27(.p(out_data[(28*`DWIDTH)-1:(27*`DWIDTH)]),.x(x_27),.y(y_27), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_28; 
    wire [(`DWIDTH)-1:0] y_28;
    
    add a28(.p(out_data[(29*`DWIDTH)-1:(28*`DWIDTH)]),.x(x_28),.y(y_28), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_29; 
    wire [(`DWIDTH)-1:0] y_29;
    
    add a29(.p(out_data[(30*`DWIDTH)-1:(29*`DWIDTH)]),.x(x_29),.y(y_29), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_30; 
    wire [(`DWIDTH)-1:0] y_30;
    
    add a30(.p(out_data[(31*`DWIDTH)-1:(30*`DWIDTH)]),.x(x_30),.y(y_30), .clk(clk), .reset(~enable_add));
    wire [(`DWIDTH)-1:0] x_31; 
    wire [(`DWIDTH)-1:0] y_31;
    
    add a31(.p(out_data[(32*`DWIDTH)-1:(31*`DWIDTH)]),.x(x_31),.y(y_31), .clk(clk), .reset(~enable_add));

    assign x_0 = primary_inp[(1*`DWIDTH)-1:(0*`DWIDTH)];
    assign x_1 = primary_inp[(2*`DWIDTH)-1:(1*`DWIDTH)];
    assign x_2 = primary_inp[(3*`DWIDTH)-1:(2*`DWIDTH)];
    assign x_3 = primary_inp[(4*`DWIDTH)-1:(3*`DWIDTH)];
    assign x_4 = primary_inp[(5*`DWIDTH)-1:(4*`DWIDTH)];
    assign x_5 = primary_inp[(6*`DWIDTH)-1:(5*`DWIDTH)];
    assign x_6 = primary_inp[(7*`DWIDTH)-1:(6*`DWIDTH)];
    assign x_7 = primary_inp[(8*`DWIDTH)-1:(7*`DWIDTH)];
    assign x_8 = primary_inp[(9*`DWIDTH)-1:(8*`DWIDTH)];
    assign x_9 = primary_inp[(10*`DWIDTH)-1:(9*`DWIDTH)];
    assign x_10 = primary_inp[(11*`DWIDTH)-1:(10*`DWIDTH)];
    assign x_11 = primary_inp[(12*`DWIDTH)-1:(11*`DWIDTH)];
    assign x_12 = primary_inp[(13*`DWIDTH)-1:(12*`DWIDTH)];
    assign x_13 = primary_inp[(14*`DWIDTH)-1:(13*`DWIDTH)];
    assign x_14 = primary_inp[(15*`DWIDTH)-1:(14*`DWIDTH)];
    assign x_15 = primary_inp[(16*`DWIDTH)-1:(15*`DWIDTH)];
    assign x_16 = primary_inp[(17*`DWIDTH)-1:(16*`DWIDTH)];
    assign x_17 = primary_inp[(18*`DWIDTH)-1:(17*`DWIDTH)];
    assign x_18 = primary_inp[(19*`DWIDTH)-1:(18*`DWIDTH)];
    assign x_19 = primary_inp[(20*`DWIDTH)-1:(19*`DWIDTH)];
    assign x_20 = primary_inp[(21*`DWIDTH)-1:(20*`DWIDTH)];
    assign x_21 = primary_inp[(22*`DWIDTH)-1:(21*`DWIDTH)];
    assign x_22 = primary_inp[(23*`DWIDTH)-1:(22*`DWIDTH)];
    assign x_23 = primary_inp[(24*`DWIDTH)-1:(23*`DWIDTH)];
    assign x_24 = primary_inp[(25*`DWIDTH)-1:(24*`DWIDTH)];
    assign x_25 = primary_inp[(26*`DWIDTH)-1:(25*`DWIDTH)];
    assign x_26 = primary_inp[(27*`DWIDTH)-1:(26*`DWIDTH)];
    assign x_27 = primary_inp[(28*`DWIDTH)-1:(27*`DWIDTH)];
    assign x_28 = primary_inp[(29*`DWIDTH)-1:(28*`DWIDTH)];
    assign x_29 = primary_inp[(30*`DWIDTH)-1:(29*`DWIDTH)];
    assign x_30 = primary_inp[(31*`DWIDTH)-1:(30*`DWIDTH)];
    assign x_31 = primary_inp[(32*`DWIDTH)-1:(31*`DWIDTH)];

    assign y_0 = secondary_inp[(1*`DWIDTH)-1:(0*`DWIDTH)];
    assign y_1 = secondary_inp[(2*`DWIDTH)-1:(1*`DWIDTH)];
    assign y_2 = secondary_inp[(3*`DWIDTH)-1:(2*`DWIDTH)];
    assign y_3 = secondary_inp[(4*`DWIDTH)-1:(3*`DWIDTH)];
    assign y_4 = secondary_inp[(5*`DWIDTH)-1:(4*`DWIDTH)];
    assign y_5 = secondary_inp[(6*`DWIDTH)-1:(5*`DWIDTH)];
    assign y_6 = secondary_inp[(7*`DWIDTH)-1:(6*`DWIDTH)];
    assign y_7 = secondary_inp[(8*`DWIDTH)-1:(7*`DWIDTH)];
    assign y_8 = secondary_inp[(9*`DWIDTH)-1:(8*`DWIDTH)];
    assign y_9 = secondary_inp[(10*`DWIDTH)-1:(9*`DWIDTH)];
    assign y_10 = secondary_inp[(11*`DWIDTH)-1:(10*`DWIDTH)];
    assign y_11 = secondary_inp[(12*`DWIDTH)-1:(11*`DWIDTH)];
    assign y_12 = secondary_inp[(13*`DWIDTH)-1:(12*`DWIDTH)];
    assign y_13 = secondary_inp[(14*`DWIDTH)-1:(13*`DWIDTH)];
    assign y_14 = secondary_inp[(15*`DWIDTH)-1:(14*`DWIDTH)];
    assign y_15 = secondary_inp[(16*`DWIDTH)-1:(15*`DWIDTH)];
    assign y_16 = secondary_inp[(17*`DWIDTH)-1:(16*`DWIDTH)];
    assign y_17 = secondary_inp[(18*`DWIDTH)-1:(17*`DWIDTH)];
    assign y_18 = secondary_inp[(19*`DWIDTH)-1:(18*`DWIDTH)];
    assign y_19 = secondary_inp[(20*`DWIDTH)-1:(19*`DWIDTH)];
    assign y_20 = secondary_inp[(21*`DWIDTH)-1:(20*`DWIDTH)];
    assign y_21 = secondary_inp[(22*`DWIDTH)-1:(21*`DWIDTH)];
    assign y_22 = secondary_inp[(23*`DWIDTH)-1:(22*`DWIDTH)];
    assign y_23 = secondary_inp[(24*`DWIDTH)-1:(23*`DWIDTH)];
    assign y_24 = secondary_inp[(25*`DWIDTH)-1:(24*`DWIDTH)];
    assign y_25 = secondary_inp[(26*`DWIDTH)-1:(25*`DWIDTH)];
    assign y_26 = secondary_inp[(27*`DWIDTH)-1:(26*`DWIDTH)];
    assign y_27 = secondary_inp[(28*`DWIDTH)-1:(27*`DWIDTH)];
    assign y_28 = secondary_inp[(29*`DWIDTH)-1:(28*`DWIDTH)];
    assign y_29 = secondary_inp[(30*`DWIDTH)-1:(29*`DWIDTH)];
    assign y_30 = secondary_inp[(31*`DWIDTH)-1:(30*`DWIDTH)];
    assign y_31 = secondary_inp[(32*`DWIDTH)-1:(31*`DWIDTH)];

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
    wire [(`DWIDTH)-1:0] x_0; 
    wire [(`DWIDTH)-1:0] y_0;
    
    mult m0(.p(out_data[(1*`DWIDTH)-1:(0*`DWIDTH)]),.x(x_0),.y(y_0), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_1; 
    wire [(`DWIDTH)-1:0] y_1;
    
    mult m1(.p(out_data[(2*`DWIDTH)-1:(1*`DWIDTH)]),.x(x_1),.y(y_1), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_2; 
    wire [(`DWIDTH)-1:0] y_2;
    
    mult m2(.p(out_data[(3*`DWIDTH)-1:(2*`DWIDTH)]),.x(x_2),.y(y_2), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_3; 
    wire [(`DWIDTH)-1:0] y_3;
    
    mult m3(.p(out_data[(4*`DWIDTH)-1:(3*`DWIDTH)]),.x(x_3),.y(y_3), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_4; 
    wire [(`DWIDTH)-1:0] y_4;
    
    mult m4(.p(out_data[(5*`DWIDTH)-1:(4*`DWIDTH)]),.x(x_4),.y(y_4), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_5; 
    wire [(`DWIDTH)-1:0] y_5;
    
    mult m5(.p(out_data[(6*`DWIDTH)-1:(5*`DWIDTH)]),.x(x_5),.y(y_5), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_6; 
    wire [(`DWIDTH)-1:0] y_6;
    
    mult m6(.p(out_data[(7*`DWIDTH)-1:(6*`DWIDTH)]),.x(x_6),.y(y_6), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_7; 
    wire [(`DWIDTH)-1:0] y_7;
    
    mult m7(.p(out_data[(8*`DWIDTH)-1:(7*`DWIDTH)]),.x(x_7),.y(y_7), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_8; 
    wire [(`DWIDTH)-1:0] y_8;
    
    mult m8(.p(out_data[(9*`DWIDTH)-1:(8*`DWIDTH)]),.x(x_8),.y(y_8), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_9; 
    wire [(`DWIDTH)-1:0] y_9;
    
    mult m9(.p(out_data[(10*`DWIDTH)-1:(9*`DWIDTH)]),.x(x_9),.y(y_9), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_10; 
    wire [(`DWIDTH)-1:0] y_10;
    
    mult m10(.p(out_data[(11*`DWIDTH)-1:(10*`DWIDTH)]),.x(x_10),.y(y_10), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_11; 
    wire [(`DWIDTH)-1:0] y_11;
    
    mult m11(.p(out_data[(12*`DWIDTH)-1:(11*`DWIDTH)]),.x(x_11),.y(y_11), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_12; 
    wire [(`DWIDTH)-1:0] y_12;
    
    mult m12(.p(out_data[(13*`DWIDTH)-1:(12*`DWIDTH)]),.x(x_12),.y(y_12), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_13; 
    wire [(`DWIDTH)-1:0] y_13;
    
    mult m13(.p(out_data[(14*`DWIDTH)-1:(13*`DWIDTH)]),.x(x_13),.y(y_13), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_14; 
    wire [(`DWIDTH)-1:0] y_14;
    
    mult m14(.p(out_data[(15*`DWIDTH)-1:(14*`DWIDTH)]),.x(x_14),.y(y_14), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_15; 
    wire [(`DWIDTH)-1:0] y_15;
    
    mult m15(.p(out_data[(16*`DWIDTH)-1:(15*`DWIDTH)]),.x(x_15),.y(y_15), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_16; 
    wire [(`DWIDTH)-1:0] y_16;
    
    mult m16(.p(out_data[(17*`DWIDTH)-1:(16*`DWIDTH)]),.x(x_16),.y(y_16), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_17; 
    wire [(`DWIDTH)-1:0] y_17;
    
    mult m17(.p(out_data[(18*`DWIDTH)-1:(17*`DWIDTH)]),.x(x_17),.y(y_17), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_18; 
    wire [(`DWIDTH)-1:0] y_18;
    
    mult m18(.p(out_data[(19*`DWIDTH)-1:(18*`DWIDTH)]),.x(x_18),.y(y_18), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_19; 
    wire [(`DWIDTH)-1:0] y_19;
    
    mult m19(.p(out_data[(20*`DWIDTH)-1:(19*`DWIDTH)]),.x(x_19),.y(y_19), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_20; 
    wire [(`DWIDTH)-1:0] y_20;
    
    mult m20(.p(out_data[(21*`DWIDTH)-1:(20*`DWIDTH)]),.x(x_20),.y(y_20), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_21; 
    wire [(`DWIDTH)-1:0] y_21;
    
    mult m21(.p(out_data[(22*`DWIDTH)-1:(21*`DWIDTH)]),.x(x_21),.y(y_21), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_22; 
    wire [(`DWIDTH)-1:0] y_22;
    
    mult m22(.p(out_data[(23*`DWIDTH)-1:(22*`DWIDTH)]),.x(x_22),.y(y_22), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_23; 
    wire [(`DWIDTH)-1:0] y_23;
    
    mult m23(.p(out_data[(24*`DWIDTH)-1:(23*`DWIDTH)]),.x(x_23),.y(y_23), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_24; 
    wire [(`DWIDTH)-1:0] y_24;
    
    mult m24(.p(out_data[(25*`DWIDTH)-1:(24*`DWIDTH)]),.x(x_24),.y(y_24), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_25; 
    wire [(`DWIDTH)-1:0] y_25;
    
    mult m25(.p(out_data[(26*`DWIDTH)-1:(25*`DWIDTH)]),.x(x_25),.y(y_25), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_26; 
    wire [(`DWIDTH)-1:0] y_26;
    
    mult m26(.p(out_data[(27*`DWIDTH)-1:(26*`DWIDTH)]),.x(x_26),.y(y_26), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_27; 
    wire [(`DWIDTH)-1:0] y_27;
    
    mult m27(.p(out_data[(28*`DWIDTH)-1:(27*`DWIDTH)]),.x(x_27),.y(y_27), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_28; 
    wire [(`DWIDTH)-1:0] y_28;
    
    mult m28(.p(out_data[(29*`DWIDTH)-1:(28*`DWIDTH)]),.x(x_28),.y(y_28), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_29; 
    wire [(`DWIDTH)-1:0] y_29;
    
    mult m29(.p(out_data[(30*`DWIDTH)-1:(29*`DWIDTH)]),.x(x_29),.y(y_29), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_30; 
    wire [(`DWIDTH)-1:0] y_30;
    
    mult m30(.p(out_data[(31*`DWIDTH)-1:(30*`DWIDTH)]),.x(x_30),.y(y_30), .clk(clk), .reset(~enable_mul));
    wire [(`DWIDTH)-1:0] x_31; 
    wire [(`DWIDTH)-1:0] y_31;
    
    mult m31(.p(out_data[(32*`DWIDTH)-1:(31*`DWIDTH)]),.x(x_31),.y(y_31), .clk(clk), .reset(~enable_mul));

    assign x_0 = primary_inp[(1*`DWIDTH)-1:(0*`DWIDTH)];
    assign x_1 = primary_inp[(2*`DWIDTH)-1:(1*`DWIDTH)];
    assign x_2 = primary_inp[(3*`DWIDTH)-1:(2*`DWIDTH)];
    assign x_3 = primary_inp[(4*`DWIDTH)-1:(3*`DWIDTH)];
    assign x_4 = primary_inp[(5*`DWIDTH)-1:(4*`DWIDTH)];
    assign x_5 = primary_inp[(6*`DWIDTH)-1:(5*`DWIDTH)];
    assign x_6 = primary_inp[(7*`DWIDTH)-1:(6*`DWIDTH)];
    assign x_7 = primary_inp[(8*`DWIDTH)-1:(7*`DWIDTH)];
    assign x_8 = primary_inp[(9*`DWIDTH)-1:(8*`DWIDTH)];
    assign x_9 = primary_inp[(10*`DWIDTH)-1:(9*`DWIDTH)];
    assign x_10 = primary_inp[(11*`DWIDTH)-1:(10*`DWIDTH)];
    assign x_11 = primary_inp[(12*`DWIDTH)-1:(11*`DWIDTH)];
    assign x_12 = primary_inp[(13*`DWIDTH)-1:(12*`DWIDTH)];
    assign x_13 = primary_inp[(14*`DWIDTH)-1:(13*`DWIDTH)];
    assign x_14 = primary_inp[(15*`DWIDTH)-1:(14*`DWIDTH)];
    assign x_15 = primary_inp[(16*`DWIDTH)-1:(15*`DWIDTH)];
    assign x_16 = primary_inp[(17*`DWIDTH)-1:(16*`DWIDTH)];
    assign x_17 = primary_inp[(18*`DWIDTH)-1:(17*`DWIDTH)];
    assign x_18 = primary_inp[(19*`DWIDTH)-1:(18*`DWIDTH)];
    assign x_19 = primary_inp[(20*`DWIDTH)-1:(19*`DWIDTH)];
    assign x_20 = primary_inp[(21*`DWIDTH)-1:(20*`DWIDTH)];
    assign x_21 = primary_inp[(22*`DWIDTH)-1:(21*`DWIDTH)];
    assign x_22 = primary_inp[(23*`DWIDTH)-1:(22*`DWIDTH)];
    assign x_23 = primary_inp[(24*`DWIDTH)-1:(23*`DWIDTH)];
    assign x_24 = primary_inp[(25*`DWIDTH)-1:(24*`DWIDTH)];
    assign x_25 = primary_inp[(26*`DWIDTH)-1:(25*`DWIDTH)];
    assign x_26 = primary_inp[(27*`DWIDTH)-1:(26*`DWIDTH)];
    assign x_27 = primary_inp[(28*`DWIDTH)-1:(27*`DWIDTH)];
    assign x_28 = primary_inp[(29*`DWIDTH)-1:(28*`DWIDTH)];
    assign x_29 = primary_inp[(30*`DWIDTH)-1:(29*`DWIDTH)];
    assign x_30 = primary_inp[(31*`DWIDTH)-1:(30*`DWIDTH)];
    assign x_31 = primary_inp[(32*`DWIDTH)-1:(31*`DWIDTH)];

    assign y_0 = secondary_inp[(1*`DWIDTH)-1:(0*`DWIDTH)];
    assign y_1 = secondary_inp[(2*`DWIDTH)-1:(1*`DWIDTH)];
    assign y_2 = secondary_inp[(3*`DWIDTH)-1:(2*`DWIDTH)];
    assign y_3 = secondary_inp[(4*`DWIDTH)-1:(3*`DWIDTH)];
    assign y_4 = secondary_inp[(5*`DWIDTH)-1:(4*`DWIDTH)];
    assign y_5 = secondary_inp[(6*`DWIDTH)-1:(5*`DWIDTH)];
    assign y_6 = secondary_inp[(7*`DWIDTH)-1:(6*`DWIDTH)];
    assign y_7 = secondary_inp[(8*`DWIDTH)-1:(7*`DWIDTH)];
    assign y_8 = secondary_inp[(9*`DWIDTH)-1:(8*`DWIDTH)];
    assign y_9 = secondary_inp[(10*`DWIDTH)-1:(9*`DWIDTH)];
    assign y_10 = secondary_inp[(11*`DWIDTH)-1:(10*`DWIDTH)];
    assign y_11 = secondary_inp[(12*`DWIDTH)-1:(11*`DWIDTH)];
    assign y_12 = secondary_inp[(13*`DWIDTH)-1:(12*`DWIDTH)];
    assign y_13 = secondary_inp[(14*`DWIDTH)-1:(13*`DWIDTH)];
    assign y_14 = secondary_inp[(15*`DWIDTH)-1:(14*`DWIDTH)];
    assign y_15 = secondary_inp[(16*`DWIDTH)-1:(15*`DWIDTH)];
    assign y_16 = secondary_inp[(17*`DWIDTH)-1:(16*`DWIDTH)];
    assign y_17 = secondary_inp[(18*`DWIDTH)-1:(17*`DWIDTH)];
    assign y_18 = secondary_inp[(19*`DWIDTH)-1:(18*`DWIDTH)];
    assign y_19 = secondary_inp[(20*`DWIDTH)-1:(19*`DWIDTH)];
    assign y_20 = secondary_inp[(21*`DWIDTH)-1:(20*`DWIDTH)];
    assign y_21 = secondary_inp[(22*`DWIDTH)-1:(21*`DWIDTH)];
    assign y_22 = secondary_inp[(23*`DWIDTH)-1:(22*`DWIDTH)];
    assign y_23 = secondary_inp[(24*`DWIDTH)-1:(23*`DWIDTH)];
    assign y_24 = secondary_inp[(25*`DWIDTH)-1:(24*`DWIDTH)];
    assign y_25 = secondary_inp[(26*`DWIDTH)-1:(25*`DWIDTH)];
    assign y_26 = secondary_inp[(27*`DWIDTH)-1:(26*`DWIDTH)];
    assign y_27 = secondary_inp[(28*`DWIDTH)-1:(27*`DWIDTH)];
    assign y_28 = secondary_inp[(29*`DWIDTH)-1:(28*`DWIDTH)];
    assign y_29 = secondary_inp[(30*`DWIDTH)-1:(29*`DWIDTH)];
    assign y_30 = secondary_inp[(31*`DWIDTH)-1:(30*`DWIDTH)];
    assign y_31 = secondary_inp[(32*`DWIDTH)-1:(31*`DWIDTH)];
    
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
