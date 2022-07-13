<%!
    import math

    num_tiles = 4
    num_ldpes = 16
    num_dsp_per_ldpe = 16
    num_reduction_stages = int(math.log2(num_tiles))
%>

//`include "includes_gen.v"

module MVU (
    input clk,
    input[`NUM_LDPES-1:0] start,
    input[`NUM_LDPES-1:0] reset,
    input [`VRF_AWIDTH-1:0] vrf_wr_addr,        
    input [`VRF_AWIDTH-1:0] vrf_read_addr,      
    input [`VRF_DWIDTH-1:0] vec,               
     
% for i in range(num_tiles):
    input vrf_wr_enable_tile_${i},
    input vrf_readn_enable_tile_${i}, 
    output[`VRF_DWIDTH-1:0] vrf_data_out_tile_${i},
% endfor
    
    input [`MRF_DWIDTH*`NUM_LDPES*`NUM_TILES-1:0] mrf_in,                 
    input[`NUM_TILES*`NUM_LDPES-1:0] mrf_we,               
    input [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr,

    input[`NUM_TILES*`NUM_LDPES-1:0] mrf_we_for_dram,
    input [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_for_dram,
    output [`NUM_TILES*`MRF_DWIDTH*`NUM_LDPES-1:0] mrf_outa_to_dram,
    
    output [`ORF_DWIDTH-1:0] mvm_result,
    output out_data_available
);

    
    wire[`NUM_LDPES-1:0] start_external_comparator_tree;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_final;

    wire[`NUM_LDPES-1:0] out_data_available_comparator_tile;

% for i in range(num_tiles):
    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_${i};
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_${i};
    wire[`NUM_LDPES-1:0] out_data_available_internal_comparator_tree_${i};
    
    wire[`NUM_LDPES-1:0] out_data_available_mvm_tile_${i};
    
    MVU_tile tile_${i}(.clk(clk),
    .start(start),
    .reset(reset),
    .vrf_wr_addr(vrf_wr_addr),
    .vec(vec),
    .max_exp(max_exp_${i}),
    .vrf_data_out(vrf_data_out_tile_${i}), //WITH TAG
    .vrf_wr_enable(vrf_wr_enable_tile_${i}), //WITH TAG
    .vrf_readn_enable(vrf_readn_enable_tile_${i}), //WITH TAG
    .vrf_read_addr(vrf_read_addr),
    .out_data_available_external_comparator_tree(out_data_available_comparator_tile),
    .out_data_available_internal_comparator_tree(out_data_available_internal_comparator_tree_${i}),
    .out_data_available(out_data_available_mvm_tile_${i}),
    .mrf_in(mrf_in[${i+1}*`MRF_DWIDTH*`NUM_LDPES-1:${i}*`MRF_DWIDTH*`NUM_LDPES]),
    .mrf_we(mrf_we[${i+1}*`NUM_LDPES-1:${i}*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[${i+1}*`NUM_LDPES*`MRF_AWIDTH-1:${i}*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_addr_for_dram(mrf_addr_for_dram[${i+1}*`NUM_LDPES*`MRF_AWIDTH-1:${i}*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_outa_to_dram(mrf_outa_to_dram[${i+1}*`NUM_LDPES*`MRF_DWIDTH-1:${i}*`NUM_LDPES*`MRF_DWIDTH]),
    .mrf_we_for_dram(mrf_we_for_dram[${i+1}*`NUM_LDPES-1:${i}*`NUM_LDPES]),
    .result(result_mvm_${i}) //WITH TAG
    );
%endfor   



assign start_external_comparator_tree = out_data_available_internal_comparator_tree_0;
        
exponent_comparator_tree_tile exp_cmp (
    .clk(clk),
    .reset(reset),
    .start(start_external_comparator_tree),
    .out_data_available(out_data_available_comparator_tile),
% for i in range(num_tiles):
    .inp${i}(max_exp_${i}),
% endfor
    .result_final_stage(max_exp_final)
);

   
wire[`NUM_LDPES*`LDPE_USED_OUTPUT_WIDTH-1:0] reduction_unit_output;
wire[`NUM_LDPES-1:0] out_data_available_reduction;

wire[`NUM_LDPES-1:0] start_reduction_tree;
assign start_reduction_tree = out_data_available_mvm_tile_0;


mvm_reduction_unit mvm_reduction (
    .clk(clk),
    .reset_reduction_mvm(reset),
    .start(start_reduction_tree),
    .out_data_available(out_data_available_reduction),
% for i in range(num_tiles):
    .inp${i}(result_mvm_${i}),
% endfor
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
            .reset(reset[i-1]),
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
            .reset(reset[i-1]),
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
    input[`NUM_LDPES-1:0] start,
    input[`NUM_LDPES-1:0] reset,
    input vrf_wr_enable,
    input [`VRF_AWIDTH-1:0] vrf_wr_addr,
    input [`VRF_AWIDTH-1:0] vrf_read_addr,
    input [`VRF_DWIDTH-1:0] vec,
    output[`VRF_DWIDTH-1:0] vrf_data_out,
    input [`MRF_DWIDTH*`NUM_LDPES-1:0] mrf_in,
    input vrf_readn_enable,
    input[`NUM_LDPES-1:0] mrf_we,
    input[`NUM_LDPES-1:0] mrf_we_for_dram,
    input [`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr,
    input [`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_for_dram,
    input [`NUM_LDPES-1:0] out_data_available_external_comparator_tree,
    output [`NUM_LDPES-1:0] out_data_available_internal_comparator_tree,
    output [`NUM_LDPES-1:0] out_data_available,
    output [`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp,
    output [`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result,
    output [`MRF_DWIDTH*`NUM_LDPES-1:0] mrf_outa_to_dram
);

    wire [`VRF_DWIDTH-1:0] ina_fake;
   
  
    wire [`VRF_DWIDTH-1:0] vrf_outa_wire;

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
                .reset(reset[i-1]),
                .start(start[i-1]),
                .vec(vrf_outa_wire),
                .mrf_in(mrf_in[i*`MRF_DWIDTH-1:(i-1)*`MRF_DWIDTH]),
                .mrf_we(mrf_we[i-1]),
                .mrf_addr(mrf_addr[i*`MRF_AWIDTH-1:(i-1)*`MRF_AWIDTH]),
                .mrf_addr_for_dram(mrf_addr_for_dram[i*`MRF_AWIDTH-1:(i-1)*`MRF_AWIDTH]),
                .mrf_outa_to_dram(mrf_outa_to_dram[i*`MRF_DWIDTH-1:(i-1)*`MRF_DWIDTH]),
                .mrf_we_for_dram(mrf_we_for_dram[i-1]),
                .max_exp(max_exp[i*`BFLOAT_EXP-1:(i-1)*`BFLOAT_EXP]),
                .out_data_available_external_comparator_tree(out_data_available_external_comparator_tree[i-1]),
                .out_data_available_internal_comparator_tree(out_data_available_internal_comparator_tree[i-1]),
                .out_data_available_dot_prod(out_data_available[i-1]),
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
    input [`MRF_AWIDTH-1:0] mrf_addr_for_dram, //new
    input mrf_we, mrf_we_for_dram, //new
    input [`MRF_AWIDTH-1:0] mrf_addr,
    input out_data_available_external_comparator_tree,
    output out_data_available_internal_comparator_tree,
    output out_data_available_dot_prod,
    output [`LDPE_USED_OUTPUT_WIDTH-1:0] result,
    output [`MRF_DWIDTH-1:0] mrf_outa_to_dram, //new
    output [`BFLOAT_EXP-1:0] max_exp
);

    // Port A of BRAMs is used for feed DSPs and Port B is used to load matrix from off-chip memory

  
    wire [`MRF_DWIDTH-1:0] mrf_outb_wire;

    wire [`LDPE_USED_INPUT_WIDTH-1:0] ax_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] ay_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] bx_wire;
    wire [`LDPE_USED_INPUT_WIDTH-1:0] by_wire;

    // Wire connecting LDPE output to Output BRAM input
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] ldpe_result;
    
    wire [`LDPE_USED_OUTPUT_WIDTH-1:0] inb_fake_wire;

    // First 4 BRAM outputs are given to ax of 4 DSPs and next 4 BRAM outputs are given to bx of DSPs

    // Connection MRF and LDPE wires for matrix data
    // 'X' pin is used for matrix
    /* If there are 4 DSPSs, bit[31:0] of mrf output contain ax values for the 4 DSPs, bit[63:32] contain bx values and so on. With a group of ax values, bit[7:0] contain ax value for DSP1, bit[15:8] contain ax value for DSP2 and so on. */
    assign ax_wire = mrf_outb_wire[1*`LDPE_USED_INPUT_WIDTH-1:0*`LDPE_USED_INPUT_WIDTH];
    assign bx_wire = mrf_outb_wire[2*`LDPE_USED_INPUT_WIDTH-1:1*`LDPE_USED_INPUT_WIDTH];

    // Connection of VRF and LDPE wires for vector data
    // 'Y' pin is used for vector
    assign ay_wire = vec[`LDPE_USED_INPUT_WIDTH-1:0];
    assign by_wire = vec[2*`LDPE_USED_INPUT_WIDTH-1:1*`LDPE_USED_INPUT_WIDTH];

    wire [`MRF_DWIDTH-1:0] mrf_in_fake;
    
    MRF mrf (
        .clk(clk),
        .addra(mrf_addr_for_dram),
        .addrb(mrf_addr),
        .ina(mrf_in),
        .inb(mrf_in_fake),
        .wea(mrf_we_for_dram),
        .web(mrf_we),
        .outa(mrf_outa_to_dram),
        .outb(mrf_outb_wire)
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
        .out_data_available_dot_prod(out_data_available_dot_prod),
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
    output out_data_available_dot_prod,
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
        .out_data_available_dot_prod(out_data_available_dot_prod),
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
    input start,
    input clk,
    output reg [OUTPUT_WIDTH-1:0] sum,
    output reg out_data_available
);

    always@(posedge clk) begin
        if((reset==1) || (start==0)) begin
            sum <= 0;
            out_data_available <= 0;
        end
        else begin
            out_data_available <= 1;
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
    output reg out_data_available_dot_prod,
    output [`BFLOAT_EXP-1:0] max_exp
);


    wire [`DSP_USED_OUTPUT_WIDTH*`DSPS_PER_SUB_LDPE-1:0] chainin, chainout, dsp_result;
    
    wire [36:0] chainout_temp_0;
    assign chainout_temp_0 = 37'b0;

% for i in range(1,num_dsp_per_ldpe+1):
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_${i};
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_${i};
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_${i};
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_${i};

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_${i}_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_${i}_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_${i}_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_${i}_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_${i}_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_${i}_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_${i}_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_${i}_mantisa_shifted;

    assign ax_wire_${i}_num = ax[${i}*`BFLOAT_DWIDTH-1:(${i}-1)*`BFLOAT_DWIDTH];
    assign ay_wire_${i}_num = ay[${i}*`BFLOAT_DWIDTH-1:(${i}-1)*`BFLOAT_DWIDTH];
    assign bx_wire_${i}_num = bx[${i}*`BFLOAT_DWIDTH-1:(${i}-1)*`BFLOAT_DWIDTH];
    assign by_wire_${i}_num = by[${i}*`BFLOAT_DWIDTH-1:(${i}-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_${i}_ax;
    assign shift_amt_${i}_ax = max_exp - ax_wire_${i}_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_${i};
    wire start_barrel_shifter_ax_${i};

    assign start_barrel_shifter_ax_${i} = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_${i}(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_${i}),
        .out_data_available(out_data_available_barrel_shifter_ax_${i}),
        .shift_amt(shift_amt_${i}_ax),
        .significand({1'b1,ax_wire_${i}_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_${i}_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_${i}_ay;
    assign shift_amt_${i}_ay = max_exp - ay_wire_${i}_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_${i};
    wire start_barrel_shifter_ay_${i};

    assign start_barrel_shifter_ay_${i} = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_${i}(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_${i}),
        .out_data_available(out_data_available_barrel_shifter_ay_${i}),
        .shift_amt(shift_amt_${i}_ay),
        .significand({1'b1,ay_wire_${i}_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_${i}_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_${i}_bx;
    assign shift_amt_${i}_bx = max_exp - bx_wire_${i}_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_${i};
    wire start_barrel_shifter_bx_${i};

    assign start_barrel_shifter_bx_${i} = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_${i}(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_${i}),
        .out_data_available(out_data_available_barrel_shifter_bx_${i}),
        .shift_amt(shift_amt_${i}_bx),
        .significand({1'b1,bx_wire_${i}_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_${i}_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_${i}_by;
    assign shift_amt_${i}_by = max_exp - by_wire_${i}_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_${i};
    wire start_barrel_shifter_by_${i};

    assign start_barrel_shifter_by_${i} = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_${i}(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_${i}),
        .out_data_available(out_data_available_barrel_shifter_by_${i}),
        .shift_amt(shift_amt_${i}_by),
        .significand({1'b1,by_wire_${i}_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_${i}_mantisa_shifted)
    );

    assign ax_wire_${i} = (ax_wire_${i}_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_${i}_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_${i}_mantisa_shifted};
    assign ay_wire_${i} = (ay_wire_${i}_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_${i}_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_${i}_mantisa_shifted};
    assign bx_wire_${i} = (bx_wire_${i}_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_${i}_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_${i}_mantisa_shifted};
    assign by_wire_${i} = (by_wire_${i}_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_${i}_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_${i}_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_${i};
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_${i};

    assign dsp_result[${i}*`DSP_USED_OUTPUT_WIDTH-1:(${i}-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_${i}[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_${i};
    assign reset_dsp_${i} = ~out_data_available_barrel_shifter_ax_${i};

    dsp_block_18_18_int_sop_2 dsp_${i} (
        .clk(clk),
        .aclr(reset_dsp_${i}),
        .ax(ax_wire_${i}),
        .ay(ay_wire_${i}),
        .bx(bx_wire_${i}),
        .by(by_wire_${i}),
        .chainin(chainout_temp_${i-1}),
        .chainout(chainout_temp_${i}),
        .result(result_temp_${i})
    );
% endfor


exponent_comparator_tree_ldpe exp_cmp (
        .clk(clk),
        .reset(reset),
        .start(start),
        .out_data_available(out_data_available_internal_comparator_tree),
% for i in range(1,num_dsp_per_ldpe+1):
        .inp${i-1}(ax_wire_${i}_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
% endfor
% for i in range(1,num_dsp_per_ldpe+1):
        .inp${num_dsp_per_ldpe+i-1}(ay_wire_${i}_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
% endfor
% for i in range(1,num_dsp_per_ldpe+1):
        .inp${(2*num_dsp_per_ldpe)+i-1}(bx_wire_${i}_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
% endfor
% for i in range(1,num_dsp_per_ldpe+1):
        .inp${3*(num_dsp_per_ldpe)+i-1}(by_wire_${i}_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
% endfor
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

    
    reg [4:0] num_cycles_mvm;   

    always@(posedge clk) begin
        if((reset==1'b1) || (out_data_available_barrel_shifter_ax_1==1'b0)) begin
            num_cycles_mvm<=0;
            out_data_available_dot_prod<=0;
        end
        else begin
            if(num_cycles_mvm==`NUM_MVM_CYCLES-1) begin
                out_data_available_dot_prod <= 1;
            end
            else begin
                num_cycles_mvm <= num_cycles_mvm + 1;
            end
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
    input [`MRF_AWIDTH-1:0] addra, addrb,
    input [`MRF_DWIDTH-1:0] ina, inb,
    input wea, web,
    output [`MRF_DWIDTH-1:0] outa, outb
);
/*
    genvar i;
    generate
    for(i=1;i<=`BRAMS_PER_MRF;i=i+1) begin
        sp_ram # (
            .AWIDTH(`MAT_BRAM_AWIDTH),
            .DWIDTH(`MAT_BRAM_DWIDTH)
        ) mat_mem (
            .clk(clk),
            .addr(addr),
            .in(in[i*`MAT_BRAM_DWIDTH-1:(i-1)*`MAT_BRAM_DWIDTH]),
            .we(we),
            .out(out[i*`MAT_BRAM_DWIDTH-1:(i-1)*`MAT_BRAM_DWIDTH])
        );
    end
    endgenerate
*/
    dp_ram # (
            .AWIDTH(`MRF_AWIDTH),
            .DWIDTH(`MRF_DWIDTH)
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

`ifndef complex_dsp

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

wire [10:0] mode;
assign mode = 11'b0101_0101_0011;

int_sop_2 mac_component (
    .mode_sigs(mode),
    .clk(clk),
    .reset(aclr),
    .ax(ax),
    .ay(ay),
    .bx(bx),
    .by(by),
    .chainin(chainin),
    .resulta(result),
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

`ifndef hard_mem

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
/*
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

`ifndef hard_mem

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
*/

module mvm_reduction_unit(
% for i in range(num_tiles):
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp${i},
% endfor
    output [`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_final_stage,
    output [`NUM_LDPES-1:0] out_data_available,
    //CONTROL SIGNALS
    input clk,
    input[`NUM_LDPES-1:0] start,
    input[`NUM_LDPES-1:0] reset_reduction_mvm
);

/*
    reg[3:0] num_cycles_reduction;

    always@(posedge clk) begin
        if((reset_reduction_mvm[0]==1'b1) || (start[0]==1'b0)) begin
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
*/

    genvar i;

%for i in range(0,num_tiles,2):
    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_${int(i/2)}_stage_1;
    wire[`NUM_LDPES-1:0] out_data_available_${int(i/2)}_stage_1;

    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_initial_${int(i/2)} (
              .a(inp${i}[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .b(inp${i+1}[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .clk(clk),
              .reset(reset_reduction_mvm[i-1]),
              .start(start[i-1]),
              .out_data_available(out_data_available_${int(i/2)}_stage_1[i-1]),
              .sum(reduction_output_${int(i/2)}_stage_1[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH])
            );
        end
    endgenerate
%endfor

% for i in range(1,num_reduction_stages):
% for k in range(num_tiles>>(i+1)):
    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_${k}_stage_${i+1};
    wire[`NUM_LDPES-1:0] out_data_available_${k}_stage_${i+1};

    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_${k}_stage_${i} (
              .a(reduction_output_${2*(k)}_stage_${i}[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)]),
              .b(reduction_output_${(2*k)+1}_stage_${i}[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)]),
              .clk(clk),
              .reset(reset_reduction_mvm[i-1]),
              .start(out_data_available_0_stage_${i}[i-1]),
              .out_data_available(out_data_available_${k}_stage_${i+1}[i-1]),
              .sum(reduction_output_${k}_stage_${i+1}[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)])
            );
        end
    endgenerate
%endfor
%endfor

% for i in range(num_ldpes):
assign result_mvm_final_stage[${i+1}*`DSP_USED_OUTPUT_WIDTH-1:${i}*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_${num_reduction_stages}[${i+1}*(`DSP_USED_OUTPUT_WIDTH)-1:${i}*(`DSP_USED_OUTPUT_WIDTH)];
% endfor 
assign out_data_available = out_data_available_0_stage_${num_reduction_stages};
endmodule
