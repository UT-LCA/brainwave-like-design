////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM mfu.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


//`include "includes_gen.v"
//`include "floating_pt_gen.v"
//HELLO

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

reg[4:0] cycle_count;
reg  done_activation_internal;
reg  out_data_available_internal;
wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data_internal;
reg [`DESIGN_SIZE*`DWIDTH-1:0] relu_applied_data_internal;

reg activation_in_progress;

reg [(`DESIGN_SIZE*`DWIDTH)-1:0] sigmoid_applied_data_internal;
reg [(`DESIGN_SIZE*`DWIDTH)-1:0] tanh_applied_data_internal;


wire [(`DESIGN_SIZE*`DWIDTH)-1:0] sigmoid_activation_file_output;
wire [(`DESIGN_SIZE*`DWIDTH)-1:0] tanh_activation_file_output;


// If the activation block is not enabled, just forward the input data
assign out_data             = enable_activation ? out_data_internal : 'bX;
assign done_activation      = enable_activation ? done_activation_internal : 1'b0;
assign out_data_available   = enable_activation ? out_data_available_internal : in_data_available;

always @(posedge clk) begin
   if (reset || ~enable_activation) begin
      relu_applied_data_internal  <= 'bX; 
      done_activation_internal    <= 0;
      out_data_available_internal <= 0;
      cycle_count                 <= 0;
      activation_in_progress      <= 0;
      sigmoid_applied_data_internal <= 'bX;
      tanh_applied_data_internal <= 'bX;
   end else if(in_data_available || activation_in_progress) begin
      cycle_count <= cycle_count + 1;

      if(activation_type==2) begin // tanH
            sigmoid_applied_data_internal[1*`DWIDTH-1:(1-1)*`DWIDTH] <= sigmoid_activation_file_output[1*`DWIDTH-1:(1-1)*`DWIDTH];
            sigmoid_applied_data_internal[2*`DWIDTH-1:(2-1)*`DWIDTH] <= sigmoid_activation_file_output[2*`DWIDTH-1:(2-1)*`DWIDTH];
            sigmoid_applied_data_internal[3*`DWIDTH-1:(3-1)*`DWIDTH] <= sigmoid_activation_file_output[3*`DWIDTH-1:(3-1)*`DWIDTH];
            sigmoid_applied_data_internal[4*`DWIDTH-1:(4-1)*`DWIDTH] <= sigmoid_activation_file_output[4*`DWIDTH-1:(4-1)*`DWIDTH];
            sigmoid_applied_data_internal[5*`DWIDTH-1:(5-1)*`DWIDTH] <= sigmoid_activation_file_output[5*`DWIDTH-1:(5-1)*`DWIDTH];
            sigmoid_applied_data_internal[6*`DWIDTH-1:(6-1)*`DWIDTH] <= sigmoid_activation_file_output[6*`DWIDTH-1:(6-1)*`DWIDTH];
            sigmoid_applied_data_internal[7*`DWIDTH-1:(7-1)*`DWIDTH] <= sigmoid_activation_file_output[7*`DWIDTH-1:(7-1)*`DWIDTH];
            sigmoid_applied_data_internal[8*`DWIDTH-1:(8-1)*`DWIDTH] <= sigmoid_activation_file_output[8*`DWIDTH-1:(8-1)*`DWIDTH];
            sigmoid_applied_data_internal[9*`DWIDTH-1:(9-1)*`DWIDTH] <= sigmoid_activation_file_output[9*`DWIDTH-1:(9-1)*`DWIDTH];
            sigmoid_applied_data_internal[10*`DWIDTH-1:(10-1)*`DWIDTH] <= sigmoid_activation_file_output[10*`DWIDTH-1:(10-1)*`DWIDTH];
            sigmoid_applied_data_internal[11*`DWIDTH-1:(11-1)*`DWIDTH] <= sigmoid_activation_file_output[11*`DWIDTH-1:(11-1)*`DWIDTH];
            sigmoid_applied_data_internal[12*`DWIDTH-1:(12-1)*`DWIDTH] <= sigmoid_activation_file_output[12*`DWIDTH-1:(12-1)*`DWIDTH];
            sigmoid_applied_data_internal[13*`DWIDTH-1:(13-1)*`DWIDTH] <= sigmoid_activation_file_output[13*`DWIDTH-1:(13-1)*`DWIDTH];
            sigmoid_applied_data_internal[14*`DWIDTH-1:(14-1)*`DWIDTH] <= sigmoid_activation_file_output[14*`DWIDTH-1:(14-1)*`DWIDTH];
            sigmoid_applied_data_internal[15*`DWIDTH-1:(15-1)*`DWIDTH] <= sigmoid_activation_file_output[15*`DWIDTH-1:(15-1)*`DWIDTH];
            sigmoid_applied_data_internal[16*`DWIDTH-1:(16-1)*`DWIDTH] <= sigmoid_activation_file_output[16*`DWIDTH-1:(16-1)*`DWIDTH];
      end 
      else if (activation_type==1) begin
            tanh_applied_data_internal[1*`DWIDTH-1:(1-1)*`DWIDTH] <= tanh_activation_file_output[1*`DWIDTH-1:(1-1)*`DWIDTH];
            tanh_applied_data_internal[2*`DWIDTH-1:(2-1)*`DWIDTH] <= tanh_activation_file_output[2*`DWIDTH-1:(2-1)*`DWIDTH];
            tanh_applied_data_internal[3*`DWIDTH-1:(3-1)*`DWIDTH] <= tanh_activation_file_output[3*`DWIDTH-1:(3-1)*`DWIDTH];
            tanh_applied_data_internal[4*`DWIDTH-1:(4-1)*`DWIDTH] <= tanh_activation_file_output[4*`DWIDTH-1:(4-1)*`DWIDTH];
            tanh_applied_data_internal[5*`DWIDTH-1:(5-1)*`DWIDTH] <= tanh_activation_file_output[5*`DWIDTH-1:(5-1)*`DWIDTH];
            tanh_applied_data_internal[6*`DWIDTH-1:(6-1)*`DWIDTH] <= tanh_activation_file_output[6*`DWIDTH-1:(6-1)*`DWIDTH];
            tanh_applied_data_internal[7*`DWIDTH-1:(7-1)*`DWIDTH] <= tanh_activation_file_output[7*`DWIDTH-1:(7-1)*`DWIDTH];
            tanh_applied_data_internal[8*`DWIDTH-1:(8-1)*`DWIDTH] <= tanh_activation_file_output[8*`DWIDTH-1:(8-1)*`DWIDTH];
            tanh_applied_data_internal[9*`DWIDTH-1:(9-1)*`DWIDTH] <= tanh_activation_file_output[9*`DWIDTH-1:(9-1)*`DWIDTH];
            tanh_applied_data_internal[10*`DWIDTH-1:(10-1)*`DWIDTH] <= tanh_activation_file_output[10*`DWIDTH-1:(10-1)*`DWIDTH];
            tanh_applied_data_internal[11*`DWIDTH-1:(11-1)*`DWIDTH] <= tanh_activation_file_output[11*`DWIDTH-1:(11-1)*`DWIDTH];
            tanh_applied_data_internal[12*`DWIDTH-1:(12-1)*`DWIDTH] <= tanh_activation_file_output[12*`DWIDTH-1:(12-1)*`DWIDTH];
            tanh_applied_data_internal[13*`DWIDTH-1:(13-1)*`DWIDTH] <= tanh_activation_file_output[13*`DWIDTH-1:(13-1)*`DWIDTH];
            tanh_applied_data_internal[14*`DWIDTH-1:(14-1)*`DWIDTH] <= tanh_activation_file_output[14*`DWIDTH-1:(14-1)*`DWIDTH];
            tanh_applied_data_internal[15*`DWIDTH-1:(15-1)*`DWIDTH] <= tanh_activation_file_output[15*`DWIDTH-1:(15-1)*`DWIDTH];
            tanh_applied_data_internal[16*`DWIDTH-1:(16-1)*`DWIDTH] <= tanh_activation_file_output[16*`DWIDTH-1:(16-1)*`DWIDTH];
      end
      else begin // ReLU
            relu_applied_data_internal[1*`DWIDTH-1:(1-1)*`DWIDTH] <= inp_data[1*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[1*`DWIDTH-1:(1-1)*`DWIDTH];
            relu_applied_data_internal[2*`DWIDTH-1:(2-1)*`DWIDTH] <= inp_data[2*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[2*`DWIDTH-1:(2-1)*`DWIDTH];
            relu_applied_data_internal[3*`DWIDTH-1:(3-1)*`DWIDTH] <= inp_data[3*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[3*`DWIDTH-1:(3-1)*`DWIDTH];
            relu_applied_data_internal[4*`DWIDTH-1:(4-1)*`DWIDTH] <= inp_data[4*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[4*`DWIDTH-1:(4-1)*`DWIDTH];
            relu_applied_data_internal[5*`DWIDTH-1:(5-1)*`DWIDTH] <= inp_data[5*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[5*`DWIDTH-1:(5-1)*`DWIDTH];
            relu_applied_data_internal[6*`DWIDTH-1:(6-1)*`DWIDTH] <= inp_data[6*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[6*`DWIDTH-1:(6-1)*`DWIDTH];
            relu_applied_data_internal[7*`DWIDTH-1:(7-1)*`DWIDTH] <= inp_data[7*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[7*`DWIDTH-1:(7-1)*`DWIDTH];
            relu_applied_data_internal[8*`DWIDTH-1:(8-1)*`DWIDTH] <= inp_data[8*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[8*`DWIDTH-1:(8-1)*`DWIDTH];
            relu_applied_data_internal[9*`DWIDTH-1:(9-1)*`DWIDTH] <= inp_data[9*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[9*`DWIDTH-1:(9-1)*`DWIDTH];
            relu_applied_data_internal[10*`DWIDTH-1:(10-1)*`DWIDTH] <= inp_data[10*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[10*`DWIDTH-1:(10-1)*`DWIDTH];
            relu_applied_data_internal[11*`DWIDTH-1:(11-1)*`DWIDTH] <= inp_data[11*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[11*`DWIDTH-1:(11-1)*`DWIDTH];
            relu_applied_data_internal[12*`DWIDTH-1:(12-1)*`DWIDTH] <= inp_data[12*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[12*`DWIDTH-1:(12-1)*`DWIDTH];
            relu_applied_data_internal[13*`DWIDTH-1:(13-1)*`DWIDTH] <= inp_data[13*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[13*`DWIDTH-1:(13-1)*`DWIDTH];
            relu_applied_data_internal[14*`DWIDTH-1:(14-1)*`DWIDTH] <= inp_data[14*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[14*`DWIDTH-1:(14-1)*`DWIDTH];
            relu_applied_data_internal[15*`DWIDTH-1:(15-1)*`DWIDTH] <= inp_data[15*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[15*`DWIDTH-1:(15-1)*`DWIDTH];
            relu_applied_data_internal[16*`DWIDTH-1:(16-1)*`DWIDTH] <= inp_data[16*`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[16*`DWIDTH-1:(16-1)*`DWIDTH];
      end

      //TANH needs 1 extra cycle
      if (activation_type==1) begin
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
      relu_applied_data_internal  <= 0; 
      done_activation_internal    <= 0;
      out_data_available_internal <= 0;
      cycle_count                 <= 0;
      activation_in_progress      <= 0;
   end
end

assign out_data_internal = (activation_type==2) ? sigmoid_applied_data_internal : 
                           ((activation_type==1) ? tanh_applied_data_internal:
                           relu_applied_data_internal);


genvar j;

wire[`DWIDTH*`NUM_LDPES-1:0] tanh_ina_fake;
wire[`DWIDTH*`NUM_LDPES-1:0] tanh_inb_fake;
wire[`DWIDTH*`NUM_LDPES-1:0] tanh_outa_fake;
wire[10*`NUM_LDPES-1:0] tanh_addr_fake_a;

generate   

   for(j=1;j<=`NUM_LDPES;j=j+1) begin
      tanh_dp_ram tanh_activation_mem (
            .clk(clk),
            .addra(tanh_addr_fake_a[(j*10)-1: (j-1)*10]),
            .ina(tanh_ina_fake[j*`DWIDTH-1:(j-1)*`DWIDTH]),
            .wea(1'b0),
            .outa(tanh_outa_fake[j*`DWIDTH-1:(j-1)*`DWIDTH]),
            .addrb(inp_data[(j*`DWIDTH)-1: (j*`DWIDTH)-10]),
            .inb(tanh_inb_fake[j*`DWIDTH-1:(j-1)*`DWIDTH]),
            .web(1'b0),
            .outb(tanh_activation_file_output[j*`DWIDTH-1:(j-1)*`DWIDTH])
      );
   end
endgenerate

wire[`DWIDTH*`NUM_LDPES-1:0] sigmoid_ina_fake;
wire[`DWIDTH*`NUM_LDPES-1:0] sigmoid_inb_fake;
wire[`DWIDTH*`NUM_LDPES-1:0] sigmoid_outa_fake;
wire[10*`NUM_LDPES-1:0] sigmoid_addr_fake_a;

generate 

   for(j=1;j<=`NUM_LDPES;j=j+1) begin
      sigmoid_dp_ram sigmoid_activation_mem (
            .clk(clk),
            .addra(sigmoid_addr_fake_a[(j*10)-1: (j-1)*10]),
            .ina(sigmoid_ina_fake[j*`DWIDTH-1:(j-1)*`DWIDTH]),
            .wea(1'b0),
            .outa(sigmoid_outa_fake[j*`DWIDTH-1:(j-1)*`DWIDTH]),
            .addrb(inp_data[(j*`DWIDTH)-1: (j*`DWIDTH)-10]),
            .inb(sigmoid_inb_fake[j*`DWIDTH-1:(j-1)*`DWIDTH]),
            .web(1'b0),
            .outb(sigmoid_activation_file_output[j*`DWIDTH-1:(j-1)*`DWIDTH])
      );
   end
endgenerate


endmodule


module elt_wise_add(
    input enable_add,
    input in_data_available,
    input add_or_sub,
    input [`NUM_LDPES*`DWIDTH-1:0] primary_inp,
    input [`NUM_LDPES*`DWIDTH-1:0] secondary_inp,
    output [`NUM_LDPES*`DWIDTH-1:0] out_data,
    output reg output_available_add,
    input clk
);
    wire [(`DWIDTH)-1:0] x_0; 
    wire [(`DWIDTH)-1:0] y_0;
    wire [4:0] flag_fake_0;

    FPAddSub a0(
       .result(out_data[(1*`DWIDTH)-1:(0*`DWIDTH)]),
       .a(x_0),
       .b(y_0), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_0)
    );
    wire [(`DWIDTH)-1:0] x_1; 
    wire [(`DWIDTH)-1:0] y_1;
    wire [4:0] flag_fake_1;

    FPAddSub a1(
       .result(out_data[(2*`DWIDTH)-1:(1*`DWIDTH)]),
       .a(x_1),
       .b(y_1), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_1)
    );
    wire [(`DWIDTH)-1:0] x_2; 
    wire [(`DWIDTH)-1:0] y_2;
    wire [4:0] flag_fake_2;

    FPAddSub a2(
       .result(out_data[(3*`DWIDTH)-1:(2*`DWIDTH)]),
       .a(x_2),
       .b(y_2), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_2)
    );
    wire [(`DWIDTH)-1:0] x_3; 
    wire [(`DWIDTH)-1:0] y_3;
    wire [4:0] flag_fake_3;

    FPAddSub a3(
       .result(out_data[(4*`DWIDTH)-1:(3*`DWIDTH)]),
       .a(x_3),
       .b(y_3), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_3)
    );
    wire [(`DWIDTH)-1:0] x_4; 
    wire [(`DWIDTH)-1:0] y_4;
    wire [4:0] flag_fake_4;

    FPAddSub a4(
       .result(out_data[(5*`DWIDTH)-1:(4*`DWIDTH)]),
       .a(x_4),
       .b(y_4), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_4)
    );
    wire [(`DWIDTH)-1:0] x_5; 
    wire [(`DWIDTH)-1:0] y_5;
    wire [4:0] flag_fake_5;

    FPAddSub a5(
       .result(out_data[(6*`DWIDTH)-1:(5*`DWIDTH)]),
       .a(x_5),
       .b(y_5), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_5)
    );
    wire [(`DWIDTH)-1:0] x_6; 
    wire [(`DWIDTH)-1:0] y_6;
    wire [4:0] flag_fake_6;

    FPAddSub a6(
       .result(out_data[(7*`DWIDTH)-1:(6*`DWIDTH)]),
       .a(x_6),
       .b(y_6), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_6)
    );
    wire [(`DWIDTH)-1:0] x_7; 
    wire [(`DWIDTH)-1:0] y_7;
    wire [4:0] flag_fake_7;

    FPAddSub a7(
       .result(out_data[(8*`DWIDTH)-1:(7*`DWIDTH)]),
       .a(x_7),
       .b(y_7), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_7)
    );
    wire [(`DWIDTH)-1:0] x_8; 
    wire [(`DWIDTH)-1:0] y_8;
    wire [4:0] flag_fake_8;

    FPAddSub a8(
       .result(out_data[(9*`DWIDTH)-1:(8*`DWIDTH)]),
       .a(x_8),
       .b(y_8), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_8)
    );
    wire [(`DWIDTH)-1:0] x_9; 
    wire [(`DWIDTH)-1:0] y_9;
    wire [4:0] flag_fake_9;

    FPAddSub a9(
       .result(out_data[(10*`DWIDTH)-1:(9*`DWIDTH)]),
       .a(x_9),
       .b(y_9), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_9)
    );
    wire [(`DWIDTH)-1:0] x_10; 
    wire [(`DWIDTH)-1:0] y_10;
    wire [4:0] flag_fake_10;

    FPAddSub a10(
       .result(out_data[(11*`DWIDTH)-1:(10*`DWIDTH)]),
       .a(x_10),
       .b(y_10), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_10)
    );
    wire [(`DWIDTH)-1:0] x_11; 
    wire [(`DWIDTH)-1:0] y_11;
    wire [4:0] flag_fake_11;

    FPAddSub a11(
       .result(out_data[(12*`DWIDTH)-1:(11*`DWIDTH)]),
       .a(x_11),
       .b(y_11), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_11)
    );
    wire [(`DWIDTH)-1:0] x_12; 
    wire [(`DWIDTH)-1:0] y_12;
    wire [4:0] flag_fake_12;

    FPAddSub a12(
       .result(out_data[(13*`DWIDTH)-1:(12*`DWIDTH)]),
       .a(x_12),
       .b(y_12), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_12)
    );
    wire [(`DWIDTH)-1:0] x_13; 
    wire [(`DWIDTH)-1:0] y_13;
    wire [4:0] flag_fake_13;

    FPAddSub a13(
       .result(out_data[(14*`DWIDTH)-1:(13*`DWIDTH)]),
       .a(x_13),
       .b(y_13), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_13)
    );
    wire [(`DWIDTH)-1:0] x_14; 
    wire [(`DWIDTH)-1:0] y_14;
    wire [4:0] flag_fake_14;

    FPAddSub a14(
       .result(out_data[(15*`DWIDTH)-1:(14*`DWIDTH)]),
       .a(x_14),
       .b(y_14), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_14)
    );
    wire [(`DWIDTH)-1:0] x_15; 
    wire [(`DWIDTH)-1:0] y_15;
    wire [4:0] flag_fake_15;

    FPAddSub a15(
       .result(out_data[(16*`DWIDTH)-1:(15*`DWIDTH)]),
       .a(x_15),
       .b(y_15), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_15)
    );

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

     reg[`LOG_ADD_LATENCY-1:0] state;
     always @(posedge clk) begin
        if((enable_add==1'b1) && (in_data_available==1'b1)) begin   
            if(state!=`ADD_LATENCY) begin 
                state<=state+1;
            end
            else begin
                output_available_add<=1;
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
    input [`NUM_LDPES*`DWIDTH-1:0] primary_inp,
    input [`NUM_LDPES*`DWIDTH-1:0] secondary_inp,
    output [`NUM_LDPES*`DWIDTH-1:0] out_data,
    output reg output_available_mul,
    input clk
);
    wire [(`DWIDTH)-1:0] x_0; 
    wire [(`DWIDTH)-1:0] y_0;
    wire [4:0] flag_fake_0;

    FPMult_16 m0(
       .result(out_data[(1*`DWIDTH)-1:(0*`DWIDTH)]),
       .a(x_0),
       .b(y_0), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_0)
    );
    wire [(`DWIDTH)-1:0] x_1; 
    wire [(`DWIDTH)-1:0] y_1;
    wire [4:0] flag_fake_1;

    FPMult_16 m1(
       .result(out_data[(2*`DWIDTH)-1:(1*`DWIDTH)]),
       .a(x_1),
       .b(y_1), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_1)
    );
    wire [(`DWIDTH)-1:0] x_2; 
    wire [(`DWIDTH)-1:0] y_2;
    wire [4:0] flag_fake_2;

    FPMult_16 m2(
       .result(out_data[(3*`DWIDTH)-1:(2*`DWIDTH)]),
       .a(x_2),
       .b(y_2), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_2)
    );
    wire [(`DWIDTH)-1:0] x_3; 
    wire [(`DWIDTH)-1:0] y_3;
    wire [4:0] flag_fake_3;

    FPMult_16 m3(
       .result(out_data[(4*`DWIDTH)-1:(3*`DWIDTH)]),
       .a(x_3),
       .b(y_3), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_3)
    );
    wire [(`DWIDTH)-1:0] x_4; 
    wire [(`DWIDTH)-1:0] y_4;
    wire [4:0] flag_fake_4;

    FPMult_16 m4(
       .result(out_data[(5*`DWIDTH)-1:(4*`DWIDTH)]),
       .a(x_4),
       .b(y_4), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_4)
    );
    wire [(`DWIDTH)-1:0] x_5; 
    wire [(`DWIDTH)-1:0] y_5;
    wire [4:0] flag_fake_5;

    FPMult_16 m5(
       .result(out_data[(6*`DWIDTH)-1:(5*`DWIDTH)]),
       .a(x_5),
       .b(y_5), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_5)
    );
    wire [(`DWIDTH)-1:0] x_6; 
    wire [(`DWIDTH)-1:0] y_6;
    wire [4:0] flag_fake_6;

    FPMult_16 m6(
       .result(out_data[(7*`DWIDTH)-1:(6*`DWIDTH)]),
       .a(x_6),
       .b(y_6), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_6)
    );
    wire [(`DWIDTH)-1:0] x_7; 
    wire [(`DWIDTH)-1:0] y_7;
    wire [4:0] flag_fake_7;

    FPMult_16 m7(
       .result(out_data[(8*`DWIDTH)-1:(7*`DWIDTH)]),
       .a(x_7),
       .b(y_7), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_7)
    );
    wire [(`DWIDTH)-1:0] x_8; 
    wire [(`DWIDTH)-1:0] y_8;
    wire [4:0] flag_fake_8;

    FPMult_16 m8(
       .result(out_data[(9*`DWIDTH)-1:(8*`DWIDTH)]),
       .a(x_8),
       .b(y_8), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_8)
    );
    wire [(`DWIDTH)-1:0] x_9; 
    wire [(`DWIDTH)-1:0] y_9;
    wire [4:0] flag_fake_9;

    FPMult_16 m9(
       .result(out_data[(10*`DWIDTH)-1:(9*`DWIDTH)]),
       .a(x_9),
       .b(y_9), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_9)
    );
    wire [(`DWIDTH)-1:0] x_10; 
    wire [(`DWIDTH)-1:0] y_10;
    wire [4:0] flag_fake_10;

    FPMult_16 m10(
       .result(out_data[(11*`DWIDTH)-1:(10*`DWIDTH)]),
       .a(x_10),
       .b(y_10), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_10)
    );
    wire [(`DWIDTH)-1:0] x_11; 
    wire [(`DWIDTH)-1:0] y_11;
    wire [4:0] flag_fake_11;

    FPMult_16 m11(
       .result(out_data[(12*`DWIDTH)-1:(11*`DWIDTH)]),
       .a(x_11),
       .b(y_11), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_11)
    );
    wire [(`DWIDTH)-1:0] x_12; 
    wire [(`DWIDTH)-1:0] y_12;
    wire [4:0] flag_fake_12;

    FPMult_16 m12(
       .result(out_data[(13*`DWIDTH)-1:(12*`DWIDTH)]),
       .a(x_12),
       .b(y_12), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_12)
    );
    wire [(`DWIDTH)-1:0] x_13; 
    wire [(`DWIDTH)-1:0] y_13;
    wire [4:0] flag_fake_13;

    FPMult_16 m13(
       .result(out_data[(14*`DWIDTH)-1:(13*`DWIDTH)]),
       .a(x_13),
       .b(y_13), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_13)
    );
    wire [(`DWIDTH)-1:0] x_14; 
    wire [(`DWIDTH)-1:0] y_14;
    wire [4:0] flag_fake_14;

    FPMult_16 m14(
       .result(out_data[(15*`DWIDTH)-1:(14*`DWIDTH)]),
       .a(x_14),
       .b(y_14), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_14)
    );
    wire [(`DWIDTH)-1:0] x_15; 
    wire [(`DWIDTH)-1:0] y_15;
    wire [4:0] flag_fake_15;

    FPMult_16 m15(
       .result(out_data[(16*`DWIDTH)-1:(15*`DWIDTH)]),
       .a(x_15),
       .b(y_15), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_15)
    );

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


module tanh_dp_ram(
    input clk,
    input [10-1:0] addra, addrb,
    input [16-1:0] ina, inb,
    input wea, web,
    output reg [16-1:0] outa, outb
);

`ifndef hard_mem

reg [16-1:0] ram [((1<<10)-1):0];

`ifdef SIMULATION
initial begin
   $readmemb("/home/tanmay/Koios++ - Copy/Multi_tile_design/tanh_activation_mem.txt" ,ram ,0); 
end
`endif

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

`else

defparam u_dual_port_ram.ADDR_WIDTH = 10; 
defparam u_dual_port_ram.DATA_WIDTH = 16; 

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
endmodule


module sigmoid_dp_ram(
    input clk,
    input [10-1:0] addra, addrb,
    input [16-1:0] ina, inb,
    input wea, web,
    output reg [16-1:0] outa, outb
);

`ifndef hard_mem

reg [16-1:0] ram [((1<<10)-1):0];

`ifdef SIMULATION
initial begin
   $readmemb("/home/tanmay/Koios++ - Copy/Multi_tile_design/sigmoid_activation_mem.txt" ,ram ,0); 
end
`endif

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

`else
defparam u_dual_port_ram.ADDR_WIDTH = 10; 
defparam u_dual_port_ram.DATA_WIDTH = 16; 

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
endmodule

