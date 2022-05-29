////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM mvu.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


`include "includes_gen.v"
`define NUM_TILES 4
`define NUM_REDUCTION_CYCLES 2
`define NUM_MVM_CYCLES 20
`define NUM_NORMALISE_CYCLES 6


module MVU (
    input clk,
    input start,
    input reset,
    input [`VRF_AWIDTH-1:0] vrf_wr_addr,        
    input [`VRF_AWIDTH-1:0] vrf_read_addr,      
    input [`VRF_DWIDTH-1:0] vec,               
     
    input vrf_wr_enable_tile_0,
    input vrf_readn_enable_tile_0, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_0,
    input vrf_wr_enable_tile_1,
    input vrf_readn_enable_tile_1, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_1,
    input vrf_wr_enable_tile_2,
    input vrf_readn_enable_tile_2, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_2,
    input vrf_wr_enable_tile_3,
    input vrf_readn_enable_tile_3, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_3,
    
    input [`MRF_DWIDTH-1:0] mrf_in,                 
    input[`NUM_TILES*`NUM_LDPES-1:0] mrf_we,               
    input [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr,
    
    output [`ORF_DWIDTH-1:0] mvm_result,
    output out_data_available
);

    
    wire start_external_comparator_tree;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_final;

    wire[`NUM_LDPES-1:0] out_data_available_comparator_tile;

    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_0;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_0;
    wire[`NUM_LDPES-1:0] out_data_available_internal_comparator_tree_0;
    
    wire out_data_available_mvm_tile_0;
    
    MVU_tile tile_0(.clk(clk),
    .start(start),
    .reset(reset),
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .max_exp(max_exp_0),
    .vrf_data_out(vrf_data_out_tile_0), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_0), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_0), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .out_data_available_external_comparator_tree(out_data_available_comparator_tile),
    .out_data_available_internal_comparator_tree(out_data_available_internal_comparator_tree_0),
    .out_data_available(out_data_available_mvm_tile_0),
    .mrf_in(mrf_in),
    .mrf_we(mrf_we[1*`NUM_LDPES-1:0*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[1*`NUM_LDPES*`MRF_AWIDTH-1:0*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_0) //WITH TAG
    );
    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_1;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_1;
    wire[`NUM_LDPES-1:0] out_data_available_internal_comparator_tree_1;
    
    wire out_data_available_mvm_tile_1;
    
    MVU_tile tile_1(.clk(clk),
    .start(start),
    .reset(reset),
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .max_exp(max_exp_1),
    .vrf_data_out(vrf_data_out_tile_1), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_1), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_1), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .out_data_available_external_comparator_tree(out_data_available_comparator_tile),
    .out_data_available_internal_comparator_tree(out_data_available_internal_comparator_tree_1),
    .out_data_available(out_data_available_mvm_tile_1),
    .mrf_in(mrf_in),
    .mrf_we(mrf_we[2*`NUM_LDPES-1:1*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[2*`NUM_LDPES*`MRF_AWIDTH-1:1*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_1) //WITH TAG
    );
    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_2;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_2;
    wire[`NUM_LDPES-1:0] out_data_available_internal_comparator_tree_2;
    
    wire out_data_available_mvm_tile_2;
    
    MVU_tile tile_2(.clk(clk),
    .start(start),
    .reset(reset),
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .max_exp(max_exp_2),
    .vrf_data_out(vrf_data_out_tile_2), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_2), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_2), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .out_data_available_external_comparator_tree(out_data_available_comparator_tile),
    .out_data_available_internal_comparator_tree(out_data_available_internal_comparator_tree_2),
    .out_data_available(out_data_available_mvm_tile_2),
    .mrf_in(mrf_in),
    .mrf_we(mrf_we[3*`NUM_LDPES-1:2*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[3*`NUM_LDPES*`MRF_AWIDTH-1:2*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_2) //WITH TAG
    );
    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_3;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_3;
    wire[`NUM_LDPES-1:0] out_data_available_internal_comparator_tree_3;
    
    wire out_data_available_mvm_tile_3;
    
    MVU_tile tile_3(.clk(clk),
    .start(start),
    .reset(reset),
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .max_exp(max_exp_3),
    .vrf_data_out(vrf_data_out_tile_3), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_3), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_3), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .out_data_available_external_comparator_tree(out_data_available_comparator_tile),
    .out_data_available_internal_comparator_tree(out_data_available_internal_comparator_tree_3),
    .out_data_available(out_data_available_mvm_tile_3),
    .mrf_in(mrf_in),
    .mrf_we(mrf_we[4*`NUM_LDPES-1:3*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[4*`NUM_LDPES*`MRF_AWIDTH-1:3*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_3) //WITH TAG
    );



assign start_external_comparator_tree = out_data_available_internal_comparator_tree_0;
        
exponent_comparator_tree_tile exp_cmp (
    .clk(clk),
    .reset(reset),
    .start(start_external_comparator_tree),
    .out_data_available(out_data_available_comparator_tile),
    .inp0(max_exp_0),
    .inp1(max_exp_1),
    .inp2(max_exp_2),
    .inp3(max_exp_3),
    .result_final_stage(max_exp_final)
);

   
wire[`NUM_LDPES*`LDPE_USED_OUTPUT_WIDTH-1:0] reduction_unit_output;
wire[`NUM_LDPES-1:0] out_data_available_reduction;

wire start_reduction_tree;
assign start_reduction_tree = out_data_available_mvm_tile_0;


mvm_reduction_unit mvm_reduction (
    .clk(clk),
    .reset_reduction_mvm(reset),
    .start(start_reduction_tree),
    .out_data_available(out_data_available_reduction),
    .inp0(result_mvm_0),
    .inp1(result_mvm_1),
    .inp2(result_mvm_2),
    .inp3(result_mvm_3),
    .result_mvm_final_stage(reduction_unit_output)
);

wire[`BFLOAT_DWIDTH*`NUM_LDPES-1:0] msfp11_out;
wire[`NUM_LDPES-1:0] out_data_available_msfp_gen;

genvar i;
generate
    for(i=1;i<=`NUM_LDPES;i=i+1) begin
        msfp_generator msfp_gen(
            .clk(clk),
            .exponent(max_exp_final[i*`BFLOAT_EXP-1:(i-1)*`BFLOAT_EXP]),
            .mantisa(reduction_unit_output[i*`LDPE_USED_OUTPUT_WIDTH-1:(i-1)*`LDPE_USED_OUTPUT_WIDTH]),
            .reset(reset),
            .start(out_data_available_reduction[i-1]),
            .out_data_available(out_data_available_msfp_gen[i-1]),
            .msfp11(msfp11_out[i*`BFLOAT_DWIDTH-1:(i-1)*`BFLOAT_DWIDTH])
        );
    end
endgenerate

wire[`NUM_LDPES-1:0] out_data_available_msfp11_to_fp16_converter;
wire [`FLOAT_DWIDTH*`NUM_LDPES-1:0] msfp_fp_converter_output;

generate
    for(i=1;i<=`NUM_LDPES;i=i+1) begin
        msfp11_to_fp16  msfp_to_fp_converter(
            .clk(clk),
            .reset(reset),
            .start(out_data_available_msfp_gen[i-1]),
            .out_data_available(out_data_available_msfp11_to_fp16_converter[i-1]),
            .a(msfp11_out[i*`BFLOAT_DWIDTH-1:(i-1)*`BFLOAT_DWIDTH]),
            .b(msfp_fp_converter_output[i*`FLOAT_DWIDTH-1:(i-1)*`FLOAT_DWIDTH])
        );
    end
endgenerate

assign mvm_result = msfp_fp_converter_output;
assign out_data_available = out_data_available_msfp11_to_fp16_converter[0];

endmodule

module msfp_generator(
    input[`BFLOAT_EXP-1:0] exponent,
    input[`LDPE_USED_OUTPUT_WIDTH-1:0] mantisa,
    input clk,
    input reset,
    input start,
    output reg out_data_available,
    output reg[`BFLOAT_DWIDTH-1:0] msfp11 
);

    wire sign, is_valid;
    wire[2:0] position;
    wire[`LDPE_USED_OUTPUT_WIDTH-1:0] mantisa_sign_adjusted;
    

    assign sign = mantisa[`LDPE_USED_OUTPUT_WIDTH-1];

    assign mantisa_sign_adjusted = (sign) ? (-mantisa) : mantisa;
    wire out_data_available_lzd;

    leading_zero_detector_6bit ldetector(
        .reset(reset),
        .start(start),
        .clk(clk),
        .a(mantisa_sign_adjusted[`BFLOAT_MANTISA_WITH_LO-1:0]),
        .is_valid(is_valid),
        .position(position),
        .out_data_available(out_data_available_lzd)
    );
    


    wire[4:0] normalize_amt;
    assign normalize_amt = (is_valid) ? position : 0;

    wire[`BFLOAT_MANTISA_WITH_LO-1:0] significand_to_be_normalised;
    assign significand_to_be_normalised = (is_valid) ? mantisa_sign_adjusted[`BFLOAT_MANTISA_WITH_LO-1:0] : 0;
    
    wire out_data_available_barrel_shifter_left;

    wire[`BFLOAT_MANTISA_WITH_LO-1:0] mantisa_shifted;
    barrel_shifter_left bshift_left(
        .clk(clk),
        .reset(reset),
        .start(out_data_available_lzd),
        .out_data_available(out_data_available_barrel_shifter_left),
        .shift_amt(normalize_amt),
        .significand(significand_to_be_normalised),
        .shifted_sig(mantisa_shifted)
    );
    wire[`BFLOAT_EXP-1:0] normalized_exponent;

    assign normalized_exponent = {1'b0,exponent} - {1'b0,normalize_amt};

    always@(posedge clk) begin
        if((reset==1) || (start==0)) begin
            msfp11 <= 'bX;
            out_data_available <= 0;
        end
        else begin
            out_data_available <= out_data_available_barrel_shifter_left;
            msfp11 <= {sign, normalized_exponent, mantisa_shifted[`BFLOAT_MANTISA-1:0]};
        end
    end

endmodule

module MVU_tile (
    input clk,
    input start,
    input reset,
    input vrf_wr_enable,
    input [`VRF_AWIDTH-1:0] vrf_wr_addr,
    input [`VRF_AWIDTH-1:0] vrf_read_addr,
    input [`VRF_DWIDTH-1:0] vec,
    output[`VRF_DWIDTH-1:0] vrf_data_out,
    input [`MRF_DWIDTH-1:0] mrf_in,
    input vrf_readn_enable,
    input[`NUM_LDPES-1:0] mrf_we,
    input [`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr,
    input [`NUM_LDPES-1:0] out_data_available_external_comparator_tree,
    output [`NUM_LDPES-1:0] out_data_available_internal_comparator_tree,
    output reg out_data_available,
    output [`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp,
    output [`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result
);

    wire [`VRF_DWIDTH-1:0] ina_fake;
   
  
    wire [`VRF_DWIDTH-1:0] vrf_outa_wire;

    reg [4:0] num_cycles_mvm;

     always@(posedge clk) begin
        if((reset==1'b1) || (start==1'b0)) begin
            num_cycles_mvm<=0;
            out_data_available<=0;
        end
        else begin
            if(num_cycles_mvm==`NUM_MVM_CYCLES-1) begin
                out_data_available<=1;
            end
            else begin
                num_cycles_mvm <= num_cycles_mvm + 1;
            end
        end
    end

    // Port A is used to feed LDPE and port B to load vector from DRAM.
  
    VRF vrf (
        .clk(clk),
        .addra(vrf_read_addr),
        .ina(ina_fake),
        .wea(vrf_readn_enable),
        .outa(vrf_outa_wire),
        .addrb(vrf_wr_addr),
        .inb(vec),
        .web(vrf_wr_enable),
        .outb(vrf_data_out) 
    );

    genvar i;
    generate
        for (i=1; i<=`NUM_LDPES; i=i+1) begin
            compute_unit unit (
                .clk(clk),
                .reset(reset),
                .start(start),
                .vec(vrf_outa_wire),
                .mrf_in(mrf_in),
                .mrf_we(mrf_we[i-1]),
                .mrf_addr(mrf_addr[i*`MRF_AWIDTH-1:(i-1)*`MRF_AWIDTH]),
                .max_exp(max_exp[i*`BFLOAT_EXP-1:(i-1)*`BFLOAT_EXP]),
                .out_data_available_external_comparator_tree(out_data_available_external_comparator_tree[i-1]),
                .out_data_available_internal_comparator_tree(out_data_available_internal_comparator_tree[i-1]),
                .result(result[i*`LDPE_USED_OUTPUT_WIDTH-1:(i-1)*`LDPE_USED_OUTPUT_WIDTH])
            );
        end
    endgenerate

endmodule

module compute_unit (
    input clk,
    input start,
    input reset,
    input [`VRF_DWIDTH-1:0] vec,
    input [`MRF_DWIDTH-1:0] mrf_in,
    input mrf_we,
    input [`MRF_AWIDTH-1:0] mrf_addr,
    input out_data_available_external_comparator_tree,
    output out_data_available_internal_comparator_tree,
    output [`LDPE_USED_OUTPUT_WIDTH-1:0] result,
    output [`BFLOAT_EXP-1:0] max_exp
);

    // Port A of BRAMs is used for feed DSPs and Port B is used to load matrix from off-chip memory

  
    wire [`MRF_DWIDTH-1:0] mrf_outa_wire;

    wire [`LDPE_USED_INPUT_WIDTH-1:0] ax_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] ay_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] bx_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] by_wire;

    // Wire connecting LDPE output to Output BRAM input
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] ldpe_result;
    
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] inb_fake_wire;
    
    wire [`OUT_DWIDTH-1:0] orf_fake_wire;

    // First 4 BRAM outputs are given to ax of 4 DSPs and next 4 BRAM outputs are given to bx of DSPs

    // Connection MRF and LDPE wires for matrix data
    // 'X' pin is used for matrix
    /* If there are 4 DSPSs, bit[31:0] of mrf output contain ax values for the 4 DSPs, bit[63:32] contain bx values and so on. With a group of ax values, bit[7:0] contain ax value for DSP1, bit[15:8] contain ax value for DSP2 and so on. */
    assign ax_wire = mrf_outa_wire[1*`LDPE_USED_INPUT_WIDTH-1:0*`LDPE_USED_INPUT_WIDTH];
    assign bx_wire = mrf_outa_wire[2*`LDPE_USED_INPUT_WIDTH-1:1*`LDPE_USED_INPUT_WIDTH];

    // Connection of VRF and LDPE wires for vector data
    // 'Y' pin is used for vector
    assign ay_wire = vec[`LDPE_USED_INPUT_WIDTH-1:0];
    assign by_wire = vec[2*`LDPE_USED_INPUT_WIDTH-1:1*`LDPE_USED_INPUT_WIDTH];

    MRF mrf (
        .clk(clk),
        .addr(mrf_addr),
        .in(mrf_in),
        .we(mrf_we),
        .out(mrf_outa_wire)
    );
    
    LDPE ldpe (
        .clk(clk),
        .reset(reset),
        .start(start),
        .ax(ax_wire),
        .ay(ay_wire),
        .bx(bx_wire),
        .by(by_wire),
        .out_data_available_external_comparator_tree(out_data_available_external_comparator_tree),
        .out_data_available_internal_comparator_tree(out_data_available_internal_comparator_tree),
        .ldpe_result(ldpe_result),
        .max_exp(max_exp)
    );
    assign result = ldpe_result;
    
endmodule

module LDPE (
    input clk,
    input reset,
    input start,
    input [`LDPE_USED_INPUT_WIDTH-1:0] ax,
    input [`LDPE_USED_INPUT_WIDTH-1:0] ay,
    input [`LDPE_USED_INPUT_WIDTH-1:0] bx,
    input [`LDPE_USED_INPUT_WIDTH-1:0] by,
    input out_data_available_external_comparator_tree,
    output [`LDPE_USED_OUTPUT_WIDTH-1:0]  ldpe_result,
    output out_data_available_internal_comparator_tree,
    output [`BFLOAT_EXP-1:0] max_exp
);
    

    wire[`BFLOAT_DWIDTH*`DSPS_PER_LDPE-1:0] ax_in_sub_ldpe;
    wire[`BFLOAT_DWIDTH*`DSPS_PER_LDPE-1:0] ay_in_sub_ldpe;
    wire[`BFLOAT_DWIDTH*`DSPS_PER_LDPE-1:0] bx_in_sub_ldpe;
    wire[`BFLOAT_DWIDTH*`DSPS_PER_LDPE-1:0] by_in_sub_ldpe;
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0]  sub_ldpe_result;
    wire[`DSPS_PER_LDPE-1:0] out_data_available_ax;

    genvar i;
    generate
        for (i=1; i<=`DSPS_PER_LDPE; i=i+1) begin
            fp16_to_msfp11 fp_converter_ax(.rst(reset),.start(start),.a(ax[i*`FLOAT_DWIDTH-1:(i-1)*`FLOAT_DWIDTH]),.b(ax_in_sub_ldpe[i*`BFLOAT_DWIDTH-1:(i-1)*`BFLOAT_DWIDTH]),.out_data_available(out_data_available_ax[i-1]),.clk(clk));
        end
    endgenerate

    wire[`DSPS_PER_LDPE-1:0] out_data_available_ay;

    generate
        for (i=1; i<=`DSPS_PER_LDPE; i=i+1) begin
            fp16_to_msfp11 fp_converter_ay(.rst(reset),.start(start),.a(ay[i*`FLOAT_DWIDTH-1:(i-1)*`FLOAT_DWIDTH]),.b(ay_in_sub_ldpe[i*`BFLOAT_DWIDTH-1:(i-1)*`BFLOAT_DWIDTH]),.out_data_available(out_data_available_ay[i-1]),.clk(clk));
        end
    endgenerate

    wire[`DSPS_PER_LDPE-1:0] out_data_available_bx;

    generate
        for (i=1; i<=`DSPS_PER_LDPE; i=i+1) begin
            fp16_to_msfp11 fp_converter_bx(.rst(reset),.start(start),.a(bx[i*`FLOAT_DWIDTH-1:(i-1)*`FLOAT_DWIDTH]),.b(bx_in_sub_ldpe[i*`BFLOAT_DWIDTH-1:(i-1)*`BFLOAT_DWIDTH]),.out_data_available(out_data_available_bx[i-1]),.clk(clk));
        end
    endgenerate

    wire[`DSPS_PER_LDPE-1:0] out_data_available_by;

    generate
        for (i=1; i<=`DSPS_PER_LDPE; i=i+1) begin
            fp16_to_msfp11 fp_converter_by(.rst(reset),.start(start),.a(by[i*`FLOAT_DWIDTH-1:(i-1)*`FLOAT_DWIDTH]),.b(by_in_sub_ldpe[i*`BFLOAT_DWIDTH-1:(i-1)*`BFLOAT_DWIDTH]),.out_data_available(out_data_available_by[i-1]),.clk(clk));
        end
    endgenerate
    wire start_subldpe; 
    assign start_subldpe = out_data_available_ax[0];

    SUB_LDPE sub_1(
        .clk(clk),
        .reset(reset),
        .start(start_subldpe),
        .ax(ax_in_sub_ldpe[1*`SUB_LDPE_USED_INPUT_WIDTH-1:(1-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .ay(ay_in_sub_ldpe[1*`SUB_LDPE_USED_INPUT_WIDTH-1:(1-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .bx(bx_in_sub_ldpe[1*`SUB_LDPE_USED_INPUT_WIDTH-1:(1-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .by(by_in_sub_ldpe[1*`SUB_LDPE_USED_INPUT_WIDTH-1:(1-1)*`SUB_LDPE_USED_INPUT_WIDTH]),
        .out_data_available_external_comparator_tree(out_data_available_external_comparator_tree),
        .out_data_available_internal_comparator_tree(out_data_available_internal_comparator_tree),
        .result(sub_ldpe_result[1*`DSP_USED_OUTPUT_WIDTH-1:(1-1)*`DSP_USED_OUTPUT_WIDTH]),
        .max_exp(max_exp)
    );


    assign ldpe_result = (start==1'b0) ? 'bX : sub_ldpe_result[(0+1)*`DSP_USED_OUTPUT_WIDTH-1:0*`DSP_USED_OUTPUT_WIDTH];


endmodule

module myadder #(
    parameter INPUT_WIDTH = `DSP_USED_INPUT_WIDTH,
    parameter OUTPUT_WIDTH = `DSP_USED_OUTPUT_WIDTH
)
(
    input [INPUT_WIDTH-1:0] a,
    input [INPUT_WIDTH-1:0] b,
    input reset,
    input clk,
    output reg [OUTPUT_WIDTH-1:0] sum
);

    always@(posedge clk) begin
        if(reset) begin
            sum <= 0;
        end
        else begin
            sum <= {a[INPUT_WIDTH-1],a}+{b[INPUT_WIDTH-1],b};
        end
    end

endmodule


module SUB_LDPE (
    input clk,
    input reset,
    input start,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] ax,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] ay,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] bx,
    input [`SUB_LDPE_USED_INPUT_WIDTH-1:0] by,
    input out_data_available_external_comparator_tree,
    output reg [`LDPE_USED_OUTPUT_WIDTH-1:0] result,
    output out_data_available_internal_comparator_tree,
    output [`BFLOAT_EXP-1:0] max_exp
);

    wire [`DSP_USED_OUTPUT_WIDTH*`DSPS_PER_SUB_LDPE-1:0] chainin, chainout, dsp_result;
    
    wire [36:0] chainout_temp_0;
    assign chainout_temp_0 = 37'b0;

    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_1;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_1;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_1;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_1;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_1_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_1_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_1_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_1_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_1_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_1_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_1_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_1_mantisa_shifted;

    assign ax_wire_1_num = ax[1*`BFLOAT_DWIDTH-1:(1-1)*`BFLOAT_DWIDTH];
    assign ay_wire_1_num = ay[1*`BFLOAT_DWIDTH-1:(1-1)*`BFLOAT_DWIDTH];
    assign bx_wire_1_num = bx[1*`BFLOAT_DWIDTH-1:(1-1)*`BFLOAT_DWIDTH];
    assign by_wire_1_num = by[1*`BFLOAT_DWIDTH-1:(1-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_1_ax;
    assign shift_amt_1_ax = max_exp - ax_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_1;
    wire start_barrel_shifter_ax_1;

    assign start_barrel_shifter_ax_1 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_1(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_1),
        .out_data_available(out_data_available_barrel_shifter_ax_1),
        .shift_amt(shift_amt_1_ax),
        .significand({1'b1,ax_wire_1_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_1_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_1_ay;
    assign shift_amt_1_ay = max_exp - ay_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_1;
    wire start_barrel_shifter_ay_1;

    assign start_barrel_shifter_ay_1 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_1(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_1),
        .out_data_available(out_data_available_barrel_shifter_ay_1),
        .shift_amt(shift_amt_1_ay),
        .significand({1'b1,ay_wire_1_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_1_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_1_bx;
    assign shift_amt_1_bx = max_exp - bx_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_1;
    wire start_barrel_shifter_bx_1;

    assign start_barrel_shifter_bx_1 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_1(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_1),
        .out_data_available(out_data_available_barrel_shifter_bx_1),
        .shift_amt(shift_amt_1_bx),
        .significand({1'b1,bx_wire_1_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_1_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_1_by;
    assign shift_amt_1_by = max_exp - by_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_1;
    wire start_barrel_shifter_by_1;

    assign start_barrel_shifter_by_1 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_1(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_1),
        .out_data_available(out_data_available_barrel_shifter_by_1),
        .shift_amt(shift_amt_1_by),
        .significand({1'b1,by_wire_1_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_1_mantisa_shifted)
    );

    assign ax_wire_1 = (ax_wire_1_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_1_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_1_mantisa_shifted};
    assign ay_wire_1 = (ay_wire_1_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_1_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_1_mantisa_shifted};
    assign bx_wire_1 = (bx_wire_1_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_1_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_1_mantisa_shifted};
    assign by_wire_1 = (by_wire_1_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_1_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_1_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_1;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_1;

    assign dsp_result[1*`DSP_USED_OUTPUT_WIDTH-1:(1-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_1[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_1;
    assign reset_dsp_1 = ~out_data_available_barrel_shifter_ax_1;

    dsp_block_18_18_int_sop_2 dsp_1 (
        .clk(clk),
        .aclr(reset_dsp_1),
        .ax(ax_wire_1),
        .ay(ay_wire_1),
        .bx(bx_wire_1),
        .by(by_wire_1),
        .chainin(chainout_temp_0),
        .chainout(chainout_temp_1),
        .result(result_temp_1)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_2;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_2;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_2;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_2;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_2_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_2_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_2_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_2_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_2_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_2_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_2_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_2_mantisa_shifted;

    assign ax_wire_2_num = ax[2*`BFLOAT_DWIDTH-1:(2-1)*`BFLOAT_DWIDTH];
    assign ay_wire_2_num = ay[2*`BFLOAT_DWIDTH-1:(2-1)*`BFLOAT_DWIDTH];
    assign bx_wire_2_num = bx[2*`BFLOAT_DWIDTH-1:(2-1)*`BFLOAT_DWIDTH];
    assign by_wire_2_num = by[2*`BFLOAT_DWIDTH-1:(2-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_2_ax;
    assign shift_amt_2_ax = max_exp - ax_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_2;
    wire start_barrel_shifter_ax_2;

    assign start_barrel_shifter_ax_2 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_2(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_2),
        .out_data_available(out_data_available_barrel_shifter_ax_2),
        .shift_amt(shift_amt_2_ax),
        .significand({1'b1,ax_wire_2_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_2_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_2_ay;
    assign shift_amt_2_ay = max_exp - ay_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_2;
    wire start_barrel_shifter_ay_2;

    assign start_barrel_shifter_ay_2 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_2(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_2),
        .out_data_available(out_data_available_barrel_shifter_ay_2),
        .shift_amt(shift_amt_2_ay),
        .significand({1'b1,ay_wire_2_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_2_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_2_bx;
    assign shift_amt_2_bx = max_exp - bx_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_2;
    wire start_barrel_shifter_bx_2;

    assign start_barrel_shifter_bx_2 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_2(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_2),
        .out_data_available(out_data_available_barrel_shifter_bx_2),
        .shift_amt(shift_amt_2_bx),
        .significand({1'b1,bx_wire_2_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_2_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_2_by;
    assign shift_amt_2_by = max_exp - by_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_2;
    wire start_barrel_shifter_by_2;

    assign start_barrel_shifter_by_2 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_2(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_2),
        .out_data_available(out_data_available_barrel_shifter_by_2),
        .shift_amt(shift_amt_2_by),
        .significand({1'b1,by_wire_2_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_2_mantisa_shifted)
    );

    assign ax_wire_2 = (ax_wire_2_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_2_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_2_mantisa_shifted};
    assign ay_wire_2 = (ay_wire_2_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_2_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_2_mantisa_shifted};
    assign bx_wire_2 = (bx_wire_2_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_2_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_2_mantisa_shifted};
    assign by_wire_2 = (by_wire_2_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_2_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_2_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_2;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_2;

    assign dsp_result[2*`DSP_USED_OUTPUT_WIDTH-1:(2-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_2[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_2;
    assign reset_dsp_2 = ~out_data_available_barrel_shifter_ax_2;

    dsp_block_18_18_int_sop_2 dsp_2 (
        .clk(clk),
        .aclr(reset_dsp_2),
        .ax(ax_wire_2),
        .ay(ay_wire_2),
        .bx(bx_wire_2),
        .by(by_wire_2),
        .chainin(chainout_temp_1),
        .chainout(chainout_temp_2),
        .result(result_temp_2)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_3;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_3;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_3;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_3;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_3_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_3_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_3_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_3_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_3_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_3_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_3_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_3_mantisa_shifted;

    assign ax_wire_3_num = ax[3*`BFLOAT_DWIDTH-1:(3-1)*`BFLOAT_DWIDTH];
    assign ay_wire_3_num = ay[3*`BFLOAT_DWIDTH-1:(3-1)*`BFLOAT_DWIDTH];
    assign bx_wire_3_num = bx[3*`BFLOAT_DWIDTH-1:(3-1)*`BFLOAT_DWIDTH];
    assign by_wire_3_num = by[3*`BFLOAT_DWIDTH-1:(3-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_3_ax;
    assign shift_amt_3_ax = max_exp - ax_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_3;
    wire start_barrel_shifter_ax_3;

    assign start_barrel_shifter_ax_3 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_3(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_3),
        .out_data_available(out_data_available_barrel_shifter_ax_3),
        .shift_amt(shift_amt_3_ax),
        .significand({1'b1,ax_wire_3_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_3_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_3_ay;
    assign shift_amt_3_ay = max_exp - ay_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_3;
    wire start_barrel_shifter_ay_3;

    assign start_barrel_shifter_ay_3 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_3(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_3),
        .out_data_available(out_data_available_barrel_shifter_ay_3),
        .shift_amt(shift_amt_3_ay),
        .significand({1'b1,ay_wire_3_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_3_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_3_bx;
    assign shift_amt_3_bx = max_exp - bx_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_3;
    wire start_barrel_shifter_bx_3;

    assign start_barrel_shifter_bx_3 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_3(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_3),
        .out_data_available(out_data_available_barrel_shifter_bx_3),
        .shift_amt(shift_amt_3_bx),
        .significand({1'b1,bx_wire_3_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_3_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_3_by;
    assign shift_amt_3_by = max_exp - by_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_3;
    wire start_barrel_shifter_by_3;

    assign start_barrel_shifter_by_3 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_3(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_3),
        .out_data_available(out_data_available_barrel_shifter_by_3),
        .shift_amt(shift_amt_3_by),
        .significand({1'b1,by_wire_3_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_3_mantisa_shifted)
    );

    assign ax_wire_3 = (ax_wire_3_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_3_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_3_mantisa_shifted};
    assign ay_wire_3 = (ay_wire_3_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_3_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_3_mantisa_shifted};
    assign bx_wire_3 = (bx_wire_3_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_3_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_3_mantisa_shifted};
    assign by_wire_3 = (by_wire_3_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_3_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_3_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_3;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_3;

    assign dsp_result[3*`DSP_USED_OUTPUT_WIDTH-1:(3-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_3[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_3;
    assign reset_dsp_3 = ~out_data_available_barrel_shifter_ax_3;

    dsp_block_18_18_int_sop_2 dsp_3 (
        .clk(clk),
        .aclr(reset_dsp_3),
        .ax(ax_wire_3),
        .ay(ay_wire_3),
        .bx(bx_wire_3),
        .by(by_wire_3),
        .chainin(chainout_temp_2),
        .chainout(chainout_temp_3),
        .result(result_temp_3)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_4;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_4;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_4;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_4;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_4_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_4_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_4_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_4_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_4_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_4_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_4_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_4_mantisa_shifted;

    assign ax_wire_4_num = ax[4*`BFLOAT_DWIDTH-1:(4-1)*`BFLOAT_DWIDTH];
    assign ay_wire_4_num = ay[4*`BFLOAT_DWIDTH-1:(4-1)*`BFLOAT_DWIDTH];
    assign bx_wire_4_num = bx[4*`BFLOAT_DWIDTH-1:(4-1)*`BFLOAT_DWIDTH];
    assign by_wire_4_num = by[4*`BFLOAT_DWIDTH-1:(4-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_4_ax;
    assign shift_amt_4_ax = max_exp - ax_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_4;
    wire start_barrel_shifter_ax_4;

    assign start_barrel_shifter_ax_4 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_4(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_4),
        .out_data_available(out_data_available_barrel_shifter_ax_4),
        .shift_amt(shift_amt_4_ax),
        .significand({1'b1,ax_wire_4_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_4_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_4_ay;
    assign shift_amt_4_ay = max_exp - ay_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_4;
    wire start_barrel_shifter_ay_4;

    assign start_barrel_shifter_ay_4 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_4(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_4),
        .out_data_available(out_data_available_barrel_shifter_ay_4),
        .shift_amt(shift_amt_4_ay),
        .significand({1'b1,ay_wire_4_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_4_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_4_bx;
    assign shift_amt_4_bx = max_exp - bx_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_4;
    wire start_barrel_shifter_bx_4;

    assign start_barrel_shifter_bx_4 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_4(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_4),
        .out_data_available(out_data_available_barrel_shifter_bx_4),
        .shift_amt(shift_amt_4_bx),
        .significand({1'b1,bx_wire_4_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_4_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_4_by;
    assign shift_amt_4_by = max_exp - by_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_4;
    wire start_barrel_shifter_by_4;

    assign start_barrel_shifter_by_4 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_4(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_4),
        .out_data_available(out_data_available_barrel_shifter_by_4),
        .shift_amt(shift_amt_4_by),
        .significand({1'b1,by_wire_4_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_4_mantisa_shifted)
    );

    assign ax_wire_4 = (ax_wire_4_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_4_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_4_mantisa_shifted};
    assign ay_wire_4 = (ay_wire_4_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_4_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_4_mantisa_shifted};
    assign bx_wire_4 = (bx_wire_4_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_4_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_4_mantisa_shifted};
    assign by_wire_4 = (by_wire_4_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_4_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_4_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_4;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_4;

    assign dsp_result[4*`DSP_USED_OUTPUT_WIDTH-1:(4-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_4[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_4;
    assign reset_dsp_4 = ~out_data_available_barrel_shifter_ax_4;

    dsp_block_18_18_int_sop_2 dsp_4 (
        .clk(clk),
        .aclr(reset_dsp_4),
        .ax(ax_wire_4),
        .ay(ay_wire_4),
        .bx(bx_wire_4),
        .by(by_wire_4),
        .chainin(chainout_temp_3),
        .chainout(chainout_temp_4),
        .result(result_temp_4)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_5;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_5;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_5;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_5;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_5_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_5_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_5_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_5_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_5_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_5_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_5_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_5_mantisa_shifted;

    assign ax_wire_5_num = ax[5*`BFLOAT_DWIDTH-1:(5-1)*`BFLOAT_DWIDTH];
    assign ay_wire_5_num = ay[5*`BFLOAT_DWIDTH-1:(5-1)*`BFLOAT_DWIDTH];
    assign bx_wire_5_num = bx[5*`BFLOAT_DWIDTH-1:(5-1)*`BFLOAT_DWIDTH];
    assign by_wire_5_num = by[5*`BFLOAT_DWIDTH-1:(5-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_5_ax;
    assign shift_amt_5_ax = max_exp - ax_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_5;
    wire start_barrel_shifter_ax_5;

    assign start_barrel_shifter_ax_5 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_5(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_5),
        .out_data_available(out_data_available_barrel_shifter_ax_5),
        .shift_amt(shift_amt_5_ax),
        .significand({1'b1,ax_wire_5_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_5_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_5_ay;
    assign shift_amt_5_ay = max_exp - ay_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_5;
    wire start_barrel_shifter_ay_5;

    assign start_barrel_shifter_ay_5 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_5(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_5),
        .out_data_available(out_data_available_barrel_shifter_ay_5),
        .shift_amt(shift_amt_5_ay),
        .significand({1'b1,ay_wire_5_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_5_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_5_bx;
    assign shift_amt_5_bx = max_exp - bx_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_5;
    wire start_barrel_shifter_bx_5;

    assign start_barrel_shifter_bx_5 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_5(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_5),
        .out_data_available(out_data_available_barrel_shifter_bx_5),
        .shift_amt(shift_amt_5_bx),
        .significand({1'b1,bx_wire_5_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_5_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_5_by;
    assign shift_amt_5_by = max_exp - by_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_5;
    wire start_barrel_shifter_by_5;

    assign start_barrel_shifter_by_5 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_5(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_5),
        .out_data_available(out_data_available_barrel_shifter_by_5),
        .shift_amt(shift_amt_5_by),
        .significand({1'b1,by_wire_5_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_5_mantisa_shifted)
    );

    assign ax_wire_5 = (ax_wire_5_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_5_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_5_mantisa_shifted};
    assign ay_wire_5 = (ay_wire_5_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_5_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_5_mantisa_shifted};
    assign bx_wire_5 = (bx_wire_5_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_5_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_5_mantisa_shifted};
    assign by_wire_5 = (by_wire_5_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_5_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_5_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_5;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_5;

    assign dsp_result[5*`DSP_USED_OUTPUT_WIDTH-1:(5-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_5[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_5;
    assign reset_dsp_5 = ~out_data_available_barrel_shifter_ax_5;

    dsp_block_18_18_int_sop_2 dsp_5 (
        .clk(clk),
        .aclr(reset_dsp_5),
        .ax(ax_wire_5),
        .ay(ay_wire_5),
        .bx(bx_wire_5),
        .by(by_wire_5),
        .chainin(chainout_temp_4),
        .chainout(chainout_temp_5),
        .result(result_temp_5)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_6;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_6;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_6;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_6;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_6_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_6_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_6_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_6_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_6_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_6_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_6_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_6_mantisa_shifted;

    assign ax_wire_6_num = ax[6*`BFLOAT_DWIDTH-1:(6-1)*`BFLOAT_DWIDTH];
    assign ay_wire_6_num = ay[6*`BFLOAT_DWIDTH-1:(6-1)*`BFLOAT_DWIDTH];
    assign bx_wire_6_num = bx[6*`BFLOAT_DWIDTH-1:(6-1)*`BFLOAT_DWIDTH];
    assign by_wire_6_num = by[6*`BFLOAT_DWIDTH-1:(6-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_6_ax;
    assign shift_amt_6_ax = max_exp - ax_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_6;
    wire start_barrel_shifter_ax_6;

    assign start_barrel_shifter_ax_6 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_6(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_6),
        .out_data_available(out_data_available_barrel_shifter_ax_6),
        .shift_amt(shift_amt_6_ax),
        .significand({1'b1,ax_wire_6_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_6_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_6_ay;
    assign shift_amt_6_ay = max_exp - ay_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_6;
    wire start_barrel_shifter_ay_6;

    assign start_barrel_shifter_ay_6 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_6(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_6),
        .out_data_available(out_data_available_barrel_shifter_ay_6),
        .shift_amt(shift_amt_6_ay),
        .significand({1'b1,ay_wire_6_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_6_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_6_bx;
    assign shift_amt_6_bx = max_exp - bx_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_6;
    wire start_barrel_shifter_bx_6;

    assign start_barrel_shifter_bx_6 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_6(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_6),
        .out_data_available(out_data_available_barrel_shifter_bx_6),
        .shift_amt(shift_amt_6_bx),
        .significand({1'b1,bx_wire_6_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_6_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_6_by;
    assign shift_amt_6_by = max_exp - by_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_6;
    wire start_barrel_shifter_by_6;

    assign start_barrel_shifter_by_6 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_6(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_6),
        .out_data_available(out_data_available_barrel_shifter_by_6),
        .shift_amt(shift_amt_6_by),
        .significand({1'b1,by_wire_6_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_6_mantisa_shifted)
    );

    assign ax_wire_6 = (ax_wire_6_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_6_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_6_mantisa_shifted};
    assign ay_wire_6 = (ay_wire_6_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_6_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_6_mantisa_shifted};
    assign bx_wire_6 = (bx_wire_6_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_6_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_6_mantisa_shifted};
    assign by_wire_6 = (by_wire_6_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_6_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_6_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_6;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_6;

    assign dsp_result[6*`DSP_USED_OUTPUT_WIDTH-1:(6-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_6[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_6;
    assign reset_dsp_6 = ~out_data_available_barrel_shifter_ax_6;

    dsp_block_18_18_int_sop_2 dsp_6 (
        .clk(clk),
        .aclr(reset_dsp_6),
        .ax(ax_wire_6),
        .ay(ay_wire_6),
        .bx(bx_wire_6),
        .by(by_wire_6),
        .chainin(chainout_temp_5),
        .chainout(chainout_temp_6),
        .result(result_temp_6)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_7;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_7;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_7;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_7;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_7_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_7_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_7_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_7_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_7_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_7_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_7_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_7_mantisa_shifted;

    assign ax_wire_7_num = ax[7*`BFLOAT_DWIDTH-1:(7-1)*`BFLOAT_DWIDTH];
    assign ay_wire_7_num = ay[7*`BFLOAT_DWIDTH-1:(7-1)*`BFLOAT_DWIDTH];
    assign bx_wire_7_num = bx[7*`BFLOAT_DWIDTH-1:(7-1)*`BFLOAT_DWIDTH];
    assign by_wire_7_num = by[7*`BFLOAT_DWIDTH-1:(7-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_7_ax;
    assign shift_amt_7_ax = max_exp - ax_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_7;
    wire start_barrel_shifter_ax_7;

    assign start_barrel_shifter_ax_7 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_7(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_7),
        .out_data_available(out_data_available_barrel_shifter_ax_7),
        .shift_amt(shift_amt_7_ax),
        .significand({1'b1,ax_wire_7_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_7_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_7_ay;
    assign shift_amt_7_ay = max_exp - ay_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_7;
    wire start_barrel_shifter_ay_7;

    assign start_barrel_shifter_ay_7 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_7(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_7),
        .out_data_available(out_data_available_barrel_shifter_ay_7),
        .shift_amt(shift_amt_7_ay),
        .significand({1'b1,ay_wire_7_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_7_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_7_bx;
    assign shift_amt_7_bx = max_exp - bx_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_7;
    wire start_barrel_shifter_bx_7;

    assign start_barrel_shifter_bx_7 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_7(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_7),
        .out_data_available(out_data_available_barrel_shifter_bx_7),
        .shift_amt(shift_amt_7_bx),
        .significand({1'b1,bx_wire_7_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_7_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_7_by;
    assign shift_amt_7_by = max_exp - by_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_7;
    wire start_barrel_shifter_by_7;

    assign start_barrel_shifter_by_7 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_7(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_7),
        .out_data_available(out_data_available_barrel_shifter_by_7),
        .shift_amt(shift_amt_7_by),
        .significand({1'b1,by_wire_7_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_7_mantisa_shifted)
    );

    assign ax_wire_7 = (ax_wire_7_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_7_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_7_mantisa_shifted};
    assign ay_wire_7 = (ay_wire_7_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_7_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_7_mantisa_shifted};
    assign bx_wire_7 = (bx_wire_7_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_7_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_7_mantisa_shifted};
    assign by_wire_7 = (by_wire_7_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_7_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_7_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_7;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_7;

    assign dsp_result[7*`DSP_USED_OUTPUT_WIDTH-1:(7-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_7[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_7;
    assign reset_dsp_7 = ~out_data_available_barrel_shifter_ax_7;

    dsp_block_18_18_int_sop_2 dsp_7 (
        .clk(clk),
        .aclr(reset_dsp_7),
        .ax(ax_wire_7),
        .ay(ay_wire_7),
        .bx(bx_wire_7),
        .by(by_wire_7),
        .chainin(chainout_temp_6),
        .chainout(chainout_temp_7),
        .result(result_temp_7)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_8;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_8;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_8;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_8;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_8_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_8_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_8_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_8_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_8_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_8_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_8_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_8_mantisa_shifted;

    assign ax_wire_8_num = ax[8*`BFLOAT_DWIDTH-1:(8-1)*`BFLOAT_DWIDTH];
    assign ay_wire_8_num = ay[8*`BFLOAT_DWIDTH-1:(8-1)*`BFLOAT_DWIDTH];
    assign bx_wire_8_num = bx[8*`BFLOAT_DWIDTH-1:(8-1)*`BFLOAT_DWIDTH];
    assign by_wire_8_num = by[8*`BFLOAT_DWIDTH-1:(8-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_8_ax;
    assign shift_amt_8_ax = max_exp - ax_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_8;
    wire start_barrel_shifter_ax_8;

    assign start_barrel_shifter_ax_8 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_8(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_8),
        .out_data_available(out_data_available_barrel_shifter_ax_8),
        .shift_amt(shift_amt_8_ax),
        .significand({1'b1,ax_wire_8_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_8_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_8_ay;
    assign shift_amt_8_ay = max_exp - ay_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_8;
    wire start_barrel_shifter_ay_8;

    assign start_barrel_shifter_ay_8 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_8(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_8),
        .out_data_available(out_data_available_barrel_shifter_ay_8),
        .shift_amt(shift_amt_8_ay),
        .significand({1'b1,ay_wire_8_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_8_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_8_bx;
    assign shift_amt_8_bx = max_exp - bx_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_8;
    wire start_barrel_shifter_bx_8;

    assign start_barrel_shifter_bx_8 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_8(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_8),
        .out_data_available(out_data_available_barrel_shifter_bx_8),
        .shift_amt(shift_amt_8_bx),
        .significand({1'b1,bx_wire_8_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_8_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_8_by;
    assign shift_amt_8_by = max_exp - by_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_8;
    wire start_barrel_shifter_by_8;

    assign start_barrel_shifter_by_8 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_8(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_8),
        .out_data_available(out_data_available_barrel_shifter_by_8),
        .shift_amt(shift_amt_8_by),
        .significand({1'b1,by_wire_8_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_8_mantisa_shifted)
    );

    assign ax_wire_8 = (ax_wire_8_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_8_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_8_mantisa_shifted};
    assign ay_wire_8 = (ay_wire_8_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_8_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_8_mantisa_shifted};
    assign bx_wire_8 = (bx_wire_8_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_8_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_8_mantisa_shifted};
    assign by_wire_8 = (by_wire_8_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_8_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_8_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_8;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_8;

    assign dsp_result[8*`DSP_USED_OUTPUT_WIDTH-1:(8-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_8[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_8;
    assign reset_dsp_8 = ~out_data_available_barrel_shifter_ax_8;

    dsp_block_18_18_int_sop_2 dsp_8 (
        .clk(clk),
        .aclr(reset_dsp_8),
        .ax(ax_wire_8),
        .ay(ay_wire_8),
        .bx(bx_wire_8),
        .by(by_wire_8),
        .chainin(chainout_temp_7),
        .chainout(chainout_temp_8),
        .result(result_temp_8)
    );


exponent_comparator_tree_ldpe exp_cmp (
        .clk(clk),
        .reset(reset),
        .start(start),
        .out_data_available(out_data_available_internal_comparator_tree),
        .inp0(ax_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp1(ax_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp2(ax_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp3(ax_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp4(ax_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp5(ax_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp6(ax_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp7(ax_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp8(ay_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp9(ay_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp10(ay_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp11(ay_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp12(ay_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp13(ay_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp14(ay_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp15(ay_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp16(bx_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp17(bx_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp18(bx_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp19(bx_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp20(bx_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp21(bx_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp22(bx_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp23(bx_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp24(by_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp25(by_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp26(by_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp27(by_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp28(by_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp29(by_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp30(by_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp31(by_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .result_final_stage(max_exp)
);


    always @(*) begin
        if (reset==1'b1 || start==1'b0) begin
            result <= {`LDPE_USED_OUTPUT_WIDTH{1'd0}};
        end
        else begin
            result <= dsp_result[`DSPS_PER_SUB_LDPE*`LDPE_USED_OUTPUT_WIDTH-1:(`DSPS_PER_SUB_LDPE-1)*`LDPE_USED_OUTPUT_WIDTH];
        end
    end

endmodule

module VRF #(parameter VRF_AWIDTH = `VRF_AWIDTH, parameter VRF_DWIDTH = `VRF_DWIDTH) (
    input clk,
    input [VRF_AWIDTH-1:0] addra, addrb,
    input [VRF_DWIDTH-1:0] ina, inb,
    input wea, web,
    output [VRF_DWIDTH-1:0] outa, outb
);

    dp_ram # (
        .AWIDTH(VRF_AWIDTH),
        .DWIDTH(VRF_DWIDTH)
    ) vec_mem (
        .clk(clk),
        .addra(addra),
        .ina(ina),
        .wea(wea),
        .outa(outa),
        .addrb(addrb),
        .inb(inb),
        .web(web),
        .outb(outb)
    );
endmodule

module MRF (
    input clk,
    input [`MRF_AWIDTH-1:0] addr,
    input [`MRF_DWIDTH-1:0] in,
    input we,
    output [`MRF_DWIDTH-1:0] out
);

    sp_ram # (
        .AWIDTH(`MRF_AWIDTH),
        .DWIDTH(`MRF_DWIDTH)
    ) mat_mem (
        .clk(clk),
        .addr(addr),
        .in(in),
        .we(we),
        .out(out)
    );
endmodule

module dsp_block_18_18_int_sop_2 (
    input clk,
    input aclr,
    input [`DSP_X_AVA_INPUT_WIDTH-1:0] ax,
    input [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay,
    input [`DSP_X_AVA_INPUT_WIDTH-1:0] bx,
    input [`DSP_Y_AVA_INPUT_WIDTH-1:0] by,
    input [`DSP_AVA_OUTPUT_WIDTH-1:0] chainin,
    output [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout,
    output [`DSP_AVA_OUTPUT_WIDTH-1:0] result
);

`ifdef SIMULATION

reg [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_reg;
reg [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_reg;
reg [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_reg;
reg [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_reg;
reg [`DSP_AVA_OUTPUT_WIDTH-1:0] result_reg;

always @(posedge clk) begin
    if(aclr) begin
        result_reg <= 0;
        ax_reg <= 0;
        ay_reg <= 0;
        bx_reg <= 0;
        by_reg <= 0;
    end
    else begin
        ax_reg <= ax;
        ay_reg <= ay;
        bx_reg <= bx;
        by_reg <= by;
        result_reg <= (ax_reg * ay_reg) + (bx_reg * by_reg) + chainin;
    end
end
assign chainout = result_reg;
assign result = result_reg;

`else

wire [11:0] mode;
assign mode = 12'b0101_0101_0011;

int_sop_2 mac_component (
    .mode_sigs(mode),
    .clk(clk),
    .reset(aclr),
    .ax(ax),
    .ay(ay),
    .bx(bx),
    .by(by),
    .chainin(chainin),
    .result(result),
    .chainout(chainout)
);

`endif

endmodule

//////////////////////////////////
// Dual port RAM
//////////////////////////////////

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

`ifdef SIMULATION

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

`else

defparam u_dual_port_ram.ADDR_WIDTH = AWIDTH; 
defparam u_dual_port_ram.DATA_WIDTH = DWIDTH; 

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

//////////////////////////////////
// Single port RAM
//////////////////////////////////

module sp_ram # (
    parameter AWIDTH = 9,
    parameter DWIDTH = 32
) (
    input clk,
    input [AWIDTH-1:0] addr,
    input [DWIDTH-1:0] in,
    input we,
    output reg [DWIDTH-1:0] out
);

`ifdef SIMULATION

reg [DWIDTH-1:0] ram [((1<<AWIDTH)-1):0];

always @(posedge clk)  begin

    if (we) begin
        ram[addr] <= in;
    end

    out <= ram[addr];
end

`else

defparam u_single_port_ram.ADDR_WIDTH = AWIDTH; 
defparam u_single_port_ram.DATA_WIDTH = DWIDTH; 

single_port_ram u_single_port_ram(
.addr(addr),
.we(we),
.data(in),
.out(out),
.clk(clk)
);

`endif
endmodule


module mvm_reduction_unit(
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp0,
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp1,
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp2,
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp3,
    output reg[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_final_stage,
    output reg[`NUM_LDPES-1:0] out_data_available,
    //CONTROL SIGNALS
    input clk,
    input start,
    input reset_reduction_mvm
);
    wire[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] reduction_output_final;
    reg[3:0] num_cycles_reduction;

    always@(posedge clk) begin
        if((reset_reduction_mvm==1'b1) || (start==1'b0)) begin
            num_cycles_reduction<=0;
            out_data_available<=0;
        end
        else begin
            if(num_cycles_reduction==`NUM_REDUCTION_CYCLES-1) begin
                out_data_available <= {`NUM_LDPES{1'b1}};
            end
            else begin
                num_cycles_reduction <= num_cycles_reduction + 1;
            end
        end
    end

    always @(*) begin
        if ((reset_reduction_mvm==1'b1) || (start==1'b0)) begin
          result_mvm_final_stage <= 'bX;
        end
        else begin
           result_mvm_final_stage <= reduction_output_final;
        end
     end

    genvar i;

    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_0_stage_1;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_initial_0 (
              .a(inp0[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .b(inp1[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .clk(clk),
              .reset(reset_reduction_mvm),
              .sum(reduction_output_0_stage_1[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH])
            );
        end
    endgenerate
    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_1_stage_1;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_initial_1 (
              .a(inp2[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .b(inp3[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .clk(clk),
              .reset(reset_reduction_mvm),
              .sum(reduction_output_1_stage_1[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH])
            );
        end
    endgenerate

    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_0_stage_2;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_0_stage_1 (
              .a(reduction_output_0_stage_1[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)]),
              .b(reduction_output_1_stage_1[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)]),
              .clk(clk),
              .reset(reset_reduction_mvm),
              .sum(reduction_output_0_stage_2[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)])
            );
        end
    endgenerate

assign reduction_output_final[1*`DSP_USED_OUTPUT_WIDTH-1:0*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[1*(`DSP_USED_OUTPUT_WIDTH)-1:0*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[2*`DSP_USED_OUTPUT_WIDTH-1:1*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[2*(`DSP_USED_OUTPUT_WIDTH)-1:1*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[3*`DSP_USED_OUTPUT_WIDTH-1:2*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[3*(`DSP_USED_OUTPUT_WIDTH)-1:2*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[4*`DSP_USED_OUTPUT_WIDTH-1:3*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[4*(`DSP_USED_OUTPUT_WIDTH)-1:3*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[5*`DSP_USED_OUTPUT_WIDTH-1:4*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[5*(`DSP_USED_OUTPUT_WIDTH)-1:4*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[6*`DSP_USED_OUTPUT_WIDTH-1:5*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[6*(`DSP_USED_OUTPUT_WIDTH)-1:5*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[7*`DSP_USED_OUTPUT_WIDTH-1:6*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[7*(`DSP_USED_OUTPUT_WIDTH)-1:6*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[8*`DSP_USED_OUTPUT_WIDTH-1:7*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[8*(`DSP_USED_OUTPUT_WIDTH)-1:7*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[9*`DSP_USED_OUTPUT_WIDTH-1:8*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[9*(`DSP_USED_OUTPUT_WIDTH)-1:8*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[10*`DSP_USED_OUTPUT_WIDTH-1:9*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[10*(`DSP_USED_OUTPUT_WIDTH)-1:9*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[11*`DSP_USED_OUTPUT_WIDTH-1:10*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[11*(`DSP_USED_OUTPUT_WIDTH)-1:10*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[12*`DSP_USED_OUTPUT_WIDTH-1:11*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[12*(`DSP_USED_OUTPUT_WIDTH)-1:11*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[13*`DSP_USED_OUTPUT_WIDTH-1:12*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[13*(`DSP_USED_OUTPUT_WIDTH)-1:12*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[14*`DSP_USED_OUTPUT_WIDTH-1:13*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[14*(`DSP_USED_OUTPUT_WIDTH)-1:13*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[15*`DSP_USED_OUTPUT_WIDTH-1:14*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[15*(`DSP_USED_OUTPUT_WIDTH)-1:14*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[16*`DSP_USED_OUTPUT_WIDTH-1:15*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[16*(`DSP_USED_OUTPUT_WIDTH)-1:15*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[17*`DSP_USED_OUTPUT_WIDTH-1:16*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[17*(`DSP_USED_OUTPUT_WIDTH)-1:16*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[18*`DSP_USED_OUTPUT_WIDTH-1:17*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[18*(`DSP_USED_OUTPUT_WIDTH)-1:17*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[19*`DSP_USED_OUTPUT_WIDTH-1:18*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[19*(`DSP_USED_OUTPUT_WIDTH)-1:18*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[20*`DSP_USED_OUTPUT_WIDTH-1:19*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[20*(`DSP_USED_OUTPUT_WIDTH)-1:19*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[21*`DSP_USED_OUTPUT_WIDTH-1:20*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[21*(`DSP_USED_OUTPUT_WIDTH)-1:20*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[22*`DSP_USED_OUTPUT_WIDTH-1:21*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[22*(`DSP_USED_OUTPUT_WIDTH)-1:21*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[23*`DSP_USED_OUTPUT_WIDTH-1:22*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[23*(`DSP_USED_OUTPUT_WIDTH)-1:22*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[24*`DSP_USED_OUTPUT_WIDTH-1:23*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[24*(`DSP_USED_OUTPUT_WIDTH)-1:23*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[25*`DSP_USED_OUTPUT_WIDTH-1:24*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[25*(`DSP_USED_OUTPUT_WIDTH)-1:24*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[26*`DSP_USED_OUTPUT_WIDTH-1:25*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[26*(`DSP_USED_OUTPUT_WIDTH)-1:25*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[27*`DSP_USED_OUTPUT_WIDTH-1:26*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[27*(`DSP_USED_OUTPUT_WIDTH)-1:26*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[28*`DSP_USED_OUTPUT_WIDTH-1:27*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[28*(`DSP_USED_OUTPUT_WIDTH)-1:27*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[29*`DSP_USED_OUTPUT_WIDTH-1:28*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[29*(`DSP_USED_OUTPUT_WIDTH)-1:28*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[30*`DSP_USED_OUTPUT_WIDTH-1:29*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[30*(`DSP_USED_OUTPUT_WIDTH)-1:29*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[31*`DSP_USED_OUTPUT_WIDTH-1:30*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[31*(`DSP_USED_OUTPUT_WIDTH)-1:30*(`DSP_USED_OUTPUT_WIDTH)];
assign reduction_output_final[32*`DSP_USED_OUTPUT_WIDTH-1:31*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[32*(`DSP_USED_OUTPUT_WIDTH)-1:31*(`DSP_USED_OUTPUT_WIDTH)];
endmodule
