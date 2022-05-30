////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM mfu.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


//`include "includes_gen.v"
//`include "floating_pt_gen.v"


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

reg  done_activation_internal;
reg  out_data_available_internal;
wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data_internal;
reg [`DESIGN_SIZE*`DWIDTH-1:0] relu_applied_data_internal;

integer i;
integer cycle_count;
reg activation_in_progress;

reg [(`DESIGN_SIZE*`DWIDTH)-1:0] sigmoid_applied_data_internal;
reg [(`DESIGN_SIZE*`DWIDTH)-1:0] tanh_applied_data_internal;


wire [(`DESIGN_SIZE*`DWIDTH)-1:0] sigmoid_activation_file_output;
wire [(`DESIGN_SIZE*`DWIDTH)-1:0] tanh_activation_file_output;

//reg [(`DESIGN_SIZE*`DWIDTH)-1:0] data_slope;
//reg [(`DESIGN_SIZE*`DWIDTH)-1:0] data_intercept;
//reg [(`DESIGN_SIZE*`DWIDTH)-1:0] data_intercept_delayed;

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
      cycle_count = cycle_count + 1;

      for (i = 0; i < `DESIGN_SIZE; i=i+1) begin
         if(activation_type==2) begin // tanH
            sigmoid_applied_data_internal[i*`DWIDTH +:`DWIDTH] <= sigmoid_activation_file_output[i*`DWIDTH +:`DWIDTH];
         end 
         else if (activation_type==1) begin
            tanh_applied_data_internal[i*`DWIDTH +:`DWIDTH] <= tanh_activation_file_output[i*`DWIDTH +:`DWIDTH];
         end
         else begin // ReLU
            relu_applied_data_internal[i*`DWIDTH +:`DWIDTH] <= inp_data[i*`DWIDTH+`DWIDTH-1] ? {`DWIDTH{1'b0}} : inp_data[i*`DWIDTH +:`DWIDTH];
         end
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
      relu_applied_data_internal      <= 0; 
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
    wire [(`DWIDTH)-1:0] x_16; 
    wire [(`DWIDTH)-1:0] y_16;
    wire [4:0] flag_fake_16;

    FPAddSub a16(
       .result(out_data[(17*`DWIDTH)-1:(16*`DWIDTH)]),
       .a(x_16),
       .b(y_16), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_16)
    );
    wire [(`DWIDTH)-1:0] x_17; 
    wire [(`DWIDTH)-1:0] y_17;
    wire [4:0] flag_fake_17;

    FPAddSub a17(
       .result(out_data[(18*`DWIDTH)-1:(17*`DWIDTH)]),
       .a(x_17),
       .b(y_17), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_17)
    );
    wire [(`DWIDTH)-1:0] x_18; 
    wire [(`DWIDTH)-1:0] y_18;
    wire [4:0] flag_fake_18;

    FPAddSub a18(
       .result(out_data[(19*`DWIDTH)-1:(18*`DWIDTH)]),
       .a(x_18),
       .b(y_18), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_18)
    );
    wire [(`DWIDTH)-1:0] x_19; 
    wire [(`DWIDTH)-1:0] y_19;
    wire [4:0] flag_fake_19;

    FPAddSub a19(
       .result(out_data[(20*`DWIDTH)-1:(19*`DWIDTH)]),
       .a(x_19),
       .b(y_19), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_19)
    );
    wire [(`DWIDTH)-1:0] x_20; 
    wire [(`DWIDTH)-1:0] y_20;
    wire [4:0] flag_fake_20;

    FPAddSub a20(
       .result(out_data[(21*`DWIDTH)-1:(20*`DWIDTH)]),
       .a(x_20),
       .b(y_20), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_20)
    );
    wire [(`DWIDTH)-1:0] x_21; 
    wire [(`DWIDTH)-1:0] y_21;
    wire [4:0] flag_fake_21;

    FPAddSub a21(
       .result(out_data[(22*`DWIDTH)-1:(21*`DWIDTH)]),
       .a(x_21),
       .b(y_21), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_21)
    );
    wire [(`DWIDTH)-1:0] x_22; 
    wire [(`DWIDTH)-1:0] y_22;
    wire [4:0] flag_fake_22;

    FPAddSub a22(
       .result(out_data[(23*`DWIDTH)-1:(22*`DWIDTH)]),
       .a(x_22),
       .b(y_22), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_22)
    );
    wire [(`DWIDTH)-1:0] x_23; 
    wire [(`DWIDTH)-1:0] y_23;
    wire [4:0] flag_fake_23;

    FPAddSub a23(
       .result(out_data[(24*`DWIDTH)-1:(23*`DWIDTH)]),
       .a(x_23),
       .b(y_23), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_23)
    );
    wire [(`DWIDTH)-1:0] x_24; 
    wire [(`DWIDTH)-1:0] y_24;
    wire [4:0] flag_fake_24;

    FPAddSub a24(
       .result(out_data[(25*`DWIDTH)-1:(24*`DWIDTH)]),
       .a(x_24),
       .b(y_24), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_24)
    );
    wire [(`DWIDTH)-1:0] x_25; 
    wire [(`DWIDTH)-1:0] y_25;
    wire [4:0] flag_fake_25;

    FPAddSub a25(
       .result(out_data[(26*`DWIDTH)-1:(25*`DWIDTH)]),
       .a(x_25),
       .b(y_25), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_25)
    );
    wire [(`DWIDTH)-1:0] x_26; 
    wire [(`DWIDTH)-1:0] y_26;
    wire [4:0] flag_fake_26;

    FPAddSub a26(
       .result(out_data[(27*`DWIDTH)-1:(26*`DWIDTH)]),
       .a(x_26),
       .b(y_26), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_26)
    );
    wire [(`DWIDTH)-1:0] x_27; 
    wire [(`DWIDTH)-1:0] y_27;
    wire [4:0] flag_fake_27;

    FPAddSub a27(
       .result(out_data[(28*`DWIDTH)-1:(27*`DWIDTH)]),
       .a(x_27),
       .b(y_27), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_27)
    );
    wire [(`DWIDTH)-1:0] x_28; 
    wire [(`DWIDTH)-1:0] y_28;
    wire [4:0] flag_fake_28;

    FPAddSub a28(
       .result(out_data[(29*`DWIDTH)-1:(28*`DWIDTH)]),
       .a(x_28),
       .b(y_28), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_28)
    );
    wire [(`DWIDTH)-1:0] x_29; 
    wire [(`DWIDTH)-1:0] y_29;
    wire [4:0] flag_fake_29;

    FPAddSub a29(
       .result(out_data[(30*`DWIDTH)-1:(29*`DWIDTH)]),
       .a(x_29),
       .b(y_29), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_29)
    );
    wire [(`DWIDTH)-1:0] x_30; 
    wire [(`DWIDTH)-1:0] y_30;
    wire [4:0] flag_fake_30;

    FPAddSub a30(
       .result(out_data[(31*`DWIDTH)-1:(30*`DWIDTH)]),
       .a(x_30),
       .b(y_30), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_30)
    );
    wire [(`DWIDTH)-1:0] x_31; 
    wire [(`DWIDTH)-1:0] y_31;
    wire [4:0] flag_fake_31;

    FPAddSub a31(
       .result(out_data[(32*`DWIDTH)-1:(31*`DWIDTH)]),
       .a(x_31),
       .b(y_31), 
       .clk(clk), 
       .rst(~enable_add), 
       .operation(add_or_sub), 
       .flags(flag_fake_31)
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
    wire [(`DWIDTH)-1:0] x_16; 
    wire [(`DWIDTH)-1:0] y_16;
    wire [4:0] flag_fake_16;

    FPMult_16 m16(
       .result(out_data[(17*`DWIDTH)-1:(16*`DWIDTH)]),
       .a(x_16),
       .b(y_16), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_16)
    );
    wire [(`DWIDTH)-1:0] x_17; 
    wire [(`DWIDTH)-1:0] y_17;
    wire [4:0] flag_fake_17;

    FPMult_16 m17(
       .result(out_data[(18*`DWIDTH)-1:(17*`DWIDTH)]),
       .a(x_17),
       .b(y_17), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_17)
    );
    wire [(`DWIDTH)-1:0] x_18; 
    wire [(`DWIDTH)-1:0] y_18;
    wire [4:0] flag_fake_18;

    FPMult_16 m18(
       .result(out_data[(19*`DWIDTH)-1:(18*`DWIDTH)]),
       .a(x_18),
       .b(y_18), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_18)
    );
    wire [(`DWIDTH)-1:0] x_19; 
    wire [(`DWIDTH)-1:0] y_19;
    wire [4:0] flag_fake_19;

    FPMult_16 m19(
       .result(out_data[(20*`DWIDTH)-1:(19*`DWIDTH)]),
       .a(x_19),
       .b(y_19), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_19)
    );
    wire [(`DWIDTH)-1:0] x_20; 
    wire [(`DWIDTH)-1:0] y_20;
    wire [4:0] flag_fake_20;

    FPMult_16 m20(
       .result(out_data[(21*`DWIDTH)-1:(20*`DWIDTH)]),
       .a(x_20),
       .b(y_20), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_20)
    );
    wire [(`DWIDTH)-1:0] x_21; 
    wire [(`DWIDTH)-1:0] y_21;
    wire [4:0] flag_fake_21;

    FPMult_16 m21(
       .result(out_data[(22*`DWIDTH)-1:(21*`DWIDTH)]),
       .a(x_21),
       .b(y_21), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_21)
    );
    wire [(`DWIDTH)-1:0] x_22; 
    wire [(`DWIDTH)-1:0] y_22;
    wire [4:0] flag_fake_22;

    FPMult_16 m22(
       .result(out_data[(23*`DWIDTH)-1:(22*`DWIDTH)]),
       .a(x_22),
       .b(y_22), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_22)
    );
    wire [(`DWIDTH)-1:0] x_23; 
    wire [(`DWIDTH)-1:0] y_23;
    wire [4:0] flag_fake_23;

    FPMult_16 m23(
       .result(out_data[(24*`DWIDTH)-1:(23*`DWIDTH)]),
       .a(x_23),
       .b(y_23), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_23)
    );
    wire [(`DWIDTH)-1:0] x_24; 
    wire [(`DWIDTH)-1:0] y_24;
    wire [4:0] flag_fake_24;

    FPMult_16 m24(
       .result(out_data[(25*`DWIDTH)-1:(24*`DWIDTH)]),
       .a(x_24),
       .b(y_24), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_24)
    );
    wire [(`DWIDTH)-1:0] x_25; 
    wire [(`DWIDTH)-1:0] y_25;
    wire [4:0] flag_fake_25;

    FPMult_16 m25(
       .result(out_data[(26*`DWIDTH)-1:(25*`DWIDTH)]),
       .a(x_25),
       .b(y_25), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_25)
    );
    wire [(`DWIDTH)-1:0] x_26; 
    wire [(`DWIDTH)-1:0] y_26;
    wire [4:0] flag_fake_26;

    FPMult_16 m26(
       .result(out_data[(27*`DWIDTH)-1:(26*`DWIDTH)]),
       .a(x_26),
       .b(y_26), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_26)
    );
    wire [(`DWIDTH)-1:0] x_27; 
    wire [(`DWIDTH)-1:0] y_27;
    wire [4:0] flag_fake_27;

    FPMult_16 m27(
       .result(out_data[(28*`DWIDTH)-1:(27*`DWIDTH)]),
       .a(x_27),
       .b(y_27), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_27)
    );
    wire [(`DWIDTH)-1:0] x_28; 
    wire [(`DWIDTH)-1:0] y_28;
    wire [4:0] flag_fake_28;

    FPMult_16 m28(
       .result(out_data[(29*`DWIDTH)-1:(28*`DWIDTH)]),
       .a(x_28),
       .b(y_28), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_28)
    );
    wire [(`DWIDTH)-1:0] x_29; 
    wire [(`DWIDTH)-1:0] y_29;
    wire [4:0] flag_fake_29;

    FPMult_16 m29(
       .result(out_data[(30*`DWIDTH)-1:(29*`DWIDTH)]),
       .a(x_29),
       .b(y_29), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_29)
    );
    wire [(`DWIDTH)-1:0] x_30; 
    wire [(`DWIDTH)-1:0] y_30;
    wire [4:0] flag_fake_30;

    FPMult_16 m30(
       .result(out_data[(31*`DWIDTH)-1:(30*`DWIDTH)]),
       .a(x_30),
       .b(y_30), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_30)
    );
    wire [(`DWIDTH)-1:0] x_31; 
    wire [(`DWIDTH)-1:0] y_31;
    wire [4:0] flag_fake_31;

    FPMult_16 m31(
       .result(out_data[(32*`DWIDTH)-1:(31*`DWIDTH)]),
       .a(x_31),
       .b(y_31), 
       .clk(clk), 
       .rst(~enable_mul), 
       .flags(flag_fake_31)
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


module tanh_dp_ram(
    input clk,
    input [10-1:0] addra, addrb,
    input [16-1:0] ina, inb,
    input wea, web,
    output reg [16-1:0] outa, outb
);

`ifdef SIMULATION

reg [16-1:0] ram [((1<<10)-1):0];

initial begin
   $readmemb("/home/tanmay/Koios++ - Copy/Multi_tile_design/tanh_activation_mem.txt" ,ram ,0); 
end

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

`ifdef SIMULATION

reg [16-1:0] ram [((1<<10)-1):0];

initial begin
   $readmemb("/home/tanmay/Koios++ - Copy/Multi_tile_design/sigmoid_activation_mem.txt" ,ram ,0); 
end

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

