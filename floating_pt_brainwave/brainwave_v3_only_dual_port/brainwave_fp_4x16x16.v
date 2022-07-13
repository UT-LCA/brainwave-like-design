////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM includes.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


`define NUM_TILES 4
`define NUM_LDPES 16
`define DSPS_PER_LDPE 16

`define IN_PRECISION 16
`define OUT_PRECISION 16

`define FLOAT_EXP 8
`define FLOAT_MANTISA 7
`define FLOAT_DWIDTH (`FLOAT_EXP+`FLOAT_MANTISA + 1)

`define BFLOAT_EXP 5
`define BFLOAT_MANTISA 5
`define BFLOAT_DWIDTH (`BFLOAT_EXP + `BFLOAT_MANTISA + 1)
`define BFLOAT_MANTISA_WITH_LO (`BFLOAT_MANTISA+1)


`define DSPS_PER_SUB_LDPE 16
`define SUB_LDPES_PER_LDPE (`DSPS_PER_LDPE/`DSPS_PER_SUB_LDPE)

`define MULTS_PER_DSP 2
`define DSP_X_AVA_INPUT_WIDTH 18
`define LDPE_X_AVA_INPUT_WIDTH (`DSP_X_AVA_INPUT_WIDTH * `DSPS_PER_LDPE)
`define DSP_Y_AVA_INPUT_WIDTH 19
`define LDPE_Y_AVA_INPUT_WIDTH (`DSP_Y_AVA_INPUT_WIDTH * `DSPS_PER_LDPE)

`define DSP_AVA_OUTPUT_WIDTH 37
`define LDPE_AVA_OUTPUT_WIDTH `DSP_AVA_OUTPUT_WIDTH

`define DSP_USED_INPUT_WIDTH (`BFLOAT_MANTISA+1)

`define LDPE_USED_INPUT_WIDTH (`FLOAT_DWIDTH * `DSPS_PER_LDPE)
`define SUB_LDPE_USED_INPUT_WIDTH (`BFLOAT_DWIDTH * `DSPS_PER_SUB_LDPE)
`define DSP_X_ZERO_PAD_INPUT_WIDTH (`DSP_X_AVA_INPUT_WIDTH - `DSP_USED_INPUT_WIDTH)
`define DSP_Y_ZERO_PAD_INPUT_WIDTH (`DSP_Y_AVA_INPUT_WIDTH - `DSP_USED_INPUT_WIDTH)

`define DSP_USED_OUTPUT_WIDTH 27
`define LDPE_USED_OUTPUT_WIDTH `DSP_USED_OUTPUT_WIDTH
`define DSP_ZERO_PAD_OUTPUT_WIDTH (`DSP_AVA_OUTPUT_WIDTH - `DSP_USED_OUTPUT_WIDTH)

`define LDPES_PER_MRF 1
`define DSPS_PER_MRF (`DSPS_PER_LDPE * `LDPES_PER_MRF)
`define MAT_BRAM_AWIDTH 10
`define MAT_BRAM_DWIDTH 16
`define MAT_BRAMS_PER_MRF_SUBSET 32
`define SUBSETS_PER_MRF 1
`define BRAMS_PER_MRF (`MAT_BRAMS_PER_MRF_SUBSET * `SUBSETS_PER_MRF)
`define MRF_AWIDTH (`MAT_BRAM_AWIDTH)
`define MRF_DWIDTH (`MAT_BRAM_DWIDTH * `MAT_BRAMS_PER_MRF_SUBSET)

`define LDPES_PER_VRF 1
`define DSPS_PER_VRF (`DSPS_PER_LDPE * `LDPES_PER_VRF)
`define VEC_BRAM_AWIDTH 10
`define VEC_BRAM_DWIDTH 16
`define BRAMS_PER_VRF 32
`define VRF_AWIDTH `VEC_BRAM_AWIDTH
`define VRF_DWIDTH (`VEC_BRAM_DWIDTH * `BRAMS_PER_VRF)

`define LDPES_PER_ORF 1
`define OUTPUTS_PER_LDPE 1
`define OUT_BRAM_AWIDTH 10
`define OUT_BRAM_DWIDTH 16
`define ORF_AWIDTH `OUT_BRAM_AWIDTH
`define OUT_DWIDTH 16
`define ORF_DWIDTH 256 //512

`define MAX_VRF_DWIDTH 512
`define DRAM_DWIDTH (`MRF_DWIDTH + `ORF_DWIDTH + `VRF_DWIDTH) //KEEP THIS LARGE TO AVOID OPTIMIZATION IN VTR 
`define DRAM_AWIDTH `MRF_AWIDTH

`define OPCODE_WIDTH 4 
`define TARGET_OP_WIDTH 7

`define INSTR_WIDTH (`OPCODE_WIDTH+`TARGET_OP_WIDTH+`DRAM_AWIDTH+`TARGET_OP_WIDTH+`VRF_AWIDTH + `VRF_AWIDTH)

`define ACTIVATION 2'b00
`define ELT_WISE_MULTIPLY 2'b10
`define ELT_WISE_ADD 2'b01
`define BYPASS 2'b11

`define RELU 2'b00
`define TANH 2'b01
`define SIGM 2'b10
//OPCODES

`define V_RD 0
`define V_WR 1
`define M_RD 2
`define M_WR 3 //NEWLY ADDED
`define MV_MUL 4
`define VV_ADD 5
`define VV_SUB 6 //QUESTIONED
`define VV_PASS 7
`define VV_MUL 8
`define V_RELU 9
`define V_SIGM 10
`define V_TANH 11
`define END_CHAIN 12
//MEM_IDS

`define VRF_0 0
`define VRF_1 1
`define VRF_2 2
`define VRF_3 3

`define VRF_4 4
`define VRF_5 5
`define VRF_6 6
`define VRF_7 7
`define VRF_MUXED 8
`define DRAM_MEM_ID 9
`define MFU_0_DSTN_ID 10
`define MFU_1_DSTN_ID 11

`define MRF_0 0
`define MRF_1 1
`define MRF_2 2
`define MRF_3 3
`define MRF_4 4
`define MRF_5 5
`define MRF_6 6
`define MRF_7 7
`define MRF_8 8
`define MRF_9 9
`define MRF_10 10
`define MRF_11 11
`define MRF_12 12
`define MRF_13 13
`define MRF_14 14
`define MRF_15 15
`define MRF_16 16
`define MRF_17 17
`define MRF_18 18
`define MRF_19 19
`define MRF_20 20
`define MRF_21 21
`define MRF_22 22
`define MRF_23 23
`define MRF_24 24
`define MRF_25 25
`define MRF_26 26
`define MRF_27 27
`define MRF_28 28
`define MRF_29 29
`define MRF_30 30
`define MRF_31 31
`define MRF_32 32
`define MRF_33 33
`define MRF_34 34
`define MRF_35 35
`define MRF_36 36
`define MRF_37 37
`define MRF_38 38
`define MRF_39 39
`define MRF_40 40
`define MRF_41 41
`define MRF_42 42
`define MRF_43 43
`define MRF_44 44
`define MRF_45 45
`define MRF_46 46
`define MRF_47 47
`define MRF_48 48
`define MRF_49 49
`define MRF_50 50
`define MRF_51 51
`define MRF_52 52
`define MRF_53 53
`define MRF_54 54
`define MRF_55 55
`define MRF_56 56
`define MRF_57 57
`define MRF_58 58
`define MRF_59 59
`define MRF_60 60
`define MRF_61 61
`define MRF_62 62
`define MRF_63 63

`define MFU_0 0
`define MFU_1 1
`define INSTR_MEM_AWIDTH 10

`define EXPONENT 5
`define MANTISSA 10

`define SIGN 1
`define NUM_COMPARATOR_TREE_CYCLES 7
`define NUM_COMPARATOR_TREE_CYCLES_FOR_TILE 4
`define NUM_LZD_CYCLES 5

`define DESIGN_SIZE `NUM_LDPES
`define DWIDTH `OUT_PRECISION
`define MASK_WIDTH `OUT_PRECISION

`define ADD_LATENCY 5
`define LOG_ADD_LATENCY 3
`define MUL_LATENCY 5
`define LOG_MUL_LATENCY 3 
`define ACTIVATION_LATENCY 3
`define TANH_LATENCY (`ACTIVATION_LATENCY+1)
`define SIGMOID_LATENCY (`ACTIVATION_LATENCY+1)

`define NUM_REDUCTION_CYCLES 2
`define NUM_MVM_CYCLES 28
`define NUM_NORMALISE_CYCLES 6
////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM npu.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


module NPU(
    input reset_npu,
    input[`INSTR_WIDTH-1:0] instruction,
    input[`DRAM_DWIDTH-1:0] input_data_DRAM,
    output [`DRAM_DWIDTH-1:0] output_data_DRAM,
    output [`DRAM_AWIDTH-1:0] dram_addr,
    output dram_write_enable,
    output get_instr,
    output[`INSTR_MEM_AWIDTH-1:0] get_instr_addr,
    //WRITE DOCUMENTATION EXPLAINING HOW MANY PORTS EACH VRF,MRF, ORF HAS and WHERE IS IT CONNECTED TO
    input clk
);
    wire[`ORF_DWIDTH-1:0] output_final_stage;
    
   
    wire start_mv_mul_signal;
    wire start_mfu_0_signal;
    wire start_mfu_1_signal;
    

    //SAME SIGNAL FOR ALL THE TILES AS PARALLEL EXECUTION OF TILES IS REQUIRED
    reg[`NUM_LDPES-1:0] start_tile_with_single_cyc_latency;
    reg[`NUM_LDPES-1:0] reset_tile_with_single_cyc_latency;
    //

    wire [`MAX_VRF_DWIDTH-1:0] vrf_in_data;
    wire[`VRF_AWIDTH-1:0] vrf_addr_wr;
    wire[`VRF_AWIDTH-1:0] vrf_addr_read;
    wire [`MRF_DWIDTH*`NUM_LDPES*`NUM_TILES-1:0] mrf_in_data;
    
    
    //MRF SIGNALS
    wire[`NUM_LDPES*`NUM_TILES-1:0] mrf_we;
    wire [`MRF_AWIDTH*`NUM_LDPES*`NUM_TILES-1:0] mrf_addr_wr;
    //
    
    //FINAL STAGE OUTPUT SIGNALS
    wire[`ORF_DWIDTH-1:0] result_mvm; 
    //reg[`ORF_AWIDTH-1:0] result_addr_mvu_orf;
    
    //wire orf_addr_increment;
  
    //
    wire[`VRF_DWIDTH-1:0] vrf_mvu_out_0;
    wire vrf_mvu_wr_enable_0;
    wire vrf_mvu_readn_enable_0;
    wire[`VRF_DWIDTH-1:0] vrf_mvu_out_1;
    wire vrf_mvu_wr_enable_1;
    wire vrf_mvu_readn_enable_1;
    wire[`VRF_DWIDTH-1:0] vrf_mvu_out_2;
    wire vrf_mvu_wr_enable_2;
    wire vrf_mvu_readn_enable_2;
    wire[`VRF_DWIDTH-1:0] vrf_mvu_out_3;
    wire vrf_mvu_wr_enable_3;
    wire vrf_mvu_readn_enable_3;
    
    wire done_mvm; //CHANGES THE REST STATE OF INSTR DECODER
    wire out_data_available_mvm;

    wire[`NUM_TILES*`NUM_LDPES-1:0] mrf_we_for_dram;
    wire [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_for_dram;
    wire [`NUM_TILES*`MRF_DWIDTH*`NUM_LDPES-1:0] mrf_outa_to_dram;

    MVU mvm_unit (
    .clk(clk),
    .start(start_tile_with_single_cyc_latency),
    .reset(reset_tile_with_single_cyc_latency),
    
    .vrf_wr_addr(vrf_addr_wr),
    .vrf_read_addr(vrf_addr_read),
    .vec(vrf_in_data[`VRF_DWIDTH-1:0]),
    .vrf_data_out_tile_0(vrf_mvu_out_0), //WITH TAG
    .vrf_wr_enable_tile_0(vrf_mvu_wr_enable_0), //WITH TAG
    .vrf_readn_enable_tile_0(vrf_mvu_readn_enable_0), //WITH TAG
    .vrf_data_out_tile_1(vrf_mvu_out_1), //WITH TAG
    .vrf_wr_enable_tile_1(vrf_mvu_wr_enable_1), //WITH TAG
    .vrf_readn_enable_tile_1(vrf_mvu_readn_enable_1), //WITH TAG
    .vrf_data_out_tile_2(vrf_mvu_out_2), //WITH TAG
    .vrf_wr_enable_tile_2(vrf_mvu_wr_enable_2), //WITH TAG
    .vrf_readn_enable_tile_2(vrf_mvu_readn_enable_2), //WITH TAG
    .vrf_data_out_tile_3(vrf_mvu_out_3), //WITH TAG
    .vrf_wr_enable_tile_3(vrf_mvu_wr_enable_3), //WITH TAG
    .vrf_readn_enable_tile_3(vrf_mvu_readn_enable_3), //WITH TAG
    
    .mrf_in(mrf_in_data),
    .mrf_we(mrf_we),  //WITH TAG 
    .mrf_addr(mrf_addr_wr),

    .mrf_we_for_dram(mrf_we_for_dram),
    .mrf_addr_for_dram(mrf_addr_for_dram),
    .mrf_outa_to_dram(mrf_outa_to_dram),

    .out_data_available(out_data_available_mvm),
    .mvm_result(result_mvm) //WITH TAG
    );
   
    assign done_mvm = out_data_available_mvm;
    
    reg[3:0] num_cycles_mvm;
    
 
    //*******************************************************************************
    
    wire in_data_available_mfu_0;
    reg reset_mfu_0_with_single_cyc_latency;
    wire out_data_available_mfu_0;
    wire done_mfu_0;
    
    wire in_data_available_mfu_1;
    reg reset_mfu_1_with_single_cyc_latency;
    wire out_data_available_mfu_1;
    wire done_mfu_1;
    
    wire[1:0] activation;
    wire[1:0] operation;

    //MFU VRF WIRES ****************************************************************
    //wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_read_add_0;
    
    //MFU - STAGE 0 VRF SIGNALS 
    wire[`ORF_DWIDTH-1:0] vrf_mfu_out_data_add_0;
    wire vrf_mfu_readn_enable_add_0;
    wire vrf_mfu_wr_enable_add_0;
    wire[`ORF_AWIDTH-1:0] vrf_mfu_addr_read_add_0;
    wire[`ORF_AWIDTH-1:0] vrf_mfu_addr_wr_add_0;

    wire[`ORF_DWIDTH-1:0] vrf_mfu_out_data_mul_0;
    wire vrf_mfu_readn_enable_mul_0;
    wire vrf_mfu_wr_enable_mul_0;
    wire[`ORF_AWIDTH-1:0] vrf_mfu_addr_read_mul_0;
    wire[`ORF_AWIDTH-1:0] vrf_mfu_addr_wr_mul_0;
    
    //wire[`ORF_AWIDTH-1:0] vrf_mfu_addr_read_add_1;
    
    //MFU - STAGE 1 VRF SIGNALS 

    wire[`ORF_DWIDTH-1:0] vrf_mfu_out_data_add_1;
    wire vrf_mfu_readn_enable_add_1;
    wire vrf_mfu_wr_enable_add_1;
    wire[`ORF_AWIDTH-1:0] vrf_mfu_addr_read_add_1;
    wire[`ORF_AWIDTH-1:0] vrf_mfu_addr_wr_add_1;

    wire[`ORF_DWIDTH-1:0] vrf_mfu_out_data_mul_1;
    wire vrf_mfu_readn_enable_mul_1;
    wire vrf_mfu_wr_enable_mul_1;
    wire[`ORF_AWIDTH-1:0] vrf_mfu_addr_read_mul_1;
    wire[`ORF_AWIDTH-1:0] vrf_mfu_addr_wr_mul_1;
    
    wire[`TARGET_OP_WIDTH-1:0] dstn_id;
    wire[`NUM_LDPES*`OUT_DWIDTH-1:0] output_mvu_stage;
    //************************************************************

    assign output_mvu_stage = result_mvm;
    
    //************** INTER MFU MVU DATAPATH SIGNALS *************************************************
    reg[`ORF_DWIDTH-1:0] output_mvu_stage_buffer;
    reg[`ORF_DWIDTH-1:0] output_mfu_stage_0_buffer;
    
    wire[`ORF_DWIDTH-1:0] primary_in_data_mfu_stage_0;
    wire[`ORF_DWIDTH-1:0] primary_in_data_mfu_stage_1;
    
    
    wire[`NUM_LDPES*`OUT_DWIDTH-1:0] output_mfu_stage_0;
    wire[`NUM_LDPES*`OUT_DWIDTH-1:0] output_mfu_stage_1;
    
    always@(posedge clk) begin
        if((dstn_id==`MFU_0_DSTN_ID) && done_mvm==1'b1) begin
            output_mvu_stage_buffer <= output_mvu_stage;
        end
    end
    
    //CHECK THIS LOGIC CAREFULLY *****************************************************************
    always@(posedge clk) begin                          //FIRST BYPASS MUXING
        //$display("%h", vrf_mvu_wr_addr_0);
        if((dstn_id==`MFU_1_DSTN_ID) && (done_mfu_0 || done_mvm)) begin
            output_mfu_stage_0_buffer <= (done_mfu_0) ? output_mfu_stage_0 : output_mvu_stage;
        end
    end
    
    assign output_final_stage = ((dstn_id!=`MFU_0_DSTN_ID) && (dstn_id!=`MFU_1_DSTN_ID)) ? 
                                (done_mfu_1 ? output_mfu_stage_1 :    //SECOND BYPASS MUXING
                                (done_mfu_0 ? output_mfu_stage_0 :
                                (done_mvm ? output_mvu_stage : 'bX))) : 'bX;
                                  
    //********************************************************************************************
    
    
    //******************************************************************************************
    wire[`ORF_DWIDTH-1:0] vrf_muxed_in_data_fake;
    //************* MUXED MVU-MFU VRF **********************************************************
    
    wire[`ORF_AWIDTH-1:0] vrf_muxed_wr_addr_dram;
    wire[`ORF_DWIDTH-1:0] vrf_muxed_in_data;
    wire vrf_muxed_wr_enable_dram;
    wire vrf_muxed_readn_enable;
    
    wire[`ORF_AWIDTH-1:0] vrf_muxed_read_addr;
    wire[`ORF_DWIDTH-1:0] vrf_muxed_out_data_dram;
    wire[`ORF_DWIDTH-1:0] vrf_muxed_out_data;
    
    
    VRF #(.VRF_DWIDTH(`ORF_DWIDTH),.VRF_AWIDTH(`ORF_AWIDTH)) vrf_muxed (
        .clk(clk),
        
        .addra(vrf_muxed_wr_addr_dram),
        .ina(vrf_in_data[`ORF_DWIDTH-1:0]),
        .wea(vrf_muxed_wr_enable_dram),
        .outa(vrf_muxed_out_data_dram),
        
        .addrb(vrf_muxed_read_addr),
        .inb(vrf_muxed_in_data_fake),
        .web(vrf_muxed_readn_enable),
        .outb(vrf_muxed_out_data) 
    );
    
    wire mvu_or_vrf_mux_select;
    assign primary_in_data_mfu_stage_0 = (mvu_or_vrf_mux_select) ? vrf_muxed_out_data : output_mvu_stage_buffer;
    
    assign primary_in_data_mfu_stage_1 = output_mfu_stage_0_buffer;
    
    //*********************************************************************************************
    
    //*********************************CONTROLLER FOR NPU*****************************************
    controller controller_for_npu(
    .clk(clk), 
    .reset_npu(reset_npu),
    .instruction(instruction),
    .get_instr(get_instr),
    .get_instr_addr(get_instr_addr),
    
    .input_data_from_dram(input_data_DRAM),
    .dram_addr_wr(dram_addr),
    .dram_write_enable(dram_write_enable),
    .output_data_to_dram(output_data_DRAM),
    
    .output_final_stage(output_final_stage),

    .start_mfu_0(start_mfu_0_signal),
    .start_mfu_1(start_mfu_1_signal),
    .start_mv_mul(start_mv_mul_signal),
    .in_data_available_mfu_0(in_data_available_mfu_0),
    .in_data_available_mfu_1(in_data_available_mfu_1),

    .activation(activation),
    .operation(operation),
    
    .vrf_addr_read(vrf_addr_read),
    .vrf_addr_wr(vrf_addr_wr),

    .vrf_out_data_mvu_0(vrf_mvu_out_0),               //MVU TILE VRF
    .vrf_readn_enable_mvu_0(vrf_mvu_readn_enable_0),
    .vrf_wr_enable_mvu_0(vrf_mvu_wr_enable_0),
    .vrf_out_data_mvu_1(vrf_mvu_out_1),               //MVU TILE VRF
    .vrf_readn_enable_mvu_1(vrf_mvu_readn_enable_1),
    .vrf_wr_enable_mvu_1(vrf_mvu_wr_enable_1),
    .vrf_out_data_mvu_2(vrf_mvu_out_2),               //MVU TILE VRF
    .vrf_readn_enable_mvu_2(vrf_mvu_readn_enable_2),
    .vrf_wr_enable_mvu_2(vrf_mvu_wr_enable_2),
    .vrf_out_data_mvu_3(vrf_mvu_out_3),               //MVU TILE VRF
    .vrf_readn_enable_mvu_3(vrf_mvu_readn_enable_3),
    .vrf_wr_enable_mvu_3(vrf_mvu_wr_enable_3),
    
    .done_mvm(done_mvm),
    .done_mfu_0(done_mfu_0),
    .done_mfu_1(done_mfu_1),
    //CHANGE INDEXING FOR VRFs--------------------------------------------
    
    .vrf_out_data_mfu_add_0(vrf_mfu_out_data_add_0),
    .vrf_readn_enable_mfu_add_0(vrf_mfu_readn_enable_add_0),
    .vrf_wr_enable_mfu_add_0(vrf_mfu_wr_enable_add_0), //MFU VRF - ADD -0
    .vrf_addr_read_mfu_add_0(vrf_mfu_addr_read_add_0),
    .vrf_addr_wr_mfu_add_0(vrf_mfu_addr_wr_add_0),


    .vrf_out_data_mfu_mul_0(vrf_mfu_out_data_mul_0),      //MFU VRF - MUL -0
    .vrf_readn_enable_mfu_mul_0(vrf_mfu_readn_enable_mul_0),
    .vrf_wr_enable_mfu_mul_0(vrf_mfu_wr_enable_mul_0),
    .vrf_addr_read_mfu_mul_0(vrf_mfu_addr_read_mul_0),
    .vrf_addr_wr_mfu_mul_0(vrf_mfu_addr_wr_mul_0),
    
    .vrf_out_data_mfu_add_1(vrf_mfu_out_data_add_1),
    .vrf_readn_enable_mfu_add_1(vrf_mfu_readn_enable_add_1),
    .vrf_wr_enable_mfu_add_1(vrf_mfu_wr_enable_add_1), //MFU VRF - ADD - 1
    .vrf_addr_read_mfu_add_1(vrf_mfu_addr_read_add_1),
    .vrf_addr_wr_mfu_add_1(vrf_mfu_addr_wr_add_1),


    .vrf_out_data_mfu_mul_1(vrf_mfu_out_data_mul_1),      //MFU VRF - MUL - 1
    .vrf_readn_enable_mfu_mul_1(vrf_mfu_readn_enable_mul_1),
    .vrf_wr_enable_mfu_mul_1(vrf_mfu_wr_enable_mul_1),
    .vrf_addr_read_mfu_mul_1(vrf_mfu_addr_read_mul_1),
    .vrf_addr_wr_mfu_mul_1(vrf_mfu_addr_wr_mul_1),
    
    //MUXED VRF---------------------------------------
    .vrf_muxed_wr_addr_dram(vrf_muxed_wr_addr_dram),
    .vrf_muxed_read_addr(vrf_muxed_read_addr),
    .vrf_muxed_out_data_dram(vrf_muxed_out_data_dram),
    .vrf_muxed_wr_enable_dram(vrf_muxed_wr_enable_dram),
    .vrf_muxed_readn_enable(vrf_muxed_readn_enable),
     //----------------------------------------------
     
    .mvu_or_vrf_mux_select(mvu_or_vrf_mux_select),
    .vrf_in_data(vrf_in_data), //common
    
    //-----------------------------------------------------------------
    
    .mrf_addr_wr(mrf_addr_wr),
    .mrf_wr_enable(mrf_we),
    .mrf_in_data(mrf_in_data),

    .mrf_we_for_dram(mrf_we_for_dram),
    .mrf_addr_for_dram(mrf_addr_for_dram),
    .mrf_outa_to_dram(mrf_outa_to_dram),
    
    //.orf_addr_increment(orf_addr_increment),
    
    .dstn_id(dstn_id)
    );
    //***************************************************************************
    
    //DELAYS START SIGNALS OF MVU TILE BY ONE CYCLE TO AVOID HIGH FANOUT AND ARITHEMETIC OF DONT CARES ***********
    always@(posedge clk) begin
        if(start_mv_mul_signal==1'b1) begin
            start_tile_with_single_cyc_latency<={`NUM_LDPES{1'b1}};
            reset_tile_with_single_cyc_latency<={`NUM_LDPES{1'b0}};
        end
        else begin
            start_tile_with_single_cyc_latency<={`NUM_LDPES{1'b0}};
            reset_tile_with_single_cyc_latency<={`NUM_LDPES{1'b1}};
        end
    end
    
    always@(*) begin
        if(start_mfu_0_signal==1'b1) begin
            reset_mfu_0_with_single_cyc_latency<=1'b0;
        end
        else begin
            reset_mfu_0_with_single_cyc_latency<=1'b1;
        end
    end
    
    always@(*) begin
        if(start_mfu_1_signal==1'b1) begin
            reset_mfu_1_with_single_cyc_latency<=1'b0;
        end
        else begin
            reset_mfu_1_with_single_cyc_latency<=1'b1;
        end
    end
    
    
    //*********************************************************************************************
    wire out_data_available_0;
   assign out_data_available_0 = done_mfu_0;
   MFU mfu_stage_0( 
    .activation_type(activation),
    .operation(operation),
    .in_data_available(in_data_available_mfu_0),
    
    .vrf_addr_read_add(vrf_mfu_addr_read_add_0),
    .vrf_addr_wr_add(vrf_mfu_addr_wr_add_0),
    .vrf_readn_enable_add(vrf_mfu_readn_enable_add_0),
    .vrf_wr_enable_add(vrf_mfu_wr_enable_add_0),

    .vrf_addr_read_mul(vrf_mfu_addr_read_mul_1),
    .vrf_addr_wr_mul(vrf_mfu_addr_wr_mul_1),
    .vrf_readn_enable_mul(vrf_mfu_readn_enable_mul_0),
    .vrf_wr_enable_mul(vrf_mfu_wr_enable_mul_0),
    
    .primary_inp(primary_in_data_mfu_stage_0),
    .secondary_inp(vrf_in_data[`ORF_DWIDTH-1:0]),
    .out_data(output_mfu_stage_0),
    .out_data_available(out_data_available_0),
    .done(done_mfu_0),
    .clk(clk),
    
    //VRF OUT SIGNALS
    .out_vrf_add(vrf_mfu_out_data_add_0),
    .out_vrf_mul(vrf_mfu_out_data_mul_0),
    
    .reset(reset_mfu_0_with_single_cyc_latency)
    );
    
    //*************************************************************************
    //MFU STAGE - 2
    wire out_data_available_1;
    assign out_data_available_1 = done_mfu_1;

    MFU mfu_stage_1( 
    .activation_type(activation),
    .operation(operation),
    .in_data_available(in_data_available_mfu_1),
    
    //VRF IO SIGNALS FOR ELTWISE-ADD
    .vrf_addr_read_add(vrf_mfu_addr_read_add_1),
    .vrf_addr_wr_add(vrf_mfu_addr_wr_add_1),
    .vrf_readn_enable_add(vrf_mfu_readn_enable_add_1),
    .vrf_wr_enable_add(vrf_mfu_wr_enable_add_1),

    .vrf_addr_read_mul(vrf_mfu_addr_read_mul_1),
    .vrf_addr_wr_mul(vrf_mfu_addr_wr_mul_1),
    .vrf_readn_enable_mul(vrf_mfu_readn_enable_mul_1),
    .vrf_wr_enable_mul(vrf_mfu_wr_enable_mul_1),
    
     //VRF IO SIGNALS FOR ELTWISE-MUL
    .primary_inp(primary_in_data_mfu_stage_1),
    .secondary_inp(vrf_in_data[`ORF_DWIDTH-1:0]),
    .out_data(output_mfu_stage_1),
    
    .out_data_available(out_data_available_mfu_1),
    .done(done_mfu_1),
    .clk(clk),
    
    //VRF OUT SIGNAL
    .out_vrf_add(vrf_mfu_out_data_add_1),
    .out_vrf_mul(vrf_mfu_out_data_mul_1),
    
    .reset(reset_mfu_1_with_single_cyc_latency)
    );
    
    //*************************************************************************
    
    //************BYPASS MUXING LOGIC *****************************************


endmodule
////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM controller.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


//`include "includes_gen.v"

module controller( 

    input clk,
    input reset_npu,
    input done_mvm,
    input done_mfu_0,
    input done_mfu_1,
    
    
    input[`INSTR_WIDTH-1:0] instruction,
    output reg get_instr,
    output reg[`INSTR_MEM_AWIDTH-1:0] get_instr_addr,
    
    input[`DRAM_DWIDTH-1:0] input_data_from_dram,
    input[`ORF_DWIDTH-1:0] output_final_stage, 
    output reg[`DRAM_AWIDTH-1:0] dram_addr_wr,
    output reg dram_write_enable,
    output reg [`DRAM_DWIDTH-1:0] output_data_to_dram,

    //output reg start_mvu,
    output reg start_mv_mul,
    output reg start_mfu_0,
    output reg start_mfu_1,
    //output reg reset_mvu,
    output reg in_data_available_mfu_0,
    output reg in_data_available_mfu_1,
    
    output reg[1:0] activation,
    output reg[1:0] operation,

    //FOR MVU IO

    input[`VRF_DWIDTH-1:0] vrf_out_data_mvu_0,
    output reg vrf_readn_enable_mvu_0,
    output reg vrf_wr_enable_mvu_0,


    input[`VRF_DWIDTH-1:0] vrf_out_data_mvu_1,
    output reg vrf_readn_enable_mvu_1,
    output reg vrf_wr_enable_mvu_1,


    input[`VRF_DWIDTH-1:0] vrf_out_data_mvu_2,
    output reg vrf_readn_enable_mvu_2,
    output reg vrf_wr_enable_mvu_2,


    input[`VRF_DWIDTH-1:0] vrf_out_data_mvu_3,
    output reg vrf_readn_enable_mvu_3,
    output reg vrf_wr_enable_mvu_3,

    
    output reg[`VRF_AWIDTH-1:0] vrf_addr_read,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_wr, //*********************

    //FOR MFU STAGE -0
    input[`ORF_DWIDTH-1:0] vrf_out_data_mfu_add_0,
    output reg vrf_readn_enable_mfu_add_0,
    output reg vrf_wr_enable_mfu_add_0,
    output reg[`ORF_AWIDTH-1:0] vrf_addr_read_mfu_add_0,
    output reg[`ORF_AWIDTH-1:0] vrf_addr_wr_mfu_add_0,
    
    input[`ORF_DWIDTH-1:0] vrf_out_data_mfu_mul_0,
    output reg vrf_readn_enable_mfu_mul_0,
    output reg vrf_wr_enable_mfu_mul_0,
    output reg[`ORF_AWIDTH-1:0] vrf_addr_read_mfu_mul_0,
    output reg[`ORF_AWIDTH-1:0] vrf_addr_wr_mfu_mul_0,
    //
    
    //FOR MFU STAGE -1 
    input[`ORF_DWIDTH-1:0] vrf_out_data_mfu_add_1,
    output reg vrf_readn_enable_mfu_add_1,
    output reg vrf_wr_enable_mfu_add_1,
    output reg[`ORF_AWIDTH-1:0] vrf_addr_read_mfu_add_1,
    output reg[`ORF_AWIDTH-1:0] vrf_addr_wr_mfu_add_1,
    
    input[`ORF_DWIDTH-1:0] vrf_out_data_mfu_mul_1,
    output reg vrf_readn_enable_mfu_mul_1,
    output reg vrf_wr_enable_mfu_mul_1,
    output reg[`ORF_AWIDTH-1:0] vrf_addr_read_mfu_mul_1,
    output reg[`ORF_AWIDTH-1:0] vrf_addr_wr_mfu_mul_1,
    
    //VRF MUXED 
    input[`ORF_DWIDTH-1:0] vrf_muxed_out_data_dram,
    output reg[`ORF_AWIDTH-1:0] vrf_muxed_wr_addr_dram,
    output reg[`ORF_AWIDTH-1:0] vrf_muxed_read_addr,
    output reg vrf_muxed_wr_enable_dram,
    output reg vrf_muxed_readn_enable,
    //

    output reg[`MAX_VRF_DWIDTH-1:0] vrf_in_data,
    
    output mvu_or_vrf_mux_select,

    //MRF IO PORTS
    output reg[`MRF_AWIDTH*`NUM_LDPES*`NUM_TILES-1:0] mrf_addr_wr,
    output reg[`NUM_LDPES*`NUM_TILES-1:0] mrf_wr_enable, //NOTE: LOG(NUM_LDPES) = TARGET_OP_WIDTH
    output reg[`MRF_DWIDTH*`NUM_LDPES*`NUM_TILES-1:0] mrf_in_data,
    
    output reg[`NUM_TILES*`NUM_LDPES-1:0] mrf_we_for_dram,
    output reg [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_for_dram,
    input [`NUM_TILES*`MRF_DWIDTH*`NUM_LDPES-1:0] mrf_outa_to_dram,
    //
    
   // output reg orf_addr_increment,
    
    //BYPASS SIGNALS
    output[`TARGET_OP_WIDTH-1:0] dstn_id
);

    wire[`OPCODE_WIDTH-1:0] opcode;
    wire[`VRF_AWIDTH-1:0] op1_address;
    wire[`VRF_AWIDTH-1:0] op2_address;
    wire[`VRF_AWIDTH-1:0] dstn_address;
    wire[`TARGET_OP_WIDTH-1:0] src1_id;
    //wire[`TARGET_OP_WIDTH-1:0] dstn_id;
    
    reg[1:0] state;
    
    //NOTE - CORRECT NAMING FOR OPERANDS AND EXTRACTION SCHEME FOR YOUR PARTS OF INSTRUCTION
    assign op1_address = instruction[3*`VRF_AWIDTH+(`TARGET_OP_WIDTH)-1:(2*`VRF_AWIDTH) +(`TARGET_OP_WIDTH)];
    assign op2_address = instruction[2*`VRF_AWIDTH+`TARGET_OP_WIDTH-1:`VRF_AWIDTH+`TARGET_OP_WIDTH];
    assign dstn_address = instruction[`VRF_AWIDTH-1:0];
    assign opcode = instruction[`INSTR_WIDTH-1:`INSTR_WIDTH-`OPCODE_WIDTH];
    assign src1_id = instruction[3*`VRF_AWIDTH+2*`TARGET_OP_WIDTH:3*`VRF_AWIDTH+`TARGET_OP_WIDTH]; //or can be called mem_id
    assign dstn_id = instruction[`VRF_AWIDTH+`TARGET_OP_WIDTH-1:`VRF_AWIDTH];//LSB for dram_write bypass

    assign mvu_or_vrf_mux_select = (op2_address!={`VRF_AWIDTH{1'b0}}); //UNUSED BIT FOR MFU OPERATIONS


    //TODO - MAKE THIS SEQUENTIAL LOGIC - DONE
    always@(posedge clk) begin

    if(reset_npu == 1'b1) begin
          //reset_mvu<=1'b1;
          //start_mvu<=1'b0;
          get_instr<=1'bX;
          
          get_instr_addr<=0;
          
          start_mv_mul <= 1'b0;
    
          in_data_available_mfu_0 <= 1'b0;
          start_mfu_0 <= 1'b0;
          
          in_data_available_mfu_1 <= 1'b0;
          start_mfu_1 <= 1'b0;
          dram_write_enable <= 1'b0;
          mrf_wr_enable<='bX;


          vrf_wr_enable_mvu_0<='bX;
          vrf_readn_enable_mvu_0 <= 'bX;


          vrf_wr_enable_mvu_1<='bX;
          vrf_readn_enable_mvu_1 <= 'bX;


          vrf_wr_enable_mvu_2<='bX;
          vrf_readn_enable_mvu_2 <= 'bX;


          vrf_wr_enable_mvu_3<='bX;
          vrf_readn_enable_mvu_3 <= 'bX;


          vrf_wr_enable_mfu_add_0 <= 'bX;
          vrf_wr_enable_mfu_mul_0 <= 'bX;
          vrf_wr_enable_mfu_add_1 <= 'bX;
          vrf_wr_enable_mfu_mul_1 <= 'bX;
   
          dram_addr_wr<='bX;
          vrf_addr_wr <= 'bX;
          //vrf_addr_wr_mvu_1 <= 0;
          vrf_addr_wr_mfu_add_0 <= 'bX;
          vrf_addr_wr_mfu_mul_0 <= 'bX;
          vrf_addr_wr_mfu_add_1 <= 'bX;
          vrf_addr_wr_mfu_mul_1 <= 'bX;
          
          vrf_addr_read <= 'bX;
          //vrf_addr_read_mvu_1 <= 0;
          vrf_addr_read_mfu_add_0 <= 'bX;
          vrf_addr_read_mfu_mul_0 <= 'bX;
          vrf_addr_read_mfu_add_1 <= 'bX;
          vrf_addr_read_mfu_mul_1 <= 'bX;
          
        
           //vrf_muxed_wr_addr_dram <= 0;
           //vrf_muxed_read_addr <= 0;
           vrf_muxed_wr_enable_dram <= 'bX;
           vrf_muxed_readn_enable <= 'bX;
    
        //  orf_addr_increment<=1'b0;
          
          mrf_addr_wr <= 'bX;
          
          state <= 0;
    end
    else begin
        if(state==0) begin //FETCH
            get_instr <= 1'b0;
            state <= 1;
            vrf_wr_enable_mvu_0 <= 1'b0;
            vrf_wr_enable_mvu_1 <= 1'b0;
            vrf_wr_enable_mvu_2 <= 1'b0;
            vrf_wr_enable_mvu_3 <= 1'b0;
            vrf_wr_enable_mfu_add_0 <= 1'b0;
            vrf_wr_enable_mfu_mul_0 <= 1'b0;
            vrf_wr_enable_mfu_add_1 <= 1'b0;
            vrf_wr_enable_mfu_mul_1 <= 1'b0;
            vrf_muxed_wr_enable_dram <= 1'b0;
            dram_write_enable <= 1'b0;
            mrf_wr_enable <= 0;
        end
        else if(state==1) begin //DECODE
          case(opcode)
            `V_WR: begin
                state <= 2;
                get_instr<=0;
                //get_instr_addr<=get_instr_addr+1'b1;
                case(src1_id) 
                `VRF_0: begin vrf_wr_enable_mvu_0 <= 1'b0;
                vrf_addr_wr <= op1_address; 
                end
                `VRF_1: begin vrf_wr_enable_mvu_1 <= 1'b0;
                vrf_addr_wr <= op1_address; 
                end
                `VRF_2: begin vrf_wr_enable_mvu_2 <= 1'b0;
                vrf_addr_wr <= op1_address; 
                end
                `VRF_3: begin vrf_wr_enable_mvu_3 <= 1'b0;
                vrf_addr_wr <= op1_address; 
                end

                `VRF_4: begin vrf_wr_enable_mfu_add_0 <= 1'b0;
                vrf_addr_wr_mfu_add_0 <= op1_address; 
                end
                
                `VRF_5: begin vrf_wr_enable_mfu_mul_0 <= 1'b0;
                vrf_addr_wr_mfu_mul_0 <= op1_address; 
                end
                
                `VRF_6: begin vrf_wr_enable_mfu_add_1 <= 1'b0;
                vrf_addr_wr_mfu_add_1 <= op1_address; 
                end
                
                `VRF_7: begin 
                vrf_wr_enable_mfu_mul_1 <= 1'b0;
                vrf_addr_wr_mfu_mul_1 <= op1_address; 
                end
                
                `VRF_MUXED: begin 
                vrf_muxed_wr_enable_dram <= 1'b0;
                vrf_muxed_wr_addr_dram <= op1_address; 
                end
                
                default: begin 
                vrf_wr_enable_mvu_0 <= 1'bX;
                output_data_to_dram <= 'bX;
                end
    
                endcase
                
                dram_addr_wr <= dstn_address;
                dram_write_enable <= 1'b1;
            end
            `M_WR: begin
                state <= 2;
                get_instr<=0;
    
                case(src1_id) 
                `MRF_0: begin mrf_we_for_dram[0] <= 1'b0;
                mrf_addr_for_dram[1*`MRF_AWIDTH-1:0*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_1: begin mrf_we_for_dram[1] <= 1'b0;
                mrf_addr_for_dram[2*`MRF_AWIDTH-1:1*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_2: begin mrf_we_for_dram[2] <= 1'b0;
                mrf_addr_for_dram[3*`MRF_AWIDTH-1:2*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_3: begin mrf_we_for_dram[3] <= 1'b0;
                mrf_addr_for_dram[4*`MRF_AWIDTH-1:3*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_4: begin mrf_we_for_dram[4] <= 1'b0;
                mrf_addr_for_dram[5*`MRF_AWIDTH-1:4*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_5: begin mrf_we_for_dram[5] <= 1'b0;
                mrf_addr_for_dram[6*`MRF_AWIDTH-1:5*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_6: begin mrf_we_for_dram[6] <= 1'b0;
                mrf_addr_for_dram[7*`MRF_AWIDTH-1:6*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_7: begin mrf_we_for_dram[7] <= 1'b0;
                mrf_addr_for_dram[8*`MRF_AWIDTH-1:7*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_8: begin mrf_we_for_dram[8] <= 1'b0;
                mrf_addr_for_dram[9*`MRF_AWIDTH-1:8*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_9: begin mrf_we_for_dram[9] <= 1'b0;
                mrf_addr_for_dram[10*`MRF_AWIDTH-1:9*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_10: begin mrf_we_for_dram[10] <= 1'b0;
                mrf_addr_for_dram[11*`MRF_AWIDTH-1:10*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_11: begin mrf_we_for_dram[11] <= 1'b0;
                mrf_addr_for_dram[12*`MRF_AWIDTH-1:11*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_12: begin mrf_we_for_dram[12] <= 1'b0;
                mrf_addr_for_dram[13*`MRF_AWIDTH-1:12*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_13: begin mrf_we_for_dram[13] <= 1'b0;
                mrf_addr_for_dram[14*`MRF_AWIDTH-1:13*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_14: begin mrf_we_for_dram[14] <= 1'b0;
                mrf_addr_for_dram[15*`MRF_AWIDTH-1:14*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_15: begin mrf_we_for_dram[15] <= 1'b0;
                mrf_addr_for_dram[16*`MRF_AWIDTH-1:15*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_16: begin mrf_we_for_dram[16] <= 1'b0;
                mrf_addr_for_dram[17*`MRF_AWIDTH-1:16*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_17: begin mrf_we_for_dram[17] <= 1'b0;
                mrf_addr_for_dram[18*`MRF_AWIDTH-1:17*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_18: begin mrf_we_for_dram[18] <= 1'b0;
                mrf_addr_for_dram[19*`MRF_AWIDTH-1:18*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_19: begin mrf_we_for_dram[19] <= 1'b0;
                mrf_addr_for_dram[20*`MRF_AWIDTH-1:19*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_20: begin mrf_we_for_dram[20] <= 1'b0;
                mrf_addr_for_dram[21*`MRF_AWIDTH-1:20*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_21: begin mrf_we_for_dram[21] <= 1'b0;
                mrf_addr_for_dram[22*`MRF_AWIDTH-1:21*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_22: begin mrf_we_for_dram[22] <= 1'b0;
                mrf_addr_for_dram[23*`MRF_AWIDTH-1:22*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_23: begin mrf_we_for_dram[23] <= 1'b0;
                mrf_addr_for_dram[24*`MRF_AWIDTH-1:23*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_24: begin mrf_we_for_dram[24] <= 1'b0;
                mrf_addr_for_dram[25*`MRF_AWIDTH-1:24*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_25: begin mrf_we_for_dram[25] <= 1'b0;
                mrf_addr_for_dram[26*`MRF_AWIDTH-1:25*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_26: begin mrf_we_for_dram[26] <= 1'b0;
                mrf_addr_for_dram[27*`MRF_AWIDTH-1:26*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_27: begin mrf_we_for_dram[27] <= 1'b0;
                mrf_addr_for_dram[28*`MRF_AWIDTH-1:27*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_28: begin mrf_we_for_dram[28] <= 1'b0;
                mrf_addr_for_dram[29*`MRF_AWIDTH-1:28*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_29: begin mrf_we_for_dram[29] <= 1'b0;
                mrf_addr_for_dram[30*`MRF_AWIDTH-1:29*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_30: begin mrf_we_for_dram[30] <= 1'b0;
                mrf_addr_for_dram[31*`MRF_AWIDTH-1:30*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_31: begin mrf_we_for_dram[31] <= 1'b0;
                mrf_addr_for_dram[32*`MRF_AWIDTH-1:31*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_32: begin mrf_we_for_dram[32] <= 1'b0;
                mrf_addr_for_dram[33*`MRF_AWIDTH-1:32*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_33: begin mrf_we_for_dram[33] <= 1'b0;
                mrf_addr_for_dram[34*`MRF_AWIDTH-1:33*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_34: begin mrf_we_for_dram[34] <= 1'b0;
                mrf_addr_for_dram[35*`MRF_AWIDTH-1:34*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_35: begin mrf_we_for_dram[35] <= 1'b0;
                mrf_addr_for_dram[36*`MRF_AWIDTH-1:35*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_36: begin mrf_we_for_dram[36] <= 1'b0;
                mrf_addr_for_dram[37*`MRF_AWIDTH-1:36*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_37: begin mrf_we_for_dram[37] <= 1'b0;
                mrf_addr_for_dram[38*`MRF_AWIDTH-1:37*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_38: begin mrf_we_for_dram[38] <= 1'b0;
                mrf_addr_for_dram[39*`MRF_AWIDTH-1:38*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_39: begin mrf_we_for_dram[39] <= 1'b0;
                mrf_addr_for_dram[40*`MRF_AWIDTH-1:39*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_40: begin mrf_we_for_dram[40] <= 1'b0;
                mrf_addr_for_dram[41*`MRF_AWIDTH-1:40*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_41: begin mrf_we_for_dram[41] <= 1'b0;
                mrf_addr_for_dram[42*`MRF_AWIDTH-1:41*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_42: begin mrf_we_for_dram[42] <= 1'b0;
                mrf_addr_for_dram[43*`MRF_AWIDTH-1:42*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_43: begin mrf_we_for_dram[43] <= 1'b0;
                mrf_addr_for_dram[44*`MRF_AWIDTH-1:43*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_44: begin mrf_we_for_dram[44] <= 1'b0;
                mrf_addr_for_dram[45*`MRF_AWIDTH-1:44*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_45: begin mrf_we_for_dram[45] <= 1'b0;
                mrf_addr_for_dram[46*`MRF_AWIDTH-1:45*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_46: begin mrf_we_for_dram[46] <= 1'b0;
                mrf_addr_for_dram[47*`MRF_AWIDTH-1:46*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_47: begin mrf_we_for_dram[47] <= 1'b0;
                mrf_addr_for_dram[48*`MRF_AWIDTH-1:47*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_48: begin mrf_we_for_dram[48] <= 1'b0;
                mrf_addr_for_dram[49*`MRF_AWIDTH-1:48*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_49: begin mrf_we_for_dram[49] <= 1'b0;
                mrf_addr_for_dram[50*`MRF_AWIDTH-1:49*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_50: begin mrf_we_for_dram[50] <= 1'b0;
                mrf_addr_for_dram[51*`MRF_AWIDTH-1:50*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_51: begin mrf_we_for_dram[51] <= 1'b0;
                mrf_addr_for_dram[52*`MRF_AWIDTH-1:51*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_52: begin mrf_we_for_dram[52] <= 1'b0;
                mrf_addr_for_dram[53*`MRF_AWIDTH-1:52*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_53: begin mrf_we_for_dram[53] <= 1'b0;
                mrf_addr_for_dram[54*`MRF_AWIDTH-1:53*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_54: begin mrf_we_for_dram[54] <= 1'b0;
                mrf_addr_for_dram[55*`MRF_AWIDTH-1:54*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_55: begin mrf_we_for_dram[55] <= 1'b0;
                mrf_addr_for_dram[56*`MRF_AWIDTH-1:55*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_56: begin mrf_we_for_dram[56] <= 1'b0;
                mrf_addr_for_dram[57*`MRF_AWIDTH-1:56*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_57: begin mrf_we_for_dram[57] <= 1'b0;
                mrf_addr_for_dram[58*`MRF_AWIDTH-1:57*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_58: begin mrf_we_for_dram[58] <= 1'b0;
                mrf_addr_for_dram[59*`MRF_AWIDTH-1:58*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_59: begin mrf_we_for_dram[59] <= 1'b0;
                mrf_addr_for_dram[60*`MRF_AWIDTH-1:59*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_60: begin mrf_we_for_dram[60] <= 1'b0;
                mrf_addr_for_dram[61*`MRF_AWIDTH-1:60*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_61: begin mrf_we_for_dram[61] <= 1'b0;
                mrf_addr_for_dram[62*`MRF_AWIDTH-1:61*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_62: begin mrf_we_for_dram[62] <= 1'b0;
                mrf_addr_for_dram[63*`MRF_AWIDTH-1:62*`MRF_AWIDTH] <= op1_address; 
                end
                `MRF_63: begin mrf_we_for_dram[63] <= 1'b0;
                mrf_addr_for_dram[64*`MRF_AWIDTH-1:63*`MRF_AWIDTH] <= op1_address; 
                end
                default: begin mrf_we_for_dram <= 'bX;
                mrf_addr_for_dram <= 'bX;
                end
                endcase
                
                dram_addr_wr <= dstn_address;
                dram_write_enable <= 1'b1;
            end
            `V_RD: begin
                state <= 2;
                get_instr<=0;
                dram_addr_wr <= op1_address;
                dram_write_enable <= 1'b0;
                
            end
            //CHANGE NAMING CONVENTION FOR WRITE AND READ TO STORE AND LOAD
            //ADD COMMENTS FOR SRC AND DESTINATION
            `M_RD: begin
                state <= 2;
                get_instr<=0;
                dram_addr_wr <= op1_address;
                dram_write_enable <= 1'b0;
            end
            `MV_MUL: begin
              //op1_id is don't care for this instructions
    
               state <= 2;
               get_instr<=1'b0;
               start_mv_mul <= 1'b1;
               mrf_addr_wr[(1*`MRF_AWIDTH)-1:0*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(2*`MRF_AWIDTH)-1:1*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(3*`MRF_AWIDTH)-1:2*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(4*`MRF_AWIDTH)-1:3*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(5*`MRF_AWIDTH)-1:4*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(6*`MRF_AWIDTH)-1:5*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(7*`MRF_AWIDTH)-1:6*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(8*`MRF_AWIDTH)-1:7*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(9*`MRF_AWIDTH)-1:8*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(10*`MRF_AWIDTH)-1:9*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(11*`MRF_AWIDTH)-1:10*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(12*`MRF_AWIDTH)-1:11*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(13*`MRF_AWIDTH)-1:12*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(14*`MRF_AWIDTH)-1:13*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(15*`MRF_AWIDTH)-1:14*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(16*`MRF_AWIDTH)-1:15*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(17*`MRF_AWIDTH)-1:16*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(18*`MRF_AWIDTH)-1:17*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(19*`MRF_AWIDTH)-1:18*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(20*`MRF_AWIDTH)-1:19*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(21*`MRF_AWIDTH)-1:20*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(22*`MRF_AWIDTH)-1:21*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(23*`MRF_AWIDTH)-1:22*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(24*`MRF_AWIDTH)-1:23*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(25*`MRF_AWIDTH)-1:24*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(26*`MRF_AWIDTH)-1:25*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(27*`MRF_AWIDTH)-1:26*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(28*`MRF_AWIDTH)-1:27*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(29*`MRF_AWIDTH)-1:28*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(30*`MRF_AWIDTH)-1:29*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(31*`MRF_AWIDTH)-1:30*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(32*`MRF_AWIDTH)-1:31*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(33*`MRF_AWIDTH)-1:32*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(34*`MRF_AWIDTH)-1:33*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(35*`MRF_AWIDTH)-1:34*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(36*`MRF_AWIDTH)-1:35*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(37*`MRF_AWIDTH)-1:36*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(38*`MRF_AWIDTH)-1:37*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(39*`MRF_AWIDTH)-1:38*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(40*`MRF_AWIDTH)-1:39*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(41*`MRF_AWIDTH)-1:40*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(42*`MRF_AWIDTH)-1:41*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(43*`MRF_AWIDTH)-1:42*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(44*`MRF_AWIDTH)-1:43*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(45*`MRF_AWIDTH)-1:44*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(46*`MRF_AWIDTH)-1:45*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(47*`MRF_AWIDTH)-1:46*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(48*`MRF_AWIDTH)-1:47*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(49*`MRF_AWIDTH)-1:48*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(50*`MRF_AWIDTH)-1:49*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(51*`MRF_AWIDTH)-1:50*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(52*`MRF_AWIDTH)-1:51*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(53*`MRF_AWIDTH)-1:52*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(54*`MRF_AWIDTH)-1:53*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(55*`MRF_AWIDTH)-1:54*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(56*`MRF_AWIDTH)-1:55*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(57*`MRF_AWIDTH)-1:56*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(58*`MRF_AWIDTH)-1:57*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(59*`MRF_AWIDTH)-1:58*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(60*`MRF_AWIDTH)-1:59*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(61*`MRF_AWIDTH)-1:60*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(62*`MRF_AWIDTH)-1:61*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(63*`MRF_AWIDTH)-1:62*`MRF_AWIDTH] <= op1_address;
               mrf_addr_wr[(64*`MRF_AWIDTH)-1:63*`MRF_AWIDTH] <= op1_address;
               vrf_addr_read <= op2_address;  
               vrf_readn_enable_mvu_0 <= 1'b0;
               vrf_readn_enable_mvu_1 <= 1'b0;
               vrf_readn_enable_mvu_2 <= 1'b0;
               vrf_readn_enable_mvu_3 <= 1'b0;
               mrf_wr_enable <= 0;
            end
            `VV_ADD:begin
            
              //MFU_STAGE-0 DESIGNATED FOR ELTWISE ADD
              state <= 2;
              get_instr <= 1'b0;
              operation <= `ELT_WISE_ADD;      //NOTE - 2nd VRF INDEX IS FOR ADD UNITS ELT WISE
              activation <= 0;

              case(src1_id) 
              
               `VRF_4: begin 
                start_mfu_0 <= 1'b1;

                vrf_muxed_readn_enable <= 1'b0;
                vrf_muxed_read_addr <= op2_address;

                in_data_available_mfu_0 <= 1'b1;
                vrf_addr_read_mfu_add_0 <= op1_address;
                vrf_readn_enable_mfu_add_0 <= 1'b0; 
               end
              
               
               `VRF_6: begin 
                start_mfu_1 <= 1'b1;
                in_data_available_mfu_1 <= 1'b1;
                vrf_addr_read_mfu_add_1 <= op1_address;
                vrf_readn_enable_mfu_add_1 <= 1'b0; 
               end
               
               
               default: begin
                start_mfu_0 <= 1'bX;
                in_data_available_mfu_0 <= 1'bX;
                vrf_addr_read_mfu_add_0 <= 'bX;
                vrf_readn_enable_mfu_add_0 <= 1'bX; 
                vrf_addr_read_mfu_add_1 <= 'bX;
                vrf_readn_enable_mfu_add_1 <= 1'bX;
               end
               
             endcase

            end
            `VV_SUB:begin
            
              //MFU_STAGE-0 DESIGNATED FOR ELTWISE ADD
              state <= 2;
              get_instr<=1'b0;
              operation<=`ELT_WISE_ADD;      //NOTE - 2nd VRF INDEX IS FOR ADD UNITS ELT WISE

              activation <= 1;

              case(src1_id) 
              
               `VRF_4: begin 
                start_mfu_0 <= 1'b1;

                vrf_muxed_readn_enable <= 1'b0;
                vrf_muxed_read_addr <= op2_address;

                in_data_available_mfu_0 <= 1'b1;
                vrf_addr_read_mfu_add_0 <= op1_address;
                vrf_readn_enable_mfu_add_0 <= 1'b0; 
               end
              
               
               `VRF_6: begin 
                start_mfu_1 <= 1'b1;
                in_data_available_mfu_1 <= 1'b1;
                vrf_addr_read_mfu_add_1 <= op1_address;
                vrf_readn_enable_mfu_add_1 <= 1'b0; 
               end
               
               
               default: begin
                start_mfu_0 <= 1'bX;
                in_data_available_mfu_0 <= 1'bX;
                vrf_addr_read_mfu_add_0 <= 'bX;
                vrf_readn_enable_mfu_add_0 <= 1'bX; 
                vrf_addr_read_mfu_add_1 <= 'bX;
                vrf_readn_enable_mfu_add_1 <= 1'bX;
               end
               
             endcase

            end
            `VV_MUL:begin
             state <= 2;
             get_instr<=1'b0;

              operation<=`ELT_WISE_MULTIPLY;     //NOTE - 3RD VRF INDEX IS FOR ADD UNITS ELT WISE
              case(src1_id) 
              
               `VRF_5: begin 
                start_mfu_0 <= 1'b1;

                vrf_muxed_readn_enable <= 1'b0;
                vrf_muxed_read_addr <= op2_address;

                in_data_available_mfu_0 <= 1'b1;
                vrf_addr_read_mfu_mul_0 <= op1_address;
                vrf_readn_enable_mfu_mul_0 <= 1'b0; 
               end
               
               `VRF_7: begin 
                start_mfu_1 <= 1'b1;
                in_data_available_mfu_1 <= 1'b1;
                vrf_addr_read_mfu_mul_1 <= op1_address;
                vrf_readn_enable_mfu_mul_1 <= 1'b0; 
               end
  
               default: begin
                start_mfu_0 <= 1'bX;
                in_data_available_mfu_0 <= 1'bX;
                vrf_addr_read_mfu_mul_0 <= 'bX;
                vrf_readn_enable_mfu_mul_0 <= 1'bX; 
                vrf_addr_read_mfu_mul_1 <= 'bX;
                vrf_readn_enable_mfu_mul_1 <= 1'bX; 
               end
               
             endcase
             
            end
            `V_RELU:begin

              get_instr<=1'b0;
              case(src1_id) 
              
              `MFU_0: begin 
                start_mfu_0<=1'b1;
                in_data_available_mfu_0<=1'b1;

                vrf_muxed_readn_enable <= 1'b0;
                vrf_muxed_read_addr <= op2_address;
               end
               
               `MFU_1: begin
                 start_mfu_1<=1'b1;
                 in_data_available_mfu_1<=1'b1;
                end
                
                default: begin
                start_mfu_0<=1'bX;
                in_data_available_mfu_0<=1'bX;
                end
               
              endcase
              operation<=`ACTIVATION;
              activation<=`RELU;
              state <= 2;

            end
            `V_SIGM:begin

              get_instr<=1'b0;
              case(src1_id) 
              
              `MFU_0: begin 
                start_mfu_0<=1'b1;
                in_data_available_mfu_0<=1'b1;

                vrf_muxed_readn_enable <= 1'b0;
                vrf_muxed_read_addr <= op2_address;
               end
               
               `MFU_1: begin
                 start_mfu_1<=1'b1;
                 in_data_available_mfu_1<=1'b1;
                end
                
                default: begin
                start_mfu_0<=1'bX;
                in_data_available_mfu_0<=1'bX;
                end
                
              endcase
              operation<=`ACTIVATION;
              activation<=`SIGM;
              state <= 2;
            end
            `V_TANH:begin
            //dram_write_enable <= bypass_id[0];
              get_instr<=1'b0;
              case(src1_id) 
              
              `MFU_0: begin 
                start_mfu_0<=1'b1;
                in_data_available_mfu_0<=1'b1;

                vrf_muxed_readn_enable <= 1'b0;
                vrf_muxed_read_addr <= op2_address;
               end
               
               `MFU_1: begin
                 start_mfu_1<=1'b1;
                 in_data_available_mfu_1<=1'b1;
                end
                
                default: begin
                start_mfu_0<=1'bX;
                in_data_available_mfu_0<=1'bX;
                end
                
              endcase
              operation<=`ACTIVATION;
              activation<=`TANH;
              state <= 2;

            end
            `END_CHAIN :begin

              start_mv_mul<=1'b0;
              get_instr<=1'b0;

              in_data_available_mfu_0<=1'b0;
              start_mfu_0<=1'b0;
              
              in_data_available_mfu_1<=1'b0;
              start_mfu_1<=1'b0;
              
              mrf_wr_enable<=0;


              vrf_wr_enable_mvu_0<='b0;
              vrf_readn_enable_mvu_0 <= 'b0;


              vrf_wr_enable_mvu_1<='b0;
              vrf_readn_enable_mvu_1 <= 'b0;


              vrf_wr_enable_mvu_2<='b0;
              vrf_readn_enable_mvu_2 <= 'b0;


              vrf_wr_enable_mvu_3<='b0;
              vrf_readn_enable_mvu_3 <= 'b0;

              
              vrf_wr_enable_mfu_add_0 <= 0;
              vrf_wr_enable_mfu_mul_0 <= 0;
              vrf_wr_enable_mfu_add_1 <= 0;
              vrf_wr_enable_mfu_mul_1 <= 0;

              vrf_muxed_readn_enable <= 1'b0;
              vrf_muxed_wr_addr_dram <= 1'b0;
              
              vrf_readn_enable_mfu_add_0 <= 0;
              vrf_readn_enable_mfu_mul_0 <= 0;
              vrf_readn_enable_mfu_add_1 <= 0;
              vrf_readn_enable_mfu_mul_1 <= 0;
              
              //orf_addr_increment<=1'b0;
              mrf_addr_wr <= 0;
              dram_write_enable <=  1'b0;
              state <= 1;
            end
          endcase          
         end
         else begin //EXECUTE
         
            case(opcode) 
            `V_WR: begin
                state <= 0;
                get_instr<=1'b1;
                get_instr_addr<=get_instr_addr+1'b1;
        
                case(src1_id) 

                `VRF_0: begin 
                output_data_to_dram <= vrf_out_data_mvu_0;
                end
                `VRF_1: begin 
                output_data_to_dram <= vrf_out_data_mvu_1;
                end
                `VRF_2: begin 
                output_data_to_dram <= vrf_out_data_mvu_2;
                end
                `VRF_3: begin 
                output_data_to_dram <= vrf_out_data_mvu_3;
                end
    
                `VRF_4: begin  
                output_data_to_dram <= vrf_out_data_mfu_add_0;
                end
                
                `VRF_5: begin 
                output_data_to_dram <= vrf_out_data_mfu_mul_0;
                end
                
                `VRF_6: begin 
                    output_data_to_dram <= vrf_out_data_mfu_add_1;
                end
                
                `VRF_7: begin 
                    output_data_to_dram <= vrf_out_data_mfu_mul_1;
                end
                
               `VRF_MUXED: begin 
                    output_data_to_dram <= vrf_muxed_out_data_dram;
                end
                default: begin 
                    output_data_to_dram <= 'bX;
                end
              endcase
              
            end
            `M_WR: begin
                state <= 0;
                get_instr<=1'b1;
                get_instr_addr<=get_instr_addr+1'b1;
        
                case(src1_id) 

                `MRF_0: begin 
                output_data_to_dram <= mrf_outa_to_dram[1*`MRF_DWIDTH-1:0*`MRF_DWIDTH];
                end
                `MRF_1: begin 
                output_data_to_dram <= mrf_outa_to_dram[2*`MRF_DWIDTH-1:1*`MRF_DWIDTH];
                end
                `MRF_2: begin 
                output_data_to_dram <= mrf_outa_to_dram[3*`MRF_DWIDTH-1:2*`MRF_DWIDTH];
                end
                `MRF_3: begin 
                output_data_to_dram <= mrf_outa_to_dram[4*`MRF_DWIDTH-1:3*`MRF_DWIDTH];
                end
                `MRF_4: begin 
                output_data_to_dram <= mrf_outa_to_dram[5*`MRF_DWIDTH-1:4*`MRF_DWIDTH];
                end
                `MRF_5: begin 
                output_data_to_dram <= mrf_outa_to_dram[6*`MRF_DWIDTH-1:5*`MRF_DWIDTH];
                end
                `MRF_6: begin 
                output_data_to_dram <= mrf_outa_to_dram[7*`MRF_DWIDTH-1:6*`MRF_DWIDTH];
                end
                `MRF_7: begin 
                output_data_to_dram <= mrf_outa_to_dram[8*`MRF_DWIDTH-1:7*`MRF_DWIDTH];
                end
                `MRF_8: begin 
                output_data_to_dram <= mrf_outa_to_dram[9*`MRF_DWIDTH-1:8*`MRF_DWIDTH];
                end
                `MRF_9: begin 
                output_data_to_dram <= mrf_outa_to_dram[10*`MRF_DWIDTH-1:9*`MRF_DWIDTH];
                end
                `MRF_10: begin 
                output_data_to_dram <= mrf_outa_to_dram[11*`MRF_DWIDTH-1:10*`MRF_DWIDTH];
                end
                `MRF_11: begin 
                output_data_to_dram <= mrf_outa_to_dram[12*`MRF_DWIDTH-1:11*`MRF_DWIDTH];
                end
                `MRF_12: begin 
                output_data_to_dram <= mrf_outa_to_dram[13*`MRF_DWIDTH-1:12*`MRF_DWIDTH];
                end
                `MRF_13: begin 
                output_data_to_dram <= mrf_outa_to_dram[14*`MRF_DWIDTH-1:13*`MRF_DWIDTH];
                end
                `MRF_14: begin 
                output_data_to_dram <= mrf_outa_to_dram[15*`MRF_DWIDTH-1:14*`MRF_DWIDTH];
                end
                `MRF_15: begin 
                output_data_to_dram <= mrf_outa_to_dram[16*`MRF_DWIDTH-1:15*`MRF_DWIDTH];
                end
                `MRF_16: begin 
                output_data_to_dram <= mrf_outa_to_dram[17*`MRF_DWIDTH-1:16*`MRF_DWIDTH];
                end
                `MRF_17: begin 
                output_data_to_dram <= mrf_outa_to_dram[18*`MRF_DWIDTH-1:17*`MRF_DWIDTH];
                end
                `MRF_18: begin 
                output_data_to_dram <= mrf_outa_to_dram[19*`MRF_DWIDTH-1:18*`MRF_DWIDTH];
                end
                `MRF_19: begin 
                output_data_to_dram <= mrf_outa_to_dram[20*`MRF_DWIDTH-1:19*`MRF_DWIDTH];
                end
                `MRF_20: begin 
                output_data_to_dram <= mrf_outa_to_dram[21*`MRF_DWIDTH-1:20*`MRF_DWIDTH];
                end
                `MRF_21: begin 
                output_data_to_dram <= mrf_outa_to_dram[22*`MRF_DWIDTH-1:21*`MRF_DWIDTH];
                end
                `MRF_22: begin 
                output_data_to_dram <= mrf_outa_to_dram[23*`MRF_DWIDTH-1:22*`MRF_DWIDTH];
                end
                `MRF_23: begin 
                output_data_to_dram <= mrf_outa_to_dram[24*`MRF_DWIDTH-1:23*`MRF_DWIDTH];
                end
                `MRF_24: begin 
                output_data_to_dram <= mrf_outa_to_dram[25*`MRF_DWIDTH-1:24*`MRF_DWIDTH];
                end
                `MRF_25: begin 
                output_data_to_dram <= mrf_outa_to_dram[26*`MRF_DWIDTH-1:25*`MRF_DWIDTH];
                end
                `MRF_26: begin 
                output_data_to_dram <= mrf_outa_to_dram[27*`MRF_DWIDTH-1:26*`MRF_DWIDTH];
                end
                `MRF_27: begin 
                output_data_to_dram <= mrf_outa_to_dram[28*`MRF_DWIDTH-1:27*`MRF_DWIDTH];
                end
                `MRF_28: begin 
                output_data_to_dram <= mrf_outa_to_dram[29*`MRF_DWIDTH-1:28*`MRF_DWIDTH];
                end
                `MRF_29: begin 
                output_data_to_dram <= mrf_outa_to_dram[30*`MRF_DWIDTH-1:29*`MRF_DWIDTH];
                end
                `MRF_30: begin 
                output_data_to_dram <= mrf_outa_to_dram[31*`MRF_DWIDTH-1:30*`MRF_DWIDTH];
                end
                `MRF_31: begin 
                output_data_to_dram <= mrf_outa_to_dram[32*`MRF_DWIDTH-1:31*`MRF_DWIDTH];
                end
                `MRF_32: begin 
                output_data_to_dram <= mrf_outa_to_dram[33*`MRF_DWIDTH-1:32*`MRF_DWIDTH];
                end
                `MRF_33: begin 
                output_data_to_dram <= mrf_outa_to_dram[34*`MRF_DWIDTH-1:33*`MRF_DWIDTH];
                end
                `MRF_34: begin 
                output_data_to_dram <= mrf_outa_to_dram[35*`MRF_DWIDTH-1:34*`MRF_DWIDTH];
                end
                `MRF_35: begin 
                output_data_to_dram <= mrf_outa_to_dram[36*`MRF_DWIDTH-1:35*`MRF_DWIDTH];
                end
                `MRF_36: begin 
                output_data_to_dram <= mrf_outa_to_dram[37*`MRF_DWIDTH-1:36*`MRF_DWIDTH];
                end
                `MRF_37: begin 
                output_data_to_dram <= mrf_outa_to_dram[38*`MRF_DWIDTH-1:37*`MRF_DWIDTH];
                end
                `MRF_38: begin 
                output_data_to_dram <= mrf_outa_to_dram[39*`MRF_DWIDTH-1:38*`MRF_DWIDTH];
                end
                `MRF_39: begin 
                output_data_to_dram <= mrf_outa_to_dram[40*`MRF_DWIDTH-1:39*`MRF_DWIDTH];
                end
                `MRF_40: begin 
                output_data_to_dram <= mrf_outa_to_dram[41*`MRF_DWIDTH-1:40*`MRF_DWIDTH];
                end
                `MRF_41: begin 
                output_data_to_dram <= mrf_outa_to_dram[42*`MRF_DWIDTH-1:41*`MRF_DWIDTH];
                end
                `MRF_42: begin 
                output_data_to_dram <= mrf_outa_to_dram[43*`MRF_DWIDTH-1:42*`MRF_DWIDTH];
                end
                `MRF_43: begin 
                output_data_to_dram <= mrf_outa_to_dram[44*`MRF_DWIDTH-1:43*`MRF_DWIDTH];
                end
                `MRF_44: begin 
                output_data_to_dram <= mrf_outa_to_dram[45*`MRF_DWIDTH-1:44*`MRF_DWIDTH];
                end
                `MRF_45: begin 
                output_data_to_dram <= mrf_outa_to_dram[46*`MRF_DWIDTH-1:45*`MRF_DWIDTH];
                end
                `MRF_46: begin 
                output_data_to_dram <= mrf_outa_to_dram[47*`MRF_DWIDTH-1:46*`MRF_DWIDTH];
                end
                `MRF_47: begin 
                output_data_to_dram <= mrf_outa_to_dram[48*`MRF_DWIDTH-1:47*`MRF_DWIDTH];
                end
                `MRF_48: begin 
                output_data_to_dram <= mrf_outa_to_dram[49*`MRF_DWIDTH-1:48*`MRF_DWIDTH];
                end
                `MRF_49: begin 
                output_data_to_dram <= mrf_outa_to_dram[50*`MRF_DWIDTH-1:49*`MRF_DWIDTH];
                end
                `MRF_50: begin 
                output_data_to_dram <= mrf_outa_to_dram[51*`MRF_DWIDTH-1:50*`MRF_DWIDTH];
                end
                `MRF_51: begin 
                output_data_to_dram <= mrf_outa_to_dram[52*`MRF_DWIDTH-1:51*`MRF_DWIDTH];
                end
                `MRF_52: begin 
                output_data_to_dram <= mrf_outa_to_dram[53*`MRF_DWIDTH-1:52*`MRF_DWIDTH];
                end
                `MRF_53: begin 
                output_data_to_dram <= mrf_outa_to_dram[54*`MRF_DWIDTH-1:53*`MRF_DWIDTH];
                end
                `MRF_54: begin 
                output_data_to_dram <= mrf_outa_to_dram[55*`MRF_DWIDTH-1:54*`MRF_DWIDTH];
                end
                `MRF_55: begin 
                output_data_to_dram <= mrf_outa_to_dram[56*`MRF_DWIDTH-1:55*`MRF_DWIDTH];
                end
                `MRF_56: begin 
                output_data_to_dram <= mrf_outa_to_dram[57*`MRF_DWIDTH-1:56*`MRF_DWIDTH];
                end
                `MRF_57: begin 
                output_data_to_dram <= mrf_outa_to_dram[58*`MRF_DWIDTH-1:57*`MRF_DWIDTH];
                end
                `MRF_58: begin 
                output_data_to_dram <= mrf_outa_to_dram[59*`MRF_DWIDTH-1:58*`MRF_DWIDTH];
                end
                `MRF_59: begin 
                output_data_to_dram <= mrf_outa_to_dram[60*`MRF_DWIDTH-1:59*`MRF_DWIDTH];
                end
                `MRF_60: begin 
                output_data_to_dram <= mrf_outa_to_dram[61*`MRF_DWIDTH-1:60*`MRF_DWIDTH];
                end
                `MRF_61: begin 
                output_data_to_dram <= mrf_outa_to_dram[62*`MRF_DWIDTH-1:61*`MRF_DWIDTH];
                end
                `MRF_62: begin 
                output_data_to_dram <= mrf_outa_to_dram[63*`MRF_DWIDTH-1:62*`MRF_DWIDTH];
                end
                `MRF_63: begin 
                output_data_to_dram <= mrf_outa_to_dram[64*`MRF_DWIDTH-1:63*`MRF_DWIDTH];
                end
                default: begin 
                    output_data_to_dram <= 'bX;
                end
              endcase
              
            end
            `V_RD: begin
                state <= 0;
                get_instr<=1'b1;
                get_instr_addr<=get_instr_addr+1'b1;
                vrf_in_data <= input_data_from_dram;
                case(dstn_id) 
                  `VRF_0: begin 
                  vrf_wr_enable_mvu_0 <= 1'b1;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  
                  vrf_addr_wr <= dstn_address;
                  end
                  `VRF_1: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b1;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  
                  vrf_addr_wr <= dstn_address;
                  end
                  `VRF_2: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b1;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  
                  vrf_addr_wr <= dstn_address;
                  end
                  `VRF_3: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b1;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  
                  vrf_addr_wr <= dstn_address;
                  end
                  `VRF_4: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b1;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  
                  vrf_addr_wr_mfu_add_0 <= dstn_address;
                  
                  end
                  
                  `VRF_5: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b1;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  
                  vrf_addr_wr_mfu_mul_0 <= dstn_address;
                  
                  end
                  
                  `VRF_6: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b1;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  
                  vrf_addr_wr_mfu_add_1 <= dstn_address;
                  end
                  
                  `VRF_7: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b1;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  
                  vrf_addr_wr_mfu_mul_1 <= dstn_address;
                  end
                  
                  `VRF_MUXED: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b1;
                  
                   
                  vrf_muxed_wr_addr_dram <= dstn_address;
                  end
    
                  default: begin 
                  vrf_wr_enable_mvu_0 <= 1'bX;
                  vrf_wr_enable_mvu_1 <= 1'bX;
                  vrf_wr_enable_mvu_2 <= 1'bX;
                  vrf_wr_enable_mvu_3 <= 1'bX;
                  vrf_wr_enable_mfu_add_0 <= 1'bX;
                  vrf_wr_enable_mfu_mul_0 <= 1'bX;
                  vrf_wr_enable_mfu_add_1 <= 1'bX;
                  vrf_wr_enable_mfu_mul_1 <= 1'bX;
                  vrf_muxed_wr_enable_dram <= 1'bX;
 
                  end
                endcase
/*
                vrf_wr_enable_mvu_0 <= 1'b0;
                vrf_wr_enable_mvu_1 <= 1'b0;
                vrf_wr_enable_mvu_2 <= 1'b0;
                vrf_wr_enable_mvu_3 <= 1'b0;
                vrf_wr_enable_mfu_add_0 <= 1'b0;
                vrf_wr_enable_mfu_mul_0 <= 1'b0;
                vrf_wr_enable_mfu_add_1 <= 1'b0;
                vrf_wr_enable_mfu_mul_1 <= 1'b0;
                vrf_muxed_wr_enable_dram <= 1'b0;
*/
                
            end
            `M_RD: begin
                state <= 0;
                get_instr<=1'b1;
                get_instr_addr<=get_instr_addr+1'b1;
            
                case(dstn_id) 
                  `MRF_0: begin 
                    mrf_we_for_dram[0] <= 1;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[1*`MRF_DWIDTH-1:0*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[1*`MRF_AWIDTH-1:0*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_1: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 1;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[2*`MRF_DWIDTH-1:1*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[2*`MRF_AWIDTH-1:1*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_2: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 1;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[3*`MRF_DWIDTH-1:2*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[3*`MRF_AWIDTH-1:2*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_3: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 1;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[4*`MRF_DWIDTH-1:3*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[4*`MRF_AWIDTH-1:3*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_4: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 1;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[5*`MRF_DWIDTH-1:4*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[5*`MRF_AWIDTH-1:4*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_5: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 1;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[6*`MRF_DWIDTH-1:5*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[6*`MRF_AWIDTH-1:5*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_6: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 1;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[7*`MRF_DWIDTH-1:6*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[7*`MRF_AWIDTH-1:6*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_7: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 1;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[8*`MRF_DWIDTH-1:7*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[8*`MRF_AWIDTH-1:7*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_8: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 1;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[9*`MRF_DWIDTH-1:8*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[9*`MRF_AWIDTH-1:8*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_9: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 1;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[10*`MRF_DWIDTH-1:9*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[10*`MRF_AWIDTH-1:9*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_10: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 1;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[11*`MRF_DWIDTH-1:10*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[11*`MRF_AWIDTH-1:10*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_11: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 1;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[12*`MRF_DWIDTH-1:11*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[12*`MRF_AWIDTH-1:11*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_12: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 1;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[13*`MRF_DWIDTH-1:12*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[13*`MRF_AWIDTH-1:12*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_13: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 1;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[14*`MRF_DWIDTH-1:13*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[14*`MRF_AWIDTH-1:13*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_14: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 1;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[15*`MRF_DWIDTH-1:14*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[15*`MRF_AWIDTH-1:14*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_15: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 1;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[16*`MRF_DWIDTH-1:15*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[16*`MRF_AWIDTH-1:15*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_16: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 1;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[17*`MRF_DWIDTH-1:16*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[17*`MRF_AWIDTH-1:16*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_17: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 1;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[18*`MRF_DWIDTH-1:17*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[18*`MRF_AWIDTH-1:17*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_18: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 1;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[19*`MRF_DWIDTH-1:18*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[19*`MRF_AWIDTH-1:18*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_19: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 1;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[20*`MRF_DWIDTH-1:19*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[20*`MRF_AWIDTH-1:19*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_20: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 1;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[21*`MRF_DWIDTH-1:20*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[21*`MRF_AWIDTH-1:20*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_21: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 1;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[22*`MRF_DWIDTH-1:21*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[22*`MRF_AWIDTH-1:21*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_22: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 1;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[23*`MRF_DWIDTH-1:22*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[23*`MRF_AWIDTH-1:22*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_23: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 1;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[24*`MRF_DWIDTH-1:23*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[24*`MRF_AWIDTH-1:23*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_24: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 1;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[25*`MRF_DWIDTH-1:24*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[25*`MRF_AWIDTH-1:24*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_25: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 1;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[26*`MRF_DWIDTH-1:25*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[26*`MRF_AWIDTH-1:25*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_26: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 1;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[27*`MRF_DWIDTH-1:26*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[27*`MRF_AWIDTH-1:26*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_27: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 1;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[28*`MRF_DWIDTH-1:27*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[28*`MRF_AWIDTH-1:27*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_28: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 1;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[29*`MRF_DWIDTH-1:28*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[29*`MRF_AWIDTH-1:28*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_29: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 1;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[30*`MRF_DWIDTH-1:29*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[30*`MRF_AWIDTH-1:29*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_30: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 1;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[31*`MRF_DWIDTH-1:30*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[31*`MRF_AWIDTH-1:30*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_31: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 1;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[32*`MRF_DWIDTH-1:31*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[32*`MRF_AWIDTH-1:31*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_32: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 1;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[33*`MRF_DWIDTH-1:32*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[33*`MRF_AWIDTH-1:32*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_33: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 1;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[34*`MRF_DWIDTH-1:33*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[34*`MRF_AWIDTH-1:33*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_34: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 1;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[35*`MRF_DWIDTH-1:34*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[35*`MRF_AWIDTH-1:34*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_35: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 1;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[36*`MRF_DWIDTH-1:35*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[36*`MRF_AWIDTH-1:35*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_36: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 1;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[37*`MRF_DWIDTH-1:36*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[37*`MRF_AWIDTH-1:36*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_37: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 1;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[38*`MRF_DWIDTH-1:37*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[38*`MRF_AWIDTH-1:37*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_38: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 1;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[39*`MRF_DWIDTH-1:38*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[39*`MRF_AWIDTH-1:38*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_39: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 1;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[40*`MRF_DWIDTH-1:39*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[40*`MRF_AWIDTH-1:39*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_40: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 1;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[41*`MRF_DWIDTH-1:40*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[41*`MRF_AWIDTH-1:40*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_41: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 1;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[42*`MRF_DWIDTH-1:41*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[42*`MRF_AWIDTH-1:41*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_42: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 1;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[43*`MRF_DWIDTH-1:42*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[43*`MRF_AWIDTH-1:42*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_43: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 1;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[44*`MRF_DWIDTH-1:43*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[44*`MRF_AWIDTH-1:43*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_44: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 1;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[45*`MRF_DWIDTH-1:44*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[45*`MRF_AWIDTH-1:44*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_45: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 1;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[46*`MRF_DWIDTH-1:45*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[46*`MRF_AWIDTH-1:45*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_46: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 1;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[47*`MRF_DWIDTH-1:46*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[47*`MRF_AWIDTH-1:46*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_47: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 1;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[48*`MRF_DWIDTH-1:47*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[48*`MRF_AWIDTH-1:47*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_48: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 1;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[49*`MRF_DWIDTH-1:48*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[49*`MRF_AWIDTH-1:48*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_49: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 1;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[50*`MRF_DWIDTH-1:49*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[50*`MRF_AWIDTH-1:49*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_50: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 1;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[51*`MRF_DWIDTH-1:50*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[51*`MRF_AWIDTH-1:50*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_51: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 1;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[52*`MRF_DWIDTH-1:51*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[52*`MRF_AWIDTH-1:51*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_52: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 1;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[53*`MRF_DWIDTH-1:52*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[53*`MRF_AWIDTH-1:52*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_53: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 1;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[54*`MRF_DWIDTH-1:53*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[54*`MRF_AWIDTH-1:53*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_54: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 1;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[55*`MRF_DWIDTH-1:54*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[55*`MRF_AWIDTH-1:54*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_55: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 1;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[56*`MRF_DWIDTH-1:55*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[56*`MRF_AWIDTH-1:55*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_56: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 1;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[57*`MRF_DWIDTH-1:56*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[57*`MRF_AWIDTH-1:56*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_57: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 1;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[58*`MRF_DWIDTH-1:57*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[58*`MRF_AWIDTH-1:57*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_58: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 1;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[59*`MRF_DWIDTH-1:58*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[59*`MRF_AWIDTH-1:58*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_59: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 1;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[60*`MRF_DWIDTH-1:59*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[60*`MRF_AWIDTH-1:59*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_60: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 1;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[61*`MRF_DWIDTH-1:60*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[61*`MRF_AWIDTH-1:60*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_61: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 1;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[62*`MRF_DWIDTH-1:61*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[62*`MRF_AWIDTH-1:61*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_62: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 1;
                    mrf_we_for_dram[63] <= 0;
                    mrf_in_data[63*`MRF_DWIDTH-1:62*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[63*`MRF_AWIDTH-1:62*`MRF_AWIDTH] = dstn_address;            
                  end
                  `MRF_63: begin 
                    mrf_we_for_dram[0] <= 0;
                    mrf_we_for_dram[1] <= 0;
                    mrf_we_for_dram[2] <= 0;
                    mrf_we_for_dram[3] <= 0;
                    mrf_we_for_dram[4] <= 0;
                    mrf_we_for_dram[5] <= 0;
                    mrf_we_for_dram[6] <= 0;
                    mrf_we_for_dram[7] <= 0;
                    mrf_we_for_dram[8] <= 0;
                    mrf_we_for_dram[9] <= 0;
                    mrf_we_for_dram[10] <= 0;
                    mrf_we_for_dram[11] <= 0;
                    mrf_we_for_dram[12] <= 0;
                    mrf_we_for_dram[13] <= 0;
                    mrf_we_for_dram[14] <= 0;
                    mrf_we_for_dram[15] <= 0;
                    mrf_we_for_dram[16] <= 0;
                    mrf_we_for_dram[17] <= 0;
                    mrf_we_for_dram[18] <= 0;
                    mrf_we_for_dram[19] <= 0;
                    mrf_we_for_dram[20] <= 0;
                    mrf_we_for_dram[21] <= 0;
                    mrf_we_for_dram[22] <= 0;
                    mrf_we_for_dram[23] <= 0;
                    mrf_we_for_dram[24] <= 0;
                    mrf_we_for_dram[25] <= 0;
                    mrf_we_for_dram[26] <= 0;
                    mrf_we_for_dram[27] <= 0;
                    mrf_we_for_dram[28] <= 0;
                    mrf_we_for_dram[29] <= 0;
                    mrf_we_for_dram[30] <= 0;
                    mrf_we_for_dram[31] <= 0;
                    mrf_we_for_dram[32] <= 0;
                    mrf_we_for_dram[33] <= 0;
                    mrf_we_for_dram[34] <= 0;
                    mrf_we_for_dram[35] <= 0;
                    mrf_we_for_dram[36] <= 0;
                    mrf_we_for_dram[37] <= 0;
                    mrf_we_for_dram[38] <= 0;
                    mrf_we_for_dram[39] <= 0;
                    mrf_we_for_dram[40] <= 0;
                    mrf_we_for_dram[41] <= 0;
                    mrf_we_for_dram[42] <= 0;
                    mrf_we_for_dram[43] <= 0;
                    mrf_we_for_dram[44] <= 0;
                    mrf_we_for_dram[45] <= 0;
                    mrf_we_for_dram[46] <= 0;
                    mrf_we_for_dram[47] <= 0;
                    mrf_we_for_dram[48] <= 0;
                    mrf_we_for_dram[49] <= 0;
                    mrf_we_for_dram[50] <= 0;
                    mrf_we_for_dram[51] <= 0;
                    mrf_we_for_dram[52] <= 0;
                    mrf_we_for_dram[53] <= 0;
                    mrf_we_for_dram[54] <= 0;
                    mrf_we_for_dram[55] <= 0;
                    mrf_we_for_dram[56] <= 0;
                    mrf_we_for_dram[57] <= 0;
                    mrf_we_for_dram[58] <= 0;
                    mrf_we_for_dram[59] <= 0;
                    mrf_we_for_dram[60] <= 0;
                    mrf_we_for_dram[61] <= 0;
                    mrf_we_for_dram[62] <= 0;
                    mrf_we_for_dram[63] <= 1;
                    mrf_in_data[64*`MRF_DWIDTH-1:63*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[64*`MRF_AWIDTH-1:63*`MRF_AWIDTH] = dstn_address;            
                  end
                  
                  default: begin 
                    mrf_we_for_dram[0] <= 1'bX;
                    mrf_we_for_dram[1] <= 1'bX;
                    mrf_we_for_dram[2] <= 1'bX;
                    mrf_we_for_dram[3] <= 1'bX;
                    mrf_we_for_dram[4] <= 1'bX;
                    mrf_we_for_dram[5] <= 1'bX;
                    mrf_we_for_dram[6] <= 1'bX;
                    mrf_we_for_dram[7] <= 1'bX;
                    mrf_we_for_dram[8] <= 1'bX;
                    mrf_we_for_dram[9] <= 1'bX;
                    mrf_we_for_dram[10] <= 1'bX;
                    mrf_we_for_dram[11] <= 1'bX;
                    mrf_we_for_dram[12] <= 1'bX;
                    mrf_we_for_dram[13] <= 1'bX;
                    mrf_we_for_dram[14] <= 1'bX;
                    mrf_we_for_dram[15] <= 1'bX;
                    mrf_we_for_dram[16] <= 1'bX;
                    mrf_we_for_dram[17] <= 1'bX;
                    mrf_we_for_dram[18] <= 1'bX;
                    mrf_we_for_dram[19] <= 1'bX;
                    mrf_we_for_dram[20] <= 1'bX;
                    mrf_we_for_dram[21] <= 1'bX;
                    mrf_we_for_dram[22] <= 1'bX;
                    mrf_we_for_dram[23] <= 1'bX;
                    mrf_we_for_dram[24] <= 1'bX;
                    mrf_we_for_dram[25] <= 1'bX;
                    mrf_we_for_dram[26] <= 1'bX;
                    mrf_we_for_dram[27] <= 1'bX;
                    mrf_we_for_dram[28] <= 1'bX;
                    mrf_we_for_dram[29] <= 1'bX;
                    mrf_we_for_dram[30] <= 1'bX;
                    mrf_we_for_dram[31] <= 1'bX;
                    mrf_we_for_dram[32] <= 1'bX;
                    mrf_we_for_dram[33] <= 1'bX;
                    mrf_we_for_dram[34] <= 1'bX;
                    mrf_we_for_dram[35] <= 1'bX;
                    mrf_we_for_dram[36] <= 1'bX;
                    mrf_we_for_dram[37] <= 1'bX;
                    mrf_we_for_dram[38] <= 1'bX;
                    mrf_we_for_dram[39] <= 1'bX;
                    mrf_we_for_dram[40] <= 1'bX;
                    mrf_we_for_dram[41] <= 1'bX;
                    mrf_we_for_dram[42] <= 1'bX;
                    mrf_we_for_dram[43] <= 1'bX;
                    mrf_we_for_dram[44] <= 1'bX;
                    mrf_we_for_dram[45] <= 1'bX;
                    mrf_we_for_dram[46] <= 1'bX;
                    mrf_we_for_dram[47] <= 1'bX;
                    mrf_we_for_dram[48] <= 1'bX;
                    mrf_we_for_dram[49] <= 1'bX;
                    mrf_we_for_dram[50] <= 1'bX;
                    mrf_we_for_dram[51] <= 1'bX;
                    mrf_we_for_dram[52] <= 1'bX;
                    mrf_we_for_dram[53] <= 1'bX;
                    mrf_we_for_dram[54] <= 1'bX;
                    mrf_we_for_dram[55] <= 1'bX;
                    mrf_we_for_dram[56] <= 1'bX;
                    mrf_we_for_dram[57] <= 1'bX;
                    mrf_we_for_dram[58] <= 1'bX;
                    mrf_we_for_dram[59] <= 1'bX;
                    mrf_we_for_dram[60] <= 1'bX;
                    mrf_we_for_dram[61] <= 1'bX;
                    mrf_we_for_dram[62] <= 1'bX;
                    mrf_we_for_dram[63] <= 1'bX;
                  end
                  
                endcase 
            end
            default: begin
            
            if(done_mvm || done_mfu_0 || done_mfu_1) begin
                start_mv_mul <= 0;
                start_mfu_0 <= 0;
                start_mfu_1 <= 0;
                state <= 0;
                get_instr<=1'b1;
                get_instr_addr<=get_instr_addr+1'b1;
               
                case(dstn_id) 
                  `VRF_0: begin 
                  vrf_wr_enable_mvu_0 <= 1'b1;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  dram_write_enable<=1'b0;
                  vrf_in_data <= output_final_stage;
                  vrf_addr_wr<=dstn_address;
                  //vrf_addr_wr_mvu_0 <= dstn_address;
                  end
                  `VRF_1: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b1;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  dram_write_enable<=1'b0;
                  vrf_in_data <= output_final_stage;
                  vrf_addr_wr<=dstn_address;
                  //vrf_addr_wr_mvu_0 <= dstn_address;
                  end
                  `VRF_2: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b1;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  dram_write_enable<=1'b0;
                  vrf_in_data <= output_final_stage;
                  vrf_addr_wr<=dstn_address;
                  //vrf_addr_wr_mvu_0 <= dstn_address;
                  end
                  `VRF_3: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b1;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  dram_write_enable<=1'b0;
                  vrf_in_data <= output_final_stage;
                  vrf_addr_wr<=dstn_address;
                  //vrf_addr_wr_mvu_0 <= dstn_address;
                  end

                  `VRF_4: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b1;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  dram_write_enable<=1'b0;
                  
                  vrf_in_data <= output_final_stage;
                  
                  vrf_addr_wr_mfu_add_0 <= dstn_address;
                  
                  end
                  
                  `VRF_5: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b1;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  vrf_in_data <= output_final_stage;
                  
                  vrf_addr_wr_mfu_mul_0 <= dstn_address;
                  
                  end
                  
                  `VRF_6: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b1;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  dram_write_enable<=1'b0;
                  
                  vrf_in_data <= output_final_stage;
                  
                  vrf_addr_wr_mfu_add_1 <= dstn_address;
                  end
                  
                  `VRF_7: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b1;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  dram_write_enable<=1'b0;
                  
                  vrf_in_data <= output_final_stage;
                  
                  vrf_addr_wr_mfu_mul_1 <= dstn_address;
                  end
                  
                  `VRF_MUXED: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b1;
                   dram_write_enable<=1'b0;
                   
                   vrf_in_data <= output_final_stage;
                   
                  vrf_muxed_wr_addr_dram <= dstn_address;
                  end
    
                  `DRAM_MEM_ID: begin
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  dram_write_enable<=1'b1;
                  
                  output_data_to_dram <= output_final_stage;
                   
                  dram_addr_wr <= dstn_address;
                  end
                  
                  //MFU_OUT_STAGE IDS USED FOR MUXING
                  
                  default: begin 
                  vrf_wr_enable_mvu_0 <= 1'b0;
                  vrf_wr_enable_mvu_1 <= 1'b0;
                  vrf_wr_enable_mvu_2 <= 1'b0;
                  vrf_wr_enable_mvu_3 <= 1'b0;
                  vrf_wr_enable_mfu_add_0 <= 1'b0;
                  vrf_wr_enable_mfu_mul_0 <= 1'b0;
                  vrf_wr_enable_mfu_add_1 <= 1'b0;
                  vrf_wr_enable_mfu_mul_1 <= 1'b0;
                  vrf_muxed_wr_enable_dram <= 1'b0;
                  dram_write_enable<=1'b0;
                  end
                 endcase
                end
              end 
             endcase      
            end
         end
       end          
endmodule             
////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM mvu.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


//`include "includes_gen.v"

module MVU (
    input clk,
    input[`NUM_LDPES-1:0] start,
    input[`NUM_LDPES-1:0] reset,
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

    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_0;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_0;
    wire[`NUM_LDPES-1:0] out_data_available_internal_comparator_tree_0;
    
    wire[`NUM_LDPES-1:0] out_data_available_mvm_tile_0;
    
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
    .mrf_in(mrf_in[1*`MRF_DWIDTH*`NUM_LDPES-1:0*`MRF_DWIDTH*`NUM_LDPES]),
    .mrf_we(mrf_we[1*`NUM_LDPES-1:0*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[1*`NUM_LDPES*`MRF_AWIDTH-1:0*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_addr_for_dram(mrf_addr_for_dram[1*`NUM_LDPES*`MRF_AWIDTH-1:0*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_outa_to_dram(mrf_outa_to_dram[1*`NUM_LDPES*`MRF_DWIDTH-1:0*`NUM_LDPES*`MRF_DWIDTH]),
    .mrf_we_for_dram(mrf_we_for_dram[1*`NUM_LDPES-1:0*`NUM_LDPES]),
    .result(result_mvm_0) //WITH TAG
    );
    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_1;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_1;
    wire[`NUM_LDPES-1:0] out_data_available_internal_comparator_tree_1;
    
    wire[`NUM_LDPES-1:0] out_data_available_mvm_tile_1;
    
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
    .mrf_in(mrf_in[2*`MRF_DWIDTH*`NUM_LDPES-1:1*`MRF_DWIDTH*`NUM_LDPES]),
    .mrf_we(mrf_we[2*`NUM_LDPES-1:1*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[2*`NUM_LDPES*`MRF_AWIDTH-1:1*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_addr_for_dram(mrf_addr_for_dram[2*`NUM_LDPES*`MRF_AWIDTH-1:1*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_outa_to_dram(mrf_outa_to_dram[2*`NUM_LDPES*`MRF_DWIDTH-1:1*`NUM_LDPES*`MRF_DWIDTH]),
    .mrf_we_for_dram(mrf_we_for_dram[2*`NUM_LDPES-1:1*`NUM_LDPES]),
    .result(result_mvm_1) //WITH TAG
    );
    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_2;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_2;
    wire[`NUM_LDPES-1:0] out_data_available_internal_comparator_tree_2;
    
    wire[`NUM_LDPES-1:0] out_data_available_mvm_tile_2;
    
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
    .mrf_in(mrf_in[3*`MRF_DWIDTH*`NUM_LDPES-1:2*`MRF_DWIDTH*`NUM_LDPES]),
    .mrf_we(mrf_we[3*`NUM_LDPES-1:2*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[3*`NUM_LDPES*`MRF_AWIDTH-1:2*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_addr_for_dram(mrf_addr_for_dram[3*`NUM_LDPES*`MRF_AWIDTH-1:2*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_outa_to_dram(mrf_outa_to_dram[3*`NUM_LDPES*`MRF_DWIDTH-1:2*`NUM_LDPES*`MRF_DWIDTH]),
    .mrf_we_for_dram(mrf_we_for_dram[3*`NUM_LDPES-1:2*`NUM_LDPES]),
    .result(result_mvm_2) //WITH TAG
    );
    wire[`LDPE_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] result_mvm_3;
    wire[`BFLOAT_EXP*`NUM_LDPES-1:0] max_exp_3;
    wire[`NUM_LDPES-1:0] out_data_available_internal_comparator_tree_3;
    
    wire[`NUM_LDPES-1:0] out_data_available_mvm_tile_3;
    
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
    .mrf_in(mrf_in[4*`MRF_DWIDTH*`NUM_LDPES-1:3*`MRF_DWIDTH*`NUM_LDPES]),
    .mrf_we(mrf_we[4*`NUM_LDPES-1:3*`NUM_LDPES]),  //WITH TAG 
    .mrf_addr(mrf_addr[4*`NUM_LDPES*`MRF_AWIDTH-1:3*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_addr_for_dram(mrf_addr_for_dram[4*`NUM_LDPES*`MRF_AWIDTH-1:3*`NUM_LDPES*`MRF_AWIDTH]),
    .mrf_outa_to_dram(mrf_outa_to_dram[4*`NUM_LDPES*`MRF_DWIDTH-1:3*`NUM_LDPES*`MRF_DWIDTH]),
    .mrf_we_for_dram(mrf_we_for_dram[4*`NUM_LDPES-1:3*`NUM_LDPES]),
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

wire[`NUM_LDPES-1:0] start_reduction_tree;
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
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_9;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_9;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_9;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_9;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_9_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_9_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_9_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_9_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_9_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_9_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_9_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_9_mantisa_shifted;

    assign ax_wire_9_num = ax[9*`BFLOAT_DWIDTH-1:(9-1)*`BFLOAT_DWIDTH];
    assign ay_wire_9_num = ay[9*`BFLOAT_DWIDTH-1:(9-1)*`BFLOAT_DWIDTH];
    assign bx_wire_9_num = bx[9*`BFLOAT_DWIDTH-1:(9-1)*`BFLOAT_DWIDTH];
    assign by_wire_9_num = by[9*`BFLOAT_DWIDTH-1:(9-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_9_ax;
    assign shift_amt_9_ax = max_exp - ax_wire_9_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_9;
    wire start_barrel_shifter_ax_9;

    assign start_barrel_shifter_ax_9 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_9(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_9),
        .out_data_available(out_data_available_barrel_shifter_ax_9),
        .shift_amt(shift_amt_9_ax),
        .significand({1'b1,ax_wire_9_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_9_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_9_ay;
    assign shift_amt_9_ay = max_exp - ay_wire_9_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_9;
    wire start_barrel_shifter_ay_9;

    assign start_barrel_shifter_ay_9 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_9(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_9),
        .out_data_available(out_data_available_barrel_shifter_ay_9),
        .shift_amt(shift_amt_9_ay),
        .significand({1'b1,ay_wire_9_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_9_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_9_bx;
    assign shift_amt_9_bx = max_exp - bx_wire_9_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_9;
    wire start_barrel_shifter_bx_9;

    assign start_barrel_shifter_bx_9 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_9(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_9),
        .out_data_available(out_data_available_barrel_shifter_bx_9),
        .shift_amt(shift_amt_9_bx),
        .significand({1'b1,bx_wire_9_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_9_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_9_by;
    assign shift_amt_9_by = max_exp - by_wire_9_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_9;
    wire start_barrel_shifter_by_9;

    assign start_barrel_shifter_by_9 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_9(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_9),
        .out_data_available(out_data_available_barrel_shifter_by_9),
        .shift_amt(shift_amt_9_by),
        .significand({1'b1,by_wire_9_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_9_mantisa_shifted)
    );

    assign ax_wire_9 = (ax_wire_9_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_9_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_9_mantisa_shifted};
    assign ay_wire_9 = (ay_wire_9_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_9_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_9_mantisa_shifted};
    assign bx_wire_9 = (bx_wire_9_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_9_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_9_mantisa_shifted};
    assign by_wire_9 = (by_wire_9_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_9_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_9_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_9;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_9;

    assign dsp_result[9*`DSP_USED_OUTPUT_WIDTH-1:(9-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_9[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_9;
    assign reset_dsp_9 = ~out_data_available_barrel_shifter_ax_9;

    dsp_block_18_18_int_sop_2 dsp_9 (
        .clk(clk),
        .aclr(reset_dsp_9),
        .ax(ax_wire_9),
        .ay(ay_wire_9),
        .bx(bx_wire_9),
        .by(by_wire_9),
        .chainin(chainout_temp_8),
        .chainout(chainout_temp_9),
        .result(result_temp_9)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_10;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_10;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_10;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_10;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_10_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_10_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_10_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_10_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_10_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_10_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_10_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_10_mantisa_shifted;

    assign ax_wire_10_num = ax[10*`BFLOAT_DWIDTH-1:(10-1)*`BFLOAT_DWIDTH];
    assign ay_wire_10_num = ay[10*`BFLOAT_DWIDTH-1:(10-1)*`BFLOAT_DWIDTH];
    assign bx_wire_10_num = bx[10*`BFLOAT_DWIDTH-1:(10-1)*`BFLOAT_DWIDTH];
    assign by_wire_10_num = by[10*`BFLOAT_DWIDTH-1:(10-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_10_ax;
    assign shift_amt_10_ax = max_exp - ax_wire_10_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_10;
    wire start_barrel_shifter_ax_10;

    assign start_barrel_shifter_ax_10 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_10(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_10),
        .out_data_available(out_data_available_barrel_shifter_ax_10),
        .shift_amt(shift_amt_10_ax),
        .significand({1'b1,ax_wire_10_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_10_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_10_ay;
    assign shift_amt_10_ay = max_exp - ay_wire_10_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_10;
    wire start_barrel_shifter_ay_10;

    assign start_barrel_shifter_ay_10 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_10(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_10),
        .out_data_available(out_data_available_barrel_shifter_ay_10),
        .shift_amt(shift_amt_10_ay),
        .significand({1'b1,ay_wire_10_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_10_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_10_bx;
    assign shift_amt_10_bx = max_exp - bx_wire_10_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_10;
    wire start_barrel_shifter_bx_10;

    assign start_barrel_shifter_bx_10 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_10(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_10),
        .out_data_available(out_data_available_barrel_shifter_bx_10),
        .shift_amt(shift_amt_10_bx),
        .significand({1'b1,bx_wire_10_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_10_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_10_by;
    assign shift_amt_10_by = max_exp - by_wire_10_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_10;
    wire start_barrel_shifter_by_10;

    assign start_barrel_shifter_by_10 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_10(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_10),
        .out_data_available(out_data_available_barrel_shifter_by_10),
        .shift_amt(shift_amt_10_by),
        .significand({1'b1,by_wire_10_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_10_mantisa_shifted)
    );

    assign ax_wire_10 = (ax_wire_10_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_10_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_10_mantisa_shifted};
    assign ay_wire_10 = (ay_wire_10_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_10_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_10_mantisa_shifted};
    assign bx_wire_10 = (bx_wire_10_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_10_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_10_mantisa_shifted};
    assign by_wire_10 = (by_wire_10_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_10_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_10_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_10;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_10;

    assign dsp_result[10*`DSP_USED_OUTPUT_WIDTH-1:(10-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_10[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_10;
    assign reset_dsp_10 = ~out_data_available_barrel_shifter_ax_10;

    dsp_block_18_18_int_sop_2 dsp_10 (
        .clk(clk),
        .aclr(reset_dsp_10),
        .ax(ax_wire_10),
        .ay(ay_wire_10),
        .bx(bx_wire_10),
        .by(by_wire_10),
        .chainin(chainout_temp_9),
        .chainout(chainout_temp_10),
        .result(result_temp_10)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_11;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_11;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_11;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_11;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_11_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_11_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_11_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_11_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_11_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_11_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_11_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_11_mantisa_shifted;

    assign ax_wire_11_num = ax[11*`BFLOAT_DWIDTH-1:(11-1)*`BFLOAT_DWIDTH];
    assign ay_wire_11_num = ay[11*`BFLOAT_DWIDTH-1:(11-1)*`BFLOAT_DWIDTH];
    assign bx_wire_11_num = bx[11*`BFLOAT_DWIDTH-1:(11-1)*`BFLOAT_DWIDTH];
    assign by_wire_11_num = by[11*`BFLOAT_DWIDTH-1:(11-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_11_ax;
    assign shift_amt_11_ax = max_exp - ax_wire_11_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_11;
    wire start_barrel_shifter_ax_11;

    assign start_barrel_shifter_ax_11 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_11(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_11),
        .out_data_available(out_data_available_barrel_shifter_ax_11),
        .shift_amt(shift_amt_11_ax),
        .significand({1'b1,ax_wire_11_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_11_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_11_ay;
    assign shift_amt_11_ay = max_exp - ay_wire_11_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_11;
    wire start_barrel_shifter_ay_11;

    assign start_barrel_shifter_ay_11 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_11(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_11),
        .out_data_available(out_data_available_barrel_shifter_ay_11),
        .shift_amt(shift_amt_11_ay),
        .significand({1'b1,ay_wire_11_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_11_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_11_bx;
    assign shift_amt_11_bx = max_exp - bx_wire_11_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_11;
    wire start_barrel_shifter_bx_11;

    assign start_barrel_shifter_bx_11 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_11(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_11),
        .out_data_available(out_data_available_barrel_shifter_bx_11),
        .shift_amt(shift_amt_11_bx),
        .significand({1'b1,bx_wire_11_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_11_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_11_by;
    assign shift_amt_11_by = max_exp - by_wire_11_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_11;
    wire start_barrel_shifter_by_11;

    assign start_barrel_shifter_by_11 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_11(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_11),
        .out_data_available(out_data_available_barrel_shifter_by_11),
        .shift_amt(shift_amt_11_by),
        .significand({1'b1,by_wire_11_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_11_mantisa_shifted)
    );

    assign ax_wire_11 = (ax_wire_11_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_11_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_11_mantisa_shifted};
    assign ay_wire_11 = (ay_wire_11_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_11_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_11_mantisa_shifted};
    assign bx_wire_11 = (bx_wire_11_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_11_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_11_mantisa_shifted};
    assign by_wire_11 = (by_wire_11_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_11_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_11_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_11;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_11;

    assign dsp_result[11*`DSP_USED_OUTPUT_WIDTH-1:(11-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_11[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_11;
    assign reset_dsp_11 = ~out_data_available_barrel_shifter_ax_11;

    dsp_block_18_18_int_sop_2 dsp_11 (
        .clk(clk),
        .aclr(reset_dsp_11),
        .ax(ax_wire_11),
        .ay(ay_wire_11),
        .bx(bx_wire_11),
        .by(by_wire_11),
        .chainin(chainout_temp_10),
        .chainout(chainout_temp_11),
        .result(result_temp_11)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_12;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_12;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_12;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_12;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_12_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_12_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_12_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_12_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_12_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_12_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_12_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_12_mantisa_shifted;

    assign ax_wire_12_num = ax[12*`BFLOAT_DWIDTH-1:(12-1)*`BFLOAT_DWIDTH];
    assign ay_wire_12_num = ay[12*`BFLOAT_DWIDTH-1:(12-1)*`BFLOAT_DWIDTH];
    assign bx_wire_12_num = bx[12*`BFLOAT_DWIDTH-1:(12-1)*`BFLOAT_DWIDTH];
    assign by_wire_12_num = by[12*`BFLOAT_DWIDTH-1:(12-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_12_ax;
    assign shift_amt_12_ax = max_exp - ax_wire_12_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_12;
    wire start_barrel_shifter_ax_12;

    assign start_barrel_shifter_ax_12 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_12(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_12),
        .out_data_available(out_data_available_barrel_shifter_ax_12),
        .shift_amt(shift_amt_12_ax),
        .significand({1'b1,ax_wire_12_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_12_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_12_ay;
    assign shift_amt_12_ay = max_exp - ay_wire_12_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_12;
    wire start_barrel_shifter_ay_12;

    assign start_barrel_shifter_ay_12 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_12(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_12),
        .out_data_available(out_data_available_barrel_shifter_ay_12),
        .shift_amt(shift_amt_12_ay),
        .significand({1'b1,ay_wire_12_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_12_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_12_bx;
    assign shift_amt_12_bx = max_exp - bx_wire_12_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_12;
    wire start_barrel_shifter_bx_12;

    assign start_barrel_shifter_bx_12 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_12(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_12),
        .out_data_available(out_data_available_barrel_shifter_bx_12),
        .shift_amt(shift_amt_12_bx),
        .significand({1'b1,bx_wire_12_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_12_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_12_by;
    assign shift_amt_12_by = max_exp - by_wire_12_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_12;
    wire start_barrel_shifter_by_12;

    assign start_barrel_shifter_by_12 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_12(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_12),
        .out_data_available(out_data_available_barrel_shifter_by_12),
        .shift_amt(shift_amt_12_by),
        .significand({1'b1,by_wire_12_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_12_mantisa_shifted)
    );

    assign ax_wire_12 = (ax_wire_12_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_12_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_12_mantisa_shifted};
    assign ay_wire_12 = (ay_wire_12_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_12_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_12_mantisa_shifted};
    assign bx_wire_12 = (bx_wire_12_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_12_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_12_mantisa_shifted};
    assign by_wire_12 = (by_wire_12_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_12_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_12_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_12;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_12;

    assign dsp_result[12*`DSP_USED_OUTPUT_WIDTH-1:(12-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_12[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_12;
    assign reset_dsp_12 = ~out_data_available_barrel_shifter_ax_12;

    dsp_block_18_18_int_sop_2 dsp_12 (
        .clk(clk),
        .aclr(reset_dsp_12),
        .ax(ax_wire_12),
        .ay(ay_wire_12),
        .bx(bx_wire_12),
        .by(by_wire_12),
        .chainin(chainout_temp_11),
        .chainout(chainout_temp_12),
        .result(result_temp_12)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_13;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_13;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_13;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_13;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_13_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_13_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_13_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_13_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_13_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_13_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_13_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_13_mantisa_shifted;

    assign ax_wire_13_num = ax[13*`BFLOAT_DWIDTH-1:(13-1)*`BFLOAT_DWIDTH];
    assign ay_wire_13_num = ay[13*`BFLOAT_DWIDTH-1:(13-1)*`BFLOAT_DWIDTH];
    assign bx_wire_13_num = bx[13*`BFLOAT_DWIDTH-1:(13-1)*`BFLOAT_DWIDTH];
    assign by_wire_13_num = by[13*`BFLOAT_DWIDTH-1:(13-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_13_ax;
    assign shift_amt_13_ax = max_exp - ax_wire_13_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_13;
    wire start_barrel_shifter_ax_13;

    assign start_barrel_shifter_ax_13 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_13(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_13),
        .out_data_available(out_data_available_barrel_shifter_ax_13),
        .shift_amt(shift_amt_13_ax),
        .significand({1'b1,ax_wire_13_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_13_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_13_ay;
    assign shift_amt_13_ay = max_exp - ay_wire_13_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_13;
    wire start_barrel_shifter_ay_13;

    assign start_barrel_shifter_ay_13 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_13(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_13),
        .out_data_available(out_data_available_barrel_shifter_ay_13),
        .shift_amt(shift_amt_13_ay),
        .significand({1'b1,ay_wire_13_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_13_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_13_bx;
    assign shift_amt_13_bx = max_exp - bx_wire_13_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_13;
    wire start_barrel_shifter_bx_13;

    assign start_barrel_shifter_bx_13 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_13(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_13),
        .out_data_available(out_data_available_barrel_shifter_bx_13),
        .shift_amt(shift_amt_13_bx),
        .significand({1'b1,bx_wire_13_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_13_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_13_by;
    assign shift_amt_13_by = max_exp - by_wire_13_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_13;
    wire start_barrel_shifter_by_13;

    assign start_barrel_shifter_by_13 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_13(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_13),
        .out_data_available(out_data_available_barrel_shifter_by_13),
        .shift_amt(shift_amt_13_by),
        .significand({1'b1,by_wire_13_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_13_mantisa_shifted)
    );

    assign ax_wire_13 = (ax_wire_13_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_13_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_13_mantisa_shifted};
    assign ay_wire_13 = (ay_wire_13_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_13_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_13_mantisa_shifted};
    assign bx_wire_13 = (bx_wire_13_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_13_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_13_mantisa_shifted};
    assign by_wire_13 = (by_wire_13_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_13_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_13_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_13;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_13;

    assign dsp_result[13*`DSP_USED_OUTPUT_WIDTH-1:(13-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_13[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_13;
    assign reset_dsp_13 = ~out_data_available_barrel_shifter_ax_13;

    dsp_block_18_18_int_sop_2 dsp_13 (
        .clk(clk),
        .aclr(reset_dsp_13),
        .ax(ax_wire_13),
        .ay(ay_wire_13),
        .bx(bx_wire_13),
        .by(by_wire_13),
        .chainin(chainout_temp_12),
        .chainout(chainout_temp_13),
        .result(result_temp_13)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_14;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_14;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_14;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_14;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_14_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_14_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_14_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_14_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_14_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_14_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_14_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_14_mantisa_shifted;

    assign ax_wire_14_num = ax[14*`BFLOAT_DWIDTH-1:(14-1)*`BFLOAT_DWIDTH];
    assign ay_wire_14_num = ay[14*`BFLOAT_DWIDTH-1:(14-1)*`BFLOAT_DWIDTH];
    assign bx_wire_14_num = bx[14*`BFLOAT_DWIDTH-1:(14-1)*`BFLOAT_DWIDTH];
    assign by_wire_14_num = by[14*`BFLOAT_DWIDTH-1:(14-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_14_ax;
    assign shift_amt_14_ax = max_exp - ax_wire_14_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_14;
    wire start_barrel_shifter_ax_14;

    assign start_barrel_shifter_ax_14 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_14(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_14),
        .out_data_available(out_data_available_barrel_shifter_ax_14),
        .shift_amt(shift_amt_14_ax),
        .significand({1'b1,ax_wire_14_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_14_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_14_ay;
    assign shift_amt_14_ay = max_exp - ay_wire_14_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_14;
    wire start_barrel_shifter_ay_14;

    assign start_barrel_shifter_ay_14 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_14(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_14),
        .out_data_available(out_data_available_barrel_shifter_ay_14),
        .shift_amt(shift_amt_14_ay),
        .significand({1'b1,ay_wire_14_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_14_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_14_bx;
    assign shift_amt_14_bx = max_exp - bx_wire_14_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_14;
    wire start_barrel_shifter_bx_14;

    assign start_barrel_shifter_bx_14 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_14(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_14),
        .out_data_available(out_data_available_barrel_shifter_bx_14),
        .shift_amt(shift_amt_14_bx),
        .significand({1'b1,bx_wire_14_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_14_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_14_by;
    assign shift_amt_14_by = max_exp - by_wire_14_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_14;
    wire start_barrel_shifter_by_14;

    assign start_barrel_shifter_by_14 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_14(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_14),
        .out_data_available(out_data_available_barrel_shifter_by_14),
        .shift_amt(shift_amt_14_by),
        .significand({1'b1,by_wire_14_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_14_mantisa_shifted)
    );

    assign ax_wire_14 = (ax_wire_14_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_14_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_14_mantisa_shifted};
    assign ay_wire_14 = (ay_wire_14_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_14_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_14_mantisa_shifted};
    assign bx_wire_14 = (bx_wire_14_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_14_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_14_mantisa_shifted};
    assign by_wire_14 = (by_wire_14_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_14_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_14_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_14;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_14;

    assign dsp_result[14*`DSP_USED_OUTPUT_WIDTH-1:(14-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_14[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_14;
    assign reset_dsp_14 = ~out_data_available_barrel_shifter_ax_14;

    dsp_block_18_18_int_sop_2 dsp_14 (
        .clk(clk),
        .aclr(reset_dsp_14),
        .ax(ax_wire_14),
        .ay(ay_wire_14),
        .bx(bx_wire_14),
        .by(by_wire_14),
        .chainin(chainout_temp_13),
        .chainout(chainout_temp_14),
        .result(result_temp_14)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_15;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_15;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_15;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_15;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_15_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_15_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_15_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_15_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_15_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_15_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_15_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_15_mantisa_shifted;

    assign ax_wire_15_num = ax[15*`BFLOAT_DWIDTH-1:(15-1)*`BFLOAT_DWIDTH];
    assign ay_wire_15_num = ay[15*`BFLOAT_DWIDTH-1:(15-1)*`BFLOAT_DWIDTH];
    assign bx_wire_15_num = bx[15*`BFLOAT_DWIDTH-1:(15-1)*`BFLOAT_DWIDTH];
    assign by_wire_15_num = by[15*`BFLOAT_DWIDTH-1:(15-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_15_ax;
    assign shift_amt_15_ax = max_exp - ax_wire_15_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_15;
    wire start_barrel_shifter_ax_15;

    assign start_barrel_shifter_ax_15 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_15(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_15),
        .out_data_available(out_data_available_barrel_shifter_ax_15),
        .shift_amt(shift_amt_15_ax),
        .significand({1'b1,ax_wire_15_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_15_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_15_ay;
    assign shift_amt_15_ay = max_exp - ay_wire_15_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_15;
    wire start_barrel_shifter_ay_15;

    assign start_barrel_shifter_ay_15 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_15(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_15),
        .out_data_available(out_data_available_barrel_shifter_ay_15),
        .shift_amt(shift_amt_15_ay),
        .significand({1'b1,ay_wire_15_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_15_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_15_bx;
    assign shift_amt_15_bx = max_exp - bx_wire_15_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_15;
    wire start_barrel_shifter_bx_15;

    assign start_barrel_shifter_bx_15 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_15(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_15),
        .out_data_available(out_data_available_barrel_shifter_bx_15),
        .shift_amt(shift_amt_15_bx),
        .significand({1'b1,bx_wire_15_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_15_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_15_by;
    assign shift_amt_15_by = max_exp - by_wire_15_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_15;
    wire start_barrel_shifter_by_15;

    assign start_barrel_shifter_by_15 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_15(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_15),
        .out_data_available(out_data_available_barrel_shifter_by_15),
        .shift_amt(shift_amt_15_by),
        .significand({1'b1,by_wire_15_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_15_mantisa_shifted)
    );

    assign ax_wire_15 = (ax_wire_15_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_15_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_15_mantisa_shifted};
    assign ay_wire_15 = (ay_wire_15_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_15_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_15_mantisa_shifted};
    assign bx_wire_15 = (bx_wire_15_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_15_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_15_mantisa_shifted};
    assign by_wire_15 = (by_wire_15_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_15_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_15_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_15;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_15;

    assign dsp_result[15*`DSP_USED_OUTPUT_WIDTH-1:(15-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_15[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_15;
    assign reset_dsp_15 = ~out_data_available_barrel_shifter_ax_15;

    dsp_block_18_18_int_sop_2 dsp_15 (
        .clk(clk),
        .aclr(reset_dsp_15),
        .ax(ax_wire_15),
        .ay(ay_wire_15),
        .bx(bx_wire_15),
        .by(by_wire_15),
        .chainin(chainout_temp_14),
        .chainout(chainout_temp_15),
        .result(result_temp_15)
    );
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] ax_wire_16;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] ay_wire_16;
    wire [`DSP_X_AVA_INPUT_WIDTH-1:0] bx_wire_16;
    wire [`DSP_Y_AVA_INPUT_WIDTH-1:0] by_wire_16;

    wire [`BFLOAT_DWIDTH-1:0] ax_wire_16_num;
    wire [`BFLOAT_DWIDTH-1:0] ay_wire_16_num;
    wire [`BFLOAT_DWIDTH-1:0] bx_wire_16_num;
    wire [`BFLOAT_DWIDTH-1:0] by_wire_16_num;

    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ax_wire_16_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] ay_wire_16_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] bx_wire_16_mantisa_shifted;
    wire [`BFLOAT_MANTISA_WITH_LO-1:0] by_wire_16_mantisa_shifted;

    assign ax_wire_16_num = ax[16*`BFLOAT_DWIDTH-1:(16-1)*`BFLOAT_DWIDTH];
    assign ay_wire_16_num = ay[16*`BFLOAT_DWIDTH-1:(16-1)*`BFLOAT_DWIDTH];
    assign bx_wire_16_num = bx[16*`BFLOAT_DWIDTH-1:(16-1)*`BFLOAT_DWIDTH];
    assign by_wire_16_num = by[16*`BFLOAT_DWIDTH-1:(16-1)*`BFLOAT_DWIDTH];
    
    wire[`BFLOAT_EXP-1:0] shift_amt_16_ax;
    assign shift_amt_16_ax = max_exp - ax_wire_16_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    
    wire out_data_available_barrel_shifter_ax_16;
    wire start_barrel_shifter_ax_16;

    assign start_barrel_shifter_ax_16 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ax_16(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ax_16),
        .out_data_available(out_data_available_barrel_shifter_ax_16),
        .shift_amt(shift_amt_16_ax),
        .significand({1'b1,ax_wire_16_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ax_wire_16_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_16_ay;
    assign shift_amt_16_ay = max_exp - ay_wire_16_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_ay_16;
    wire start_barrel_shifter_ay_16;

    assign start_barrel_shifter_ay_16 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_ay_16(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_ay_16),
        .out_data_available(out_data_available_barrel_shifter_ay_16),
        .shift_amt(shift_amt_16_ay),
        .significand({1'b1,ay_wire_16_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(ay_wire_16_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_16_bx;
    assign shift_amt_16_bx = max_exp - bx_wire_16_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_bx_16;
    wire start_barrel_shifter_bx_16;

    assign start_barrel_shifter_bx_16 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_bx_16(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_bx_16),
        .out_data_available(out_data_available_barrel_shifter_bx_16),
        .shift_amt(shift_amt_16_bx),
        .significand({1'b1,bx_wire_16_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(bx_wire_16_mantisa_shifted)
    );

    wire[`BFLOAT_EXP-1:0] shift_amt_16_by;
    assign shift_amt_16_by = max_exp - by_wire_16_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA];
    wire out_data_available_barrel_shifter_by_16;
    wire start_barrel_shifter_by_16;

    assign start_barrel_shifter_by_16 = out_data_available_external_comparator_tree;

    barrel_shifter_right bshift_by_16(
        .clk(clk),
        .reset(reset),
        .start(start_barrel_shifter_by_16),
        .out_data_available(out_data_available_barrel_shifter_by_16),
        .shift_amt(shift_amt_16_by),
        .significand({1'b1,by_wire_16_num[`BFLOAT_MANTISA-1:0]}),
        .shifted_sig(by_wire_16_mantisa_shifted)
    );

    assign ax_wire_16 = (ax_wire_16_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_16_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ax_wire_16_mantisa_shifted};
    assign ay_wire_16 = (ay_wire_16_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_16_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, ay_wire_16_mantisa_shifted};
    assign bx_wire_16 = (bx_wire_16_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_16_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, bx_wire_16_mantisa_shifted};
    assign by_wire_16 = (by_wire_16_num[`BFLOAT_DWIDTH-1]==1'b1) ? -{{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_16_mantisa_shifted} : {{`DSP_X_ZERO_PAD_INPUT_WIDTH{1'b0}}, by_wire_16_mantisa_shifted};    
  
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] chainout_temp_16;
    wire [`DSP_AVA_OUTPUT_WIDTH-1:0] result_temp_16;

    assign dsp_result[16*`DSP_USED_OUTPUT_WIDTH-1:(16-1)*`DSP_USED_OUTPUT_WIDTH] = result_temp_16[`DSP_USED_OUTPUT_WIDTH-1:0];

    wire reset_dsp_16;
    assign reset_dsp_16 = ~out_data_available_barrel_shifter_ax_16;

    dsp_block_18_18_int_sop_2 dsp_16 (
        .clk(clk),
        .aclr(reset_dsp_16),
        .ax(ax_wire_16),
        .ay(ay_wire_16),
        .bx(bx_wire_16),
        .by(by_wire_16),
        .chainin(chainout_temp_15),
        .chainout(chainout_temp_16),
        .result(result_temp_16)
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
        .inp8(ax_wire_9_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp9(ax_wire_10_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp10(ax_wire_11_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp11(ax_wire_12_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp12(ax_wire_13_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp13(ax_wire_14_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp14(ax_wire_15_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp15(ax_wire_16_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp16(ay_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp17(ay_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp18(ay_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp19(ay_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp20(ay_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp21(ay_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp22(ay_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp23(ay_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp24(ay_wire_9_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp25(ay_wire_10_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp26(ay_wire_11_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp27(ay_wire_12_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp28(ay_wire_13_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp29(ay_wire_14_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp30(ay_wire_15_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp31(ay_wire_16_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp32(bx_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp33(bx_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp34(bx_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp35(bx_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp36(bx_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp37(bx_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp38(bx_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp39(bx_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp40(bx_wire_9_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp41(bx_wire_10_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp42(bx_wire_11_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp43(bx_wire_12_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp44(bx_wire_13_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp45(bx_wire_14_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp46(bx_wire_15_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp47(bx_wire_16_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp48(by_wire_1_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp49(by_wire_2_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp50(by_wire_3_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp51(by_wire_4_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp52(by_wire_5_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp53(by_wire_6_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp54(by_wire_7_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp55(by_wire_8_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp56(by_wire_9_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp57(by_wire_10_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp58(by_wire_11_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp59(by_wire_12_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp60(by_wire_13_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp61(by_wire_14_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp62(by_wire_15_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
        .inp63(by_wire_16_num[`BFLOAT_EXP+`BFLOAT_MANTISA-1:`BFLOAT_MANTISA]),
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
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp0,
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp1,
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp2,
    input[`DSP_USED_OUTPUT_WIDTH*`NUM_LDPES-1:0] inp3,
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

    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_0_stage_1;
    wire[`NUM_LDPES-1:0] out_data_available_0_stage_1;

    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_initial_0 (
              .a(inp0[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .b(inp1[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .clk(clk),
              .reset(reset_reduction_mvm[i-1]),
              .start(start[i-1]),
              .out_data_available(out_data_available_0_stage_1[i-1]),
              .sum(reduction_output_0_stage_1[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH])
            );
        end
    endgenerate
    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_1_stage_1;
    wire[`NUM_LDPES-1:0] out_data_available_1_stage_1;

    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_initial_1 (
              .a(inp2[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .b(inp3[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH]),
              .clk(clk),
              .reset(reset_reduction_mvm[i-1]),
              .start(start[i-1]),
              .out_data_available(out_data_available_1_stage_1[i-1]),
              .sum(reduction_output_1_stage_1[i*`DSP_USED_OUTPUT_WIDTH-1:(i-1)*`DSP_USED_OUTPUT_WIDTH])
            );
        end
    endgenerate

    wire[(`DSP_USED_OUTPUT_WIDTH)*`NUM_LDPES-1:0] reduction_output_0_stage_2;
    wire[`NUM_LDPES-1:0] out_data_available_0_stage_2;

    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder #(.INPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH),.OUTPUT_WIDTH(`DSP_USED_OUTPUT_WIDTH)) adder_units_0_stage_1 (
              .a(reduction_output_0_stage_1[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)]),
              .b(reduction_output_1_stage_1[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)]),
              .clk(clk),
              .reset(reset_reduction_mvm[i-1]),
              .start(out_data_available_0_stage_1[i-1]),
              .out_data_available(out_data_available_0_stage_2[i-1]),
              .sum(reduction_output_0_stage_2[i*(`DSP_USED_OUTPUT_WIDTH)-1:(i-1)*(`DSP_USED_OUTPUT_WIDTH)])
            );
        end
    endgenerate

assign result_mvm_final_stage[1*`DSP_USED_OUTPUT_WIDTH-1:0*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[1*(`DSP_USED_OUTPUT_WIDTH)-1:0*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[2*`DSP_USED_OUTPUT_WIDTH-1:1*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[2*(`DSP_USED_OUTPUT_WIDTH)-1:1*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[3*`DSP_USED_OUTPUT_WIDTH-1:2*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[3*(`DSP_USED_OUTPUT_WIDTH)-1:2*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[4*`DSP_USED_OUTPUT_WIDTH-1:3*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[4*(`DSP_USED_OUTPUT_WIDTH)-1:3*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[5*`DSP_USED_OUTPUT_WIDTH-1:4*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[5*(`DSP_USED_OUTPUT_WIDTH)-1:4*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[6*`DSP_USED_OUTPUT_WIDTH-1:5*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[6*(`DSP_USED_OUTPUT_WIDTH)-1:5*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[7*`DSP_USED_OUTPUT_WIDTH-1:6*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[7*(`DSP_USED_OUTPUT_WIDTH)-1:6*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[8*`DSP_USED_OUTPUT_WIDTH-1:7*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[8*(`DSP_USED_OUTPUT_WIDTH)-1:7*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[9*`DSP_USED_OUTPUT_WIDTH-1:8*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[9*(`DSP_USED_OUTPUT_WIDTH)-1:8*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[10*`DSP_USED_OUTPUT_WIDTH-1:9*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[10*(`DSP_USED_OUTPUT_WIDTH)-1:9*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[11*`DSP_USED_OUTPUT_WIDTH-1:10*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[11*(`DSP_USED_OUTPUT_WIDTH)-1:10*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[12*`DSP_USED_OUTPUT_WIDTH-1:11*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[12*(`DSP_USED_OUTPUT_WIDTH)-1:11*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[13*`DSP_USED_OUTPUT_WIDTH-1:12*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[13*(`DSP_USED_OUTPUT_WIDTH)-1:12*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[14*`DSP_USED_OUTPUT_WIDTH-1:13*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[14*(`DSP_USED_OUTPUT_WIDTH)-1:13*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[15*`DSP_USED_OUTPUT_WIDTH-1:14*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[15*(`DSP_USED_OUTPUT_WIDTH)-1:14*(`DSP_USED_OUTPUT_WIDTH)];
assign result_mvm_final_stage[16*`DSP_USED_OUTPUT_WIDTH-1:15*`DSP_USED_OUTPUT_WIDTH] = reduction_output_0_stage_2[16*(`DSP_USED_OUTPUT_WIDTH)-1:15*(`DSP_USED_OUTPUT_WIDTH)];
assign out_data_available = out_data_available_0_stage_2;
endmodule
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

////////////////////////////////////////////////////////////////////////////////
// THIS FILE WAS AUTOMATICALLY GENERATED FROM floating_pt.v.mako
// DO NOT EDIT
////////////////////////////////////////////////////////////////////////////////


module exponent_comparator_tree_ldpe (
    input[`BFLOAT_EXP-1:0] inp0,
    input[`BFLOAT_EXP-1:0] inp1,
    input[`BFLOAT_EXP-1:0] inp2,
    input[`BFLOAT_EXP-1:0] inp3,
    input[`BFLOAT_EXP-1:0] inp4,
    input[`BFLOAT_EXP-1:0] inp5,
    input[`BFLOAT_EXP-1:0] inp6,
    input[`BFLOAT_EXP-1:0] inp7,
    input[`BFLOAT_EXP-1:0] inp8,
    input[`BFLOAT_EXP-1:0] inp9,
    input[`BFLOAT_EXP-1:0] inp10,
    input[`BFLOAT_EXP-1:0] inp11,
    input[`BFLOAT_EXP-1:0] inp12,
    input[`BFLOAT_EXP-1:0] inp13,
    input[`BFLOAT_EXP-1:0] inp14,
    input[`BFLOAT_EXP-1:0] inp15,
    input[`BFLOAT_EXP-1:0] inp16,
    input[`BFLOAT_EXP-1:0] inp17,
    input[`BFLOAT_EXP-1:0] inp18,
    input[`BFLOAT_EXP-1:0] inp19,
    input[`BFLOAT_EXP-1:0] inp20,
    input[`BFLOAT_EXP-1:0] inp21,
    input[`BFLOAT_EXP-1:0] inp22,
    input[`BFLOAT_EXP-1:0] inp23,
    input[`BFLOAT_EXP-1:0] inp24,
    input[`BFLOAT_EXP-1:0] inp25,
    input[`BFLOAT_EXP-1:0] inp26,
    input[`BFLOAT_EXP-1:0] inp27,
    input[`BFLOAT_EXP-1:0] inp28,
    input[`BFLOAT_EXP-1:0] inp29,
    input[`BFLOAT_EXP-1:0] inp30,
    input[`BFLOAT_EXP-1:0] inp31,
    input[`BFLOAT_EXP-1:0] inp32,
    input[`BFLOAT_EXP-1:0] inp33,
    input[`BFLOAT_EXP-1:0] inp34,
    input[`BFLOAT_EXP-1:0] inp35,
    input[`BFLOAT_EXP-1:0] inp36,
    input[`BFLOAT_EXP-1:0] inp37,
    input[`BFLOAT_EXP-1:0] inp38,
    input[`BFLOAT_EXP-1:0] inp39,
    input[`BFLOAT_EXP-1:0] inp40,
    input[`BFLOAT_EXP-1:0] inp41,
    input[`BFLOAT_EXP-1:0] inp42,
    input[`BFLOAT_EXP-1:0] inp43,
    input[`BFLOAT_EXP-1:0] inp44,
    input[`BFLOAT_EXP-1:0] inp45,
    input[`BFLOAT_EXP-1:0] inp46,
    input[`BFLOAT_EXP-1:0] inp47,
    input[`BFLOAT_EXP-1:0] inp48,
    input[`BFLOAT_EXP-1:0] inp49,
    input[`BFLOAT_EXP-1:0] inp50,
    input[`BFLOAT_EXP-1:0] inp51,
    input[`BFLOAT_EXP-1:0] inp52,
    input[`BFLOAT_EXP-1:0] inp53,
    input[`BFLOAT_EXP-1:0] inp54,
    input[`BFLOAT_EXP-1:0] inp55,
    input[`BFLOAT_EXP-1:0] inp56,
    input[`BFLOAT_EXP-1:0] inp57,
    input[`BFLOAT_EXP-1:0] inp58,
    input[`BFLOAT_EXP-1:0] inp59,
    input[`BFLOAT_EXP-1:0] inp60,
    input[`BFLOAT_EXP-1:0] inp61,
    input[`BFLOAT_EXP-1:0] inp62,
    input[`BFLOAT_EXP-1:0] inp63,
    output [`BFLOAT_EXP-1:0] result_final_stage,
	output out_data_available,
    
    //CONTROL SIGNALS
    input clk,
    input reset,
	input start
);

/*
	reg[3:0] num_cycles_comparator;

    always@(posedge clk) begin
        if((reset==1'b1) || (start==1'b0)) begin
            num_cycles_comparator<=0;
            out_data_available<=0;
        end
        else begin
            if(num_cycles_comparator==`NUM_COMPARATOR_TREE_CYCLES-1) begin
                out_data_available<=1;
            end
            else begin
                num_cycles_comparator <= num_cycles_comparator + 1;
            end
        end
    end
*/


    wire[(`BFLOAT_EXP)-1:0] comparator_output_0_stage_1;
	wire out_data_available_0_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_0 (
        .a(inp0),
        .b(inp1),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_0_stage_1),
        .out(comparator_output_0_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_1_stage_1;
	wire out_data_available_1_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_1 (
        .a(inp2),
        .b(inp3),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_1_stage_1),
        .out(comparator_output_1_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_2_stage_1;
	wire out_data_available_2_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_2 (
        .a(inp4),
        .b(inp5),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_2_stage_1),
        .out(comparator_output_2_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_3_stage_1;
	wire out_data_available_3_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_3 (
        .a(inp6),
        .b(inp7),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_3_stage_1),
        .out(comparator_output_3_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_4_stage_1;
	wire out_data_available_4_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_4 (
        .a(inp8),
        .b(inp9),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_4_stage_1),
        .out(comparator_output_4_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_5_stage_1;
	wire out_data_available_5_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_5 (
        .a(inp10),
        .b(inp11),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_5_stage_1),
        .out(comparator_output_5_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_6_stage_1;
	wire out_data_available_6_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_6 (
        .a(inp12),
        .b(inp13),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_6_stage_1),
        .out(comparator_output_6_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_7_stage_1;
	wire out_data_available_7_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_7 (
        .a(inp14),
        .b(inp15),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_7_stage_1),
        .out(comparator_output_7_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_8_stage_1;
	wire out_data_available_8_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_8 (
        .a(inp16),
        .b(inp17),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_8_stage_1),
        .out(comparator_output_8_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_9_stage_1;
	wire out_data_available_9_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_9 (
        .a(inp18),
        .b(inp19),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_9_stage_1),
        .out(comparator_output_9_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_10_stage_1;
	wire out_data_available_10_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_10 (
        .a(inp20),
        .b(inp21),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_10_stage_1),
        .out(comparator_output_10_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_11_stage_1;
	wire out_data_available_11_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_11 (
        .a(inp22),
        .b(inp23),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_11_stage_1),
        .out(comparator_output_11_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_12_stage_1;
	wire out_data_available_12_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_12 (
        .a(inp24),
        .b(inp25),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_12_stage_1),
        .out(comparator_output_12_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_13_stage_1;
	wire out_data_available_13_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_13 (
        .a(inp26),
        .b(inp27),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_13_stage_1),
        .out(comparator_output_13_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_14_stage_1;
	wire out_data_available_14_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_14 (
        .a(inp28),
        .b(inp29),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_14_stage_1),
        .out(comparator_output_14_stage_1)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_15_stage_1;
	wire out_data_available_15_stage_1;
  
    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_15 (
        .a(inp30),
        .b(inp31),
        .clk(clk),
        .reset(reset),
		.start(start),
		.out_data_available(out_data_available_15_stage_1),
        .out(comparator_output_15_stage_1)
    );


    wire[(`BFLOAT_EXP)-1:0] comparator_output_0_stage_2;
	wire out_data_available_0_stage_2;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_0_stage_1 (
        .a(comparator_output_0_stage_1),
        .b(comparator_output_1_stage_1),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_1),
		.out_data_available(out_data_available_0_stage_2),
        .out(comparator_output_0_stage_2)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_1_stage_2;
	wire out_data_available_1_stage_2;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_1_stage_1 (
        .a(comparator_output_2_stage_1),
        .b(comparator_output_3_stage_1),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_1),
		.out_data_available(out_data_available_1_stage_2),
        .out(comparator_output_1_stage_2)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_2_stage_2;
	wire out_data_available_2_stage_2;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_2_stage_1 (
        .a(comparator_output_4_stage_1),
        .b(comparator_output_5_stage_1),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_1),
		.out_data_available(out_data_available_2_stage_2),
        .out(comparator_output_2_stage_2)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_3_stage_2;
	wire out_data_available_3_stage_2;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_3_stage_1 (
        .a(comparator_output_6_stage_1),
        .b(comparator_output_7_stage_1),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_1),
		.out_data_available(out_data_available_3_stage_2),
        .out(comparator_output_3_stage_2)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_4_stage_2;
	wire out_data_available_4_stage_2;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_4_stage_1 (
        .a(comparator_output_8_stage_1),
        .b(comparator_output_9_stage_1),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_1),
		.out_data_available(out_data_available_4_stage_2),
        .out(comparator_output_4_stage_2)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_5_stage_2;
	wire out_data_available_5_stage_2;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_5_stage_1 (
        .a(comparator_output_10_stage_1),
        .b(comparator_output_11_stage_1),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_1),
		.out_data_available(out_data_available_5_stage_2),
        .out(comparator_output_5_stage_2)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_6_stage_2;
	wire out_data_available_6_stage_2;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_6_stage_1 (
        .a(comparator_output_12_stage_1),
        .b(comparator_output_13_stage_1),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_1),
		.out_data_available(out_data_available_6_stage_2),
        .out(comparator_output_6_stage_2)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_7_stage_2;
	wire out_data_available_7_stage_2;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_7_stage_1 (
        .a(comparator_output_14_stage_1),
        .b(comparator_output_15_stage_1),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_1),
		.out_data_available(out_data_available_7_stage_2),
        .out(comparator_output_7_stage_2)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_0_stage_3;
	wire out_data_available_0_stage_3;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_0_stage_2 (
        .a(comparator_output_0_stage_2),
        .b(comparator_output_1_stage_2),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_2),
		.out_data_available(out_data_available_0_stage_3),
        .out(comparator_output_0_stage_3)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_1_stage_3;
	wire out_data_available_1_stage_3;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_1_stage_2 (
        .a(comparator_output_2_stage_2),
        .b(comparator_output_3_stage_2),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_2),
		.out_data_available(out_data_available_1_stage_3),
        .out(comparator_output_1_stage_3)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_2_stage_3;
	wire out_data_available_2_stage_3;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_2_stage_2 (
        .a(comparator_output_4_stage_2),
        .b(comparator_output_5_stage_2),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_2),
		.out_data_available(out_data_available_2_stage_3),
        .out(comparator_output_2_stage_3)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_3_stage_3;
	wire out_data_available_3_stage_3;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_3_stage_2 (
        .a(comparator_output_6_stage_2),
        .b(comparator_output_7_stage_2),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_2),
		.out_data_available(out_data_available_3_stage_3),
        .out(comparator_output_3_stage_3)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_0_stage_4;
	wire out_data_available_0_stage_4;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_0_stage_3 (
        .a(comparator_output_0_stage_3),
        .b(comparator_output_1_stage_3),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_3),
		.out_data_available(out_data_available_0_stage_4),
        .out(comparator_output_0_stage_4)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_1_stage_4;
	wire out_data_available_1_stage_4;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_1_stage_3 (
        .a(comparator_output_2_stage_3),
        .b(comparator_output_3_stage_3),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_3),
		.out_data_available(out_data_available_1_stage_4),
        .out(comparator_output_1_stage_4)
    );

    wire[(`BFLOAT_EXP)-1:0] comparator_output_0_stage_5;
	wire out_data_available_0_stage_5;

    comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_0_stage_4 (
        .a(comparator_output_0_stage_4),
        .b(comparator_output_1_stage_4),
        .clk(clk),
        .reset(reset),
		.start(out_data_available_0_stage_4),
		.out_data_available(out_data_available_0_stage_5),
        .out(comparator_output_0_stage_5)
    );



assign result_final_stage = comparator_output_0_stage_5;
assign out_data_available =  out_data_available_0_stage_5;

endmodule


module exponent_comparator_tree_tile (
    input[`BFLOAT_EXP*`NUM_LDPES-1:0] inp0,
    input[`BFLOAT_EXP*`NUM_LDPES-1:0] inp1,
    input[`BFLOAT_EXP*`NUM_LDPES-1:0] inp2,
    input[`BFLOAT_EXP*`NUM_LDPES-1:0] inp3,
    output [`BFLOAT_EXP*`NUM_LDPES-1:0] result_final_stage,
	output [`NUM_LDPES-1:0] out_data_available,
    
    //CONTROL SIGNALS
    input clk,
    input[`NUM_LDPES-1:0] reset,
	input[`NUM_LDPES-1:0] start
);

	
/*
	reg[3:0] num_cycles_comparator;
    always@(posedge clk) begin
        if((reset[0]==1'b1) || (start[0]==1'b0)) begin
            num_cycles_comparator<=0;
            out_data_available<=0;
        end
        else begin
            if(num_cycles_comparator==`NUM_COMPARATOR_TREE_CYCLES_FOR_TILE-1) begin
                out_data_available<={`NUM_LDPES{1'b1}};
            end
            else begin
                num_cycles_comparator <= num_cycles_comparator + 1;
            end
        end
    end
*/
genvar i;

    wire[(`BFLOAT_EXP)*`NUM_LDPES-1:0] comparator_output_0_stage_1;
	wire[`NUM_LDPES-1:0] out_data_available_0_stage_1;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_0 (
              .a(inp0[i*`BFLOAT_EXP-1:(i-1)*`BFLOAT_EXP]),
              .b(inp1[i*`BFLOAT_EXP-1:(i-1)*`BFLOAT_EXP]),
              .clk(clk),
              .reset(reset[i-1]),
			  .start(start[i-1]),
			  .out_data_available(out_data_available_0_stage_1[i-1]),
              .out(comparator_output_0_stage_1[i*(`BFLOAT_EXP)-1:(i-1)*(`BFLOAT_EXP)])
            );
        end
    endgenerate
    wire[(`BFLOAT_EXP)*`NUM_LDPES-1:0] comparator_output_1_stage_1;
	wire[`NUM_LDPES-1:0] out_data_available_1_stage_1;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_initial_1 (
              .a(inp2[i*`BFLOAT_EXP-1:(i-1)*`BFLOAT_EXP]),
              .b(inp3[i*`BFLOAT_EXP-1:(i-1)*`BFLOAT_EXP]),
              .clk(clk),
              .reset(reset[i-1]),
			  .start(start[i-1]),
			  .out_data_available(out_data_available_1_stage_1[i-1]),
              .out(comparator_output_1_stage_1[i*(`BFLOAT_EXP)-1:(i-1)*(`BFLOAT_EXP)])
            );
        end
    endgenerate

    wire[(`BFLOAT_EXP)*`NUM_LDPES-1:0] comparator_output_0_stage_2;
	wire[`NUM_LDPES-1:0] out_data_available_0_stage_2;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           comparator #(.DWIDTH(`BFLOAT_EXP)) comparator_units_0_stage_1 (
              .a(comparator_output_0_stage_1[i*(`BFLOAT_EXP)-1:(i-1)*(`BFLOAT_EXP)]),
              .b(comparator_output_1_stage_1[i*(`BFLOAT_EXP)-1:(i-1)*(`BFLOAT_EXP)]),
              .clk(clk),
              .reset(reset[i-1]),
			  .start(out_data_available_0_stage_1[i-1]),
			  .out_data_available(out_data_available_0_stage_2[i-1]),
              .out(comparator_output_0_stage_2[i*(`BFLOAT_EXP)-1:(i-1)*(`BFLOAT_EXP)])
            );
        end
    endgenerate

assign result_final_stage[1*`BFLOAT_EXP-1:0*`BFLOAT_EXP] = comparator_output_0_stage_2[1*(`BFLOAT_EXP)-1:0*(`BFLOAT_EXP)];
assign result_final_stage[2*`BFLOAT_EXP-1:1*`BFLOAT_EXP] = comparator_output_0_stage_2[2*(`BFLOAT_EXP)-1:1*(`BFLOAT_EXP)];
assign result_final_stage[3*`BFLOAT_EXP-1:2*`BFLOAT_EXP] = comparator_output_0_stage_2[3*(`BFLOAT_EXP)-1:2*(`BFLOAT_EXP)];
assign result_final_stage[4*`BFLOAT_EXP-1:3*`BFLOAT_EXP] = comparator_output_0_stage_2[4*(`BFLOAT_EXP)-1:3*(`BFLOAT_EXP)];
assign result_final_stage[5*`BFLOAT_EXP-1:4*`BFLOAT_EXP] = comparator_output_0_stage_2[5*(`BFLOAT_EXP)-1:4*(`BFLOAT_EXP)];
assign result_final_stage[6*`BFLOAT_EXP-1:5*`BFLOAT_EXP] = comparator_output_0_stage_2[6*(`BFLOAT_EXP)-1:5*(`BFLOAT_EXP)];
assign result_final_stage[7*`BFLOAT_EXP-1:6*`BFLOAT_EXP] = comparator_output_0_stage_2[7*(`BFLOAT_EXP)-1:6*(`BFLOAT_EXP)];
assign result_final_stage[8*`BFLOAT_EXP-1:7*`BFLOAT_EXP] = comparator_output_0_stage_2[8*(`BFLOAT_EXP)-1:7*(`BFLOAT_EXP)];
assign result_final_stage[9*`BFLOAT_EXP-1:8*`BFLOAT_EXP] = comparator_output_0_stage_2[9*(`BFLOAT_EXP)-1:8*(`BFLOAT_EXP)];
assign result_final_stage[10*`BFLOAT_EXP-1:9*`BFLOAT_EXP] = comparator_output_0_stage_2[10*(`BFLOAT_EXP)-1:9*(`BFLOAT_EXP)];
assign result_final_stage[11*`BFLOAT_EXP-1:10*`BFLOAT_EXP] = comparator_output_0_stage_2[11*(`BFLOAT_EXP)-1:10*(`BFLOAT_EXP)];
assign result_final_stage[12*`BFLOAT_EXP-1:11*`BFLOAT_EXP] = comparator_output_0_stage_2[12*(`BFLOAT_EXP)-1:11*(`BFLOAT_EXP)];
assign result_final_stage[13*`BFLOAT_EXP-1:12*`BFLOAT_EXP] = comparator_output_0_stage_2[13*(`BFLOAT_EXP)-1:12*(`BFLOAT_EXP)];
assign result_final_stage[14*`BFLOAT_EXP-1:13*`BFLOAT_EXP] = comparator_output_0_stage_2[14*(`BFLOAT_EXP)-1:13*(`BFLOAT_EXP)];
assign result_final_stage[15*`BFLOAT_EXP-1:14*`BFLOAT_EXP] = comparator_output_0_stage_2[15*(`BFLOAT_EXP)-1:14*(`BFLOAT_EXP)];
assign result_final_stage[16*`BFLOAT_EXP-1:15*`BFLOAT_EXP] = comparator_output_0_stage_2[16*(`BFLOAT_EXP)-1:15*(`BFLOAT_EXP)];
assign out_data_available = out_data_available_0_stage_2;
endmodule

module comparator #(parameter DWIDTH = `BFLOAT_EXP) (
    input[DWIDTH-1:0] a,
    input[DWIDTH-1:0] b,
    input reset,
	input start,
    input clk,
    output reg[DWIDTH-1:0] out,
	output reg out_data_available
);
    always@(posedge clk) begin
        if(reset==1'b1 || start==1'b0) begin
            out <= a;
			out_data_available <= 0;
        end
        else begin
            out <= (a>b) ? a : b;
			out_data_available <= 1;
        end
    end
endmodule

module fp16_to_msfp11 (input clk, input [15:0] a , input rst, input start, output reg [10:0] b, output reg out_data_available);

reg [10:0]b_temp;

always @ (*) begin

if ( a [14: 0] == 15'b0 ) begin //signed zero
	b_temp [10] = a[15]; //sign bit
	b_temp [9:0] = 7'b0000000; //EXPONENT AND MANTISSA
end

else begin
 	
	b_temp [4:0] = a[9:5]; //MANTISSA
	b_temp [9:5] = a[14:10]; //EXPONENT NOTE- EXPONENT SIZE IS SAME IN BOTH
	b_temp [10] = a[15]; //SIGN
	end
end

always@(posedge clk) begin
	if((rst==1'b1) || (start==1'b0)) begin
		b <= 'bX;
		out_data_available <= 0;
	end
	else begin
		b <= b_temp;
		out_data_available <= 1;
	end
end


endmodule


module msfp11_to_fp16 (input reset, input start, input clk, input [10:0] a , output reg [15:0] b, output reg out_data_available);

reg [15:0]b_temp;
reg [3:0] j;
reg [2:0] k;
reg [2:0] k_temp;

always @ (*) begin

if ( a [9: 0] == 7'b0 ) begin //signed zero
	b_temp [15] = a[10]; //sign bit
	b_temp[14:0] = 15'b0;
end

else begin
/*
	if ( a[9:5] == 5'b0 ) begin //denormalized (covert to normalized)
		
		for (j=0; j<=4; j=j+1) begin
			if (a[j] == 1'b1) begin 
			    k_temp = j;	
			end
		end
		k = 1 - k_temp;

		b_temp [9:0] = ( (a [4:0] << (k+1'b1)) & 5'b11111 ) << 5; 
		//b_temp [14:10] =  5'd31 - 5'd31 - k; //PROBLEM - DISCUSS THIS ************ SHOULD BE +k
		b_temp [14:10] =  5'd31 - 5'd31 + k;
		b_temp [15] = a[10];
	end
*/
	if ( a[9:5] == 5'b11111 ) begin //Infinity/ NAN //removed else here
		b_temp [9:0] = a [4:0] << 5;
		b_temp [14:10] = 5'b11111;
		b_temp [15] = a[10];
	end

	else begin //Normalized Number
		b_temp [9:0] = a [4:0] << 5;
		b_temp [14:10] =  5'd31 - 5'd31 + a[6:2];
		b_temp [15] = a[10];
	end
end
end

always@(posedge clk) begin
	if((reset==1'b1) || (start==1'b0)) begin
		out_data_available <= 0;
		b <= 'bX;
	end
	else begin
		b <= b_temp;
		out_data_available <= 1;
	end
end

endmodule
module FPAddSub(
		//bf16,
		clk,
		rst,
		a,
		b,
		operation,			// 0 add, 1 sub
		result,
		flags
	);
	//input bf16; //1 for Bfloat16, 0 for IEEE half precision

	// Clock and reset
	input clk ;										// Clock signal
	input rst ;										// Reset (active high, resets pipeline registers)
	
	// Input ports
	input [`DWIDTH-1:0] a ;								// Input A, a 32-bit floating point number
	input [`DWIDTH-1:0] b ;								// Input B, a 32-bit floating point number
	input operation ;								// Operation select signal
	
	// Output ports
	output [`DWIDTH-1:0] result ;						// Result of the operation
	output [4:0] flags ;							// Flags indicating exceptions according to IEEE754
	
	// Pipeline Registers
	//reg [79:0] pipe_1;							// Pipeline register PreAlign->Align1
	reg [2*`EXPONENT + 2*`DWIDTH + 5:0] pipe_1;							// Pipeline register PreAlign->Align1

	//reg [67:0] pipe_2;							// Pipeline register Align1->Align3
	//reg [2*`EXPONENT+ 2*`MANTISSA + 8:0] pipe_2;							// Pipeline register Align1->Align3
	wire [2*`EXPONENT+ 2*`MANTISSA + 8:0] pipe_2;

	//reg [76:0] pipe_3;	68						// Pipeline register Align1->Align3
	reg [2*`EXPONENT+ 2*`MANTISSA + 9:0] pipe_3;							// Pipeline register Align1->Align3

	//reg [69:0] pipe_4;							// Pipeline register Align3->Execute
	//reg [2*`EXPONENT+ 2*`MANTISSA + 9:0] pipe_4;							// Pipeline register Align3->Execute
	wire [2*`EXPONENT+ 2*`MANTISSA + 9:0] pipe_4;
	
	//reg [51:0] pipe_5;							// Pipeline register Execute->Normalize
	reg [`DWIDTH+`EXPONENT+11:0] pipe_5;							// Pipeline register Execute->Normalize

	//reg [56:0] pipe_6;							// Pipeline register Nomalize->NormalizeShift1
	//reg [`DWIDTH+`EXPONENT+16:0] pipe_6;							// Pipeline register Nomalize->NormalizeShift1
	wire [`DWIDTH+`EXPONENT+16:0] pipe_6;

	//reg [56:0] pipe_7;							// Pipeline register NormalizeShift2->NormalizeShift3
	//reg [`DWIDTH+`EXPONENT+16:0] pipe_7;							// Pipeline register NormalizeShift2->NormalizeShift3
	wire [`DWIDTH+`EXPONENT+16:0] pipe_7;
	//reg [54:0] pipe_8;							// Pipeline register NormalizeShift3->Round
	reg [`EXPONENT*2+`MANTISSA+15:0] pipe_8;							// Pipeline register NormalizeShift3->Round

	//reg [40:0] pipe_9;							// Pipeline register NormalizeShift3->Round
	//reg [`DWIDTH+8:0] pipe_9;							// Pipeline register NormalizeShift3->Round
	wire [`DWIDTH+8:0] pipe_9;

	// Internal wires between modules
	wire [`DWIDTH-2:0] Aout_0 ;							// A - sign
	wire [`DWIDTH-2:0] Bout_0 ;							// B - sign
	wire Opout_0 ;									// A's sign
	wire Sa_0 ;										// A's sign
	wire Sb_0 ;										// B's sign
	wire MaxAB_1 ;									// Indicates the larger of A and B(0/A, 1/B)
	wire [`EXPONENT-1:0] CExp_1 ;							// Common Exponent
	wire [`EXPONENT-1:0] Shift_1 ;							// Number of steps to smaller mantissa shift right (align)
	wire [`MANTISSA-1:0] Mmax_1 ;							// Larger mantissa
	wire [4:0] InputExc_0 ;						// Input numbers are exceptions
	wire [2*`EXPONENT-1:0] ShiftDet_0 ;
	wire [`MANTISSA-1:0] MminS_1 ;						// Smaller mantissa after 0/16 shift
	wire [`MANTISSA:0] MminS_2 ;						// Smaller mantissa after 0/4/8/12 shift
	wire [`MANTISSA:0] Mmin_3 ;							// Smaller mantissa after 0/1/2/3 shift
	wire [`DWIDTH:0] Sum_4 ;
	wire PSgn_4 ;
	wire Opr_4 ;
	wire [`EXPONENT-1:0] Shift_5 ;							// Number of steps to shift sum left (normalize)
	wire [`DWIDTH:0] SumS_5 ;							// Sum after 0/16 shift
	wire [`DWIDTH:0] SumS_6 ;							// Sum after 0/16 shift
	wire [`DWIDTH:0] SumS_7 ;							// Sum after 0/16 shift
	wire [`MANTISSA-1:0] NormM_8 ;						// Normalized mantissa
	wire [`EXPONENT:0] NormE_8;							// Adjusted exponent
	wire ZeroSum_8 ;								// Zero flag
	wire NegE_8 ;									// Flag indicating negative exponent
	wire R_8 ;										// Round bit
	wire S_8 ;										// Final sticky bit
	wire FG_8 ;										// Final sticky bit
	wire [`DWIDTH-1:0] P_int ;
	wire EOF ;
	
	// Prepare the operands for alignment and check for exceptions
	FPAddSub_PrealignModule PrealignModule
	(	// Inputs
		a, b, operation,
		// Outputs
		Sa_0, Sb_0, ShiftDet_0[2*`EXPONENT-1:0], InputExc_0[4:0], Aout_0[`DWIDTH-2:0], Bout_0[`DWIDTH-2:0], Opout_0) ;
		
	// Prepare the operands for alignment and check for exceptions
	FPAddSub_AlignModule AlignModule
	(	// Inputs
		pipe_1[2*`EXPONENT + 2*`DWIDTH + 4: 2*`EXPONENT +`DWIDTH + 6], pipe_1[2*`EXPONENT +`DWIDTH + 5 :  2*`EXPONENT +7], pipe_1[2*`EXPONENT+4:5],
		// Outputs
		CExp_1[`EXPONENT-1:0], MaxAB_1, Shift_1[`EXPONENT-1:0], MminS_1[`MANTISSA-1:0], Mmax_1[`MANTISSA-1:0]) ;	

	// Alignment Shift Stage 1
	FPAddSub_AlignShift1 AlignShift1
	(  // Inputs
		//bf16, 
		pipe_2[`MANTISSA-1:0], pipe_2[`EXPONENT+ 2*`MANTISSA + 4 : 2*`MANTISSA + 7],
		// Outputs
		MminS_2[`MANTISSA:0]) ;

	// Alignment Shift Stage 3 and compution of guard and sticky bits
	FPAddSub_AlignShift2 AlignShift2  
	(  // Inputs
		pipe_3[`MANTISSA:0], pipe_3[2*`MANTISSA+7:2*`MANTISSA+6],
		// Outputs
		Mmin_3[`MANTISSA:0]) ;
						
	// Perform mantissa addition
	FPAddSub_ExecutionModule ExecutionModule
	(  // Inputs
		pipe_4[`MANTISSA*2+5:`MANTISSA+6], pipe_4[`MANTISSA:0], pipe_4[2*`EXPONENT+ 2*`MANTISSA + 8], pipe_4[2*`EXPONENT+ 2*`MANTISSA + 7], pipe_4[2*`EXPONENT+ 2*`MANTISSA + 6], pipe_4[2*`EXPONENT+ 2*`MANTISSA + 9],
		// Outputs
		Sum_4[`DWIDTH:0], PSgn_4, Opr_4) ;
	
	// Prepare normalization of result
	FPAddSub_NormalizeModule NormalizeModule
	(  // Inputs
		pipe_5[`DWIDTH:0], 
		// Outputs
		SumS_5[`DWIDTH:0], Shift_5[4:0]) ;
					
	// Normalization Shift Stage 1
	FPAddSub_NormalizeShift1 NormalizeShift1
	(  // Inputs
		pipe_6[`DWIDTH:0], pipe_6[`DWIDTH+`EXPONENT+14:`DWIDTH+`EXPONENT+11],
		// Outputs
		SumS_7[`DWIDTH:0]) ;
		
	// Normalization Shift Stage 3 and final guard, sticky and round bits
	FPAddSub_NormalizeShift2 NormalizeShift2
	(  // Inputs
		pipe_7[`DWIDTH:0], pipe_7[`DWIDTH+`EXPONENT+5:`DWIDTH+6], pipe_7[`DWIDTH+`EXPONENT+15:`DWIDTH+`EXPONENT+11],
		// Outputs
		NormM_8[`MANTISSA-1:0], NormE_8[`EXPONENT:0], ZeroSum_8, NegE_8, R_8, S_8, FG_8) ;

	// Round and put result together
	FPAddSub_RoundModule RoundModule
	(  // Inputs
		 pipe_8[3], pipe_8[4+`EXPONENT:4], pipe_8[`EXPONENT+`MANTISSA+4:5+`EXPONENT], pipe_8[1], pipe_8[0], pipe_8[`EXPONENT*2+`MANTISSA+15], pipe_8[`EXPONENT*2+`MANTISSA+12], pipe_8[`EXPONENT*2+`MANTISSA+11], pipe_8[`EXPONENT*2+`MANTISSA+14], pipe_8[`EXPONENT*2+`MANTISSA+10], 
		// Outputs
		P_int[`DWIDTH-1:0], EOF) ;
	
	// Check for exceptions
	FPAddSub_ExceptionModule Exceptionmodule
	(  // Inputs
		pipe_9[8+`DWIDTH:9], pipe_9[8], pipe_9[7], pipe_9[6], pipe_9[5:1], pipe_9[0], 
		// Outputs
		result[`DWIDTH-1:0], flags[4:0]) ;			
	

assign pipe_2 = {pipe_1[2*`EXPONENT + 2*`DWIDTH + 5], pipe_1[2*`EXPONENT +6:2*`EXPONENT +5], MaxAB_1, CExp_1[`EXPONENT-1:0], Shift_1[`EXPONENT-1:0], Mmax_1[`MANTISSA-1:0], pipe_1[4:0], MminS_1[`MANTISSA-1:0]} ;
assign pipe_4 = {pipe_3[2*`EXPONENT+ 2*`MANTISSA + 9:`MANTISSA+1], Mmin_3[`MANTISSA:0]} ;
assign pipe_6 = {pipe_5[`DWIDTH+`EXPONENT+11], Shift_5[4:0], pipe_5[`DWIDTH+`EXPONENT+10:`DWIDTH+1], SumS_5[`DWIDTH:0]} ;
assign pipe_7 = {pipe_6[`DWIDTH+`EXPONENT+16:`DWIDTH+1], SumS_7[`DWIDTH:0]} ;
assign pipe_9 = {P_int[`DWIDTH-1:0], pipe_8[2], pipe_8[1], pipe_8[0], pipe_8[`EXPONENT+`MANTISSA+9:`EXPONENT+`MANTISSA+5], EOF} ;

	always @ (posedge clk) begin	
		if(rst) begin
			pipe_1 <= 0;
			//pipe_2 <= 0;
			pipe_3 <= 0;
			//pipe_4 <= 0;
			pipe_5 <= 0;
			//pipe_6 <= 0;
			//pipe_7 <= 0;
			pipe_8 <= 0;
			//pipe_9 <= 0;
		end 
		else begin
/* PIPE_1:
	[2*`EXPONENT + 2*`DWIDTH + 5]  Opout_0
	[2*`EXPONENT + 2*`DWIDTH + 4: 2*`EXPONENT +`DWIDTH + 6] A_out0
	[2*`EXPONENT +`DWIDTH + 5 :  2*`EXPONENT +7] Bout_0
	[2*`EXPONENT +6] Sa_0
	[2*`EXPONENT +5] Sb_0
	[2*`EXPONENT +4 : 5] ShiftDet_0
	[4:0] Input Exc
*/
			pipe_1 <= {Opout_0, Aout_0[`DWIDTH-2:0], Bout_0[`DWIDTH-2:0], Sa_0, Sb_0, ShiftDet_0[2*`EXPONENT -1:0], InputExc_0[4:0]} ;	
/* PIPE_2
[2*`EXPONENT+ 2*`MANTISSA + 8] operation
[2*`EXPONENT+ 2*`MANTISSA + 7] Sa_0
[2*`EXPONENT+ 2*`MANTISSA + 6] Sb_0
[2*`EXPONENT+ 2*`MANTISSA + 5] MaxAB_0
[2*`EXPONENT+ 2*`MANTISSA + 4:`EXPONENT+ 2*`MANTISSA + 5] CExp_0
[`EXPONENT+ 2*`MANTISSA + 4 : 2*`MANTISSA + 5] Shift_0
[2*`MANTISSA + 4:`MANTISSA + 5] Mmax_0
[`MANTISSA + 4 : `MANTISSA] InputExc_0
[`MANTISSA-1:0] MminS_1
*/
			//pipe_2 <= {pipe_1[2*`EXPONENT + 2*`DWIDTH + 5], pipe_1[2*`EXPONENT +6:2*`EXPONENT +5], MaxAB_1, CExp_1[`EXPONENT-1:0], Shift_1[`EXPONENT-1:0], Mmax_1[`MANTISSA-1:0], pipe_1[4:0], MminS_1[`MANTISSA-1:0]} ;	
/* PIPE_3
[2*`EXPONENT+ 2*`MANTISSA + 9] operation
[2*`EXPONENT+ 2*`MANTISSA + 8] Sa_0
[2*`EXPONENT+ 2*`MANTISSA + 7] Sb_0
[2*`EXPONENT+ 2*`MANTISSA + 6] MaxAB_0
[2*`EXPONENT+ 2*`MANTISSA + 5:`EXPONENT+ 2*`MANTISSA + 6] CExp_0
[`EXPONENT+ 2*`MANTISSA + 5 : 2*`MANTISSA + 6] Shift_0
[2*`MANTISSA + 5:`MANTISSA + 6] Mmax_0
[`MANTISSA + 5 : `MANTISSA + 1] InputExc_0
[`MANTISSA:0] MminS_2
*/
			pipe_3 <= {pipe_2[2*`EXPONENT+ 2*`MANTISSA + 8:`MANTISSA], MminS_2[`MANTISSA:0]} ;	
/* PIPE_4
[2*`EXPONENT+ 2*`MANTISSA + 9] operation
[2*`EXPONENT+ 2*`MANTISSA + 8] Sa_0
[2*`EXPONENT+ 2*`MANTISSA + 7] Sb_0
[2*`EXPONENT+ 2*`MANTISSA + 6] MaxAB_0
[2*`EXPONENT+ 2*`MANTISSA + 5:`EXPONENT+ 2*`MANTISSA + 6] CExp_0
[`EXPONENT+ 2*`MANTISSA + 5 : 2*`MANTISSA + 6] Shift_0
[2*`MANTISSA + 5:`MANTISSA + 6] Mmax_0
[`MANTISSA + 5 : `MANTISSA + 1] InputExc_0
[`MANTISSA:0] MminS_3
*/				
			//pipe_4 <= {pipe_3[2*`EXPONENT+ 2*`MANTISSA + 9:`MANTISSA+1], Mmin_3[`MANTISSA:0]} ;	
/* PIPE_5 :
[`DWIDTH+ `EXPONENT + 11] operation
[`DWIDTH+ `EXPONENT + 10] PSgn_4
[`DWIDTH+ `EXPONENT + 9] Opr_4
[`DWIDTH+ `EXPONENT + 8] Sa_0
[`DWIDTH+ `EXPONENT + 7] Sb_0
[`DWIDTH+ `EXPONENT + 6] MaxAB_0
[`DWIDTH+ `EXPONENT + 5 :`DWIDTH+6] CExp_0
[`DWIDTH+5:`DWIDTH+1] InputExc_0
[`DWIDTH:0] Sum_4
*/					
			pipe_5 <= {pipe_4[2*`EXPONENT+ 2*`MANTISSA + 9], PSgn_4, Opr_4, pipe_4[2*`EXPONENT+ 2*`MANTISSA + 8:`EXPONENT+ 2*`MANTISSA + 6], pipe_4[`MANTISSA+5:`MANTISSA+1], Sum_4[`DWIDTH:0]} ;
/* PIPE_6 :
[`DWIDTH+ `EXPONENT + 16] operation
[`DWIDTH+ `EXPONENT + 15:`DWIDTH+ `EXPONENT + 11] Shift_5
[`DWIDTH+ `EXPONENT + 10] PSgn_4
[`DWIDTH+ `EXPONENT + 9] Opr_4
[`DWIDTH+ `EXPONENT + 8] Sa_0
[`DWIDTH+ `EXPONENT + 7] Sb_0
[`DWIDTH+ `EXPONENT + 6] MaxAB_0
[`DWIDTH+ `EXPONENT + 5 :`DWIDTH+6] CExp_0
[`DWIDTH+5:`DWIDTH+1] InputExc_0
[`DWIDTH:0] Sum_4
*/				
			//pipe_6 <= {pipe_5[`DWIDTH+`EXPONENT+11], Shift_5[4:0], pipe_5[`DWIDTH+`EXPONENT+10:`DWIDTH+1], SumS_5[`DWIDTH:0]} ;	
/* PIPE_7 :
[`DWIDTH+ `EXPONENT + 16] operation
[`DWIDTH+ `EXPONENT + 15:`DWIDTH+ `EXPONENT + 11] Shift_5
[`DWIDTH+ `EXPONENT + 10] PSgn_4
[`DWIDTH+ `EXPONENT + 9] Opr_4
[`DWIDTH+ `EXPONENT + 8] Sa_0
[`DWIDTH+ `EXPONENT + 7] Sb_0
[`DWIDTH+ `EXPONENT + 6] MaxAB_0
[`DWIDTH+ `EXPONENT + 5 :`DWIDTH+6] CExp_0
[`DWIDTH+5:`DWIDTH+1] InputExc_0
[`DWIDTH:0] Sum_4
*/						
			//pipe_7 <= {pipe_6[`DWIDTH+`EXPONENT+16:`DWIDTH+1], SumS_7[`DWIDTH:0]} ;	
/* PIPE_8:
[2*`EXPONENT + `MANTISSA + 15] FG_8 
[2*`EXPONENT + `MANTISSA + 14] operation
[2*`EXPONENT + `MANTISSA + 13] PSgn_4
[2*`EXPONENT + `MANTISSA + 12] Sa_0
[2*`EXPONENT + `MANTISSA + 11] Sb_0
[2*`EXPONENT + `MANTISSA + 10] MaxAB_0
[2*`EXPONENT + `MANTISSA + 9:`EXPONENT + `MANTISSA + 10] CExp_0
[`EXPONENT + `MANTISSA + 9:`EXPONENT + `MANTISSA + 5] InputExc_8
[`EXPONENT + `MANTISSA + 4 :`EXPONENT + 5] NormM_8 
[`EXPONENT + 4 :4] NormE_8
[3] ZeroSum_8
[2] NegE_8
[1] R_8
[0] S_8
*/				
			pipe_8 <= {FG_8, pipe_7[`DWIDTH+`EXPONENT+16], pipe_7[`DWIDTH+`EXPONENT+10], pipe_7[`DWIDTH+`EXPONENT+8:`DWIDTH+1], NormM_8[`MANTISSA-1:0], NormE_8[`EXPONENT:0], ZeroSum_8, NegE_8, R_8, S_8} ;	
/* pipe_9:
[`DWIDTH + 8 :9] P_int
[8] NegE_8
[7] R_8
[6] S_8
[5:1] InputExc_8
[0] EOF
*/				
			//pipe_9 <= {P_int[`DWIDTH-1:0], pipe_8[2], pipe_8[1], pipe_8[0], pipe_8[`EXPONENT+`MANTISSA+9:`EXPONENT+`MANTISSA+5], EOF} ;	
		end
	end		
	
endmodule


//
// Description:	 	The pre-alignment module is responsible for taking the inputs
//							apart and checking the parts for exceptions.
//							The exponent difference is also calculated in this module.
//


module FPAddSub_PrealignModule(
		A,
		B,
		operation,
		Sa,
		Sb,
		ShiftDet,
		InputExc,
		Aout,
		Bout,
		Opout
	);
	
	// Input ports
	input [`DWIDTH-1:0] A ;										// Input A, a 32-bit floating point number
	input [`DWIDTH-1:0] B ;										// Input B, a 32-bit floating point number
	input operation ;
	
	// Output ports
	output Sa ;												// A's sign
	output Sb ;												// B's sign
	output [2*`EXPONENT-1:0] ShiftDet ;
	output [4:0] InputExc ;								// Input numbers are exceptions
	output [`DWIDTH-2:0] Aout ;
	output [`DWIDTH-2:0] Bout ;
	output Opout ;
	
	// Internal signals									// If signal is high...
	wire ANaN ;												// A is a NaN (Not-a-Number)
	wire BNaN ;												// B is a NaN
	wire AInf ;												// A is infinity
	wire BInf ;												// B is infinity
	wire [`EXPONENT-1:0] DAB ;										// ExpA - ExpB					
	wire [`EXPONENT-1:0] DBA ;										// ExpB - ExpA	
	
	assign ANaN = &(A[`DWIDTH-2:`DWIDTH-1-`EXPONENT]) & |(A[`MANTISSA-1:0]) ;		// All one exponent and not all zero mantissa - NaN
	assign BNaN = &(B[`DWIDTH-2:`DWIDTH-1-`EXPONENT]) & |(B[`MANTISSA-1:0]);		// All one exponent and not all zero mantissa - NaN
	assign AInf = &(A[`DWIDTH-2:`DWIDTH-1-`EXPONENT]) & ~|(A[`MANTISSA-1:0]) ;	// All one exponent and all zero mantissa - Infinity
	assign BInf = &(B[`DWIDTH-2:`DWIDTH-1-`EXPONENT]) & ~|(B[`MANTISSA-1:0]) ;	// All one exponent and all zero mantissa - Infinity
	
	// Put all flags into exception vector
	assign InputExc = {(ANaN | BNaN | AInf | BInf), ANaN, BNaN, AInf, BInf} ;
	
	//assign DAB = (A[30:23] - B[30:23]) ;
	//assign DBA = (B[30:23] - A[30:23]) ;
	assign DAB = (A[`DWIDTH-2:`MANTISSA] + ~(B[`DWIDTH-2:`MANTISSA]) + 1) ;
	assign DBA = (B[`DWIDTH-2:`MANTISSA] + ~(A[`DWIDTH-2:`MANTISSA]) + 1) ;
	
	assign Sa = A[`DWIDTH-1] ;									// A's sign bit
	assign Sb = B[`DWIDTH-1] ;									// B's sign	bit
	assign ShiftDet = {DBA[`EXPONENT-1:0], DAB[`EXPONENT-1:0]} ;		// Shift data
	assign Opout = operation ;
	assign Aout = A[`DWIDTH-2:0] ;
	assign Bout = B[`DWIDTH-2:0] ;
	
endmodule


//
// Description:	 	The alignment module determines the larger input operand and
//							sets the mantissas, shift and common exponent accordingly.
//


module FPAddSub_AlignModule (
		A,
		B,
		ShiftDet,
		CExp,
		MaxAB,
		Shift,
		Mmin,
		Mmax
	);
	
	// Input ports
	input [`DWIDTH-2:0] A ;								// Input A, a 32-bit floating point number
	input [`DWIDTH-2:0] B ;								// Input B, a 32-bit floating point number
	input [2*`EXPONENT-1:0] ShiftDet ;
	
	// Output ports
	output [`EXPONENT-1:0] CExp ;							// Common Exponent
	output MaxAB ;									// Incidates larger of A and B (0/A, 1/B)
	output [`EXPONENT-1:0] Shift ;							// Number of steps to smaller mantissa shift right
	output [`MANTISSA-1:0] Mmin ;							// Smaller mantissa 
	output [`MANTISSA-1:0] Mmax ;							// Larger mantissa
	
	// Internal signals
	//wire BOF ;										// Check for shifting overflow if B is larger
	//wire AOF ;										// Check for shifting overflow if A is larger
	
	assign MaxAB = (A[`DWIDTH-2:0] < B[`DWIDTH-2:0]) ;	
	//assign BOF = ShiftDet[9:5] < 25 ;		// Cannot shift more than 25 bits
	//assign AOF = ShiftDet[4:0] < 25 ;		// Cannot shift more than 25 bits
	
	// Determine final shift value
	//assign Shift = MaxAB ? (BOF ? ShiftDet[9:5] : 5'b11001) : (AOF ? ShiftDet[4:0] : 5'b11001) ;
	
	assign Shift = MaxAB ? ShiftDet[2*`EXPONENT-1:`EXPONENT] : ShiftDet[`EXPONENT-1:0] ;
	
	// Take out smaller mantissa and append shift space
	assign Mmin = MaxAB ? A[`MANTISSA-1:0] : B[`MANTISSA-1:0] ; 
	
	// Take out larger mantissa	
	assign Mmax = MaxAB ? B[`MANTISSA-1:0]: A[`MANTISSA-1:0] ;	
	
	// Common exponent
	assign CExp = (MaxAB ? B[`MANTISSA+`EXPONENT-1:`MANTISSA] : A[`MANTISSA+`EXPONENT-1:`MANTISSA]) ;		
	
endmodule


// Description:	 Alignment shift stage 1, performs 16|12|8|4 shift
//


// ONLY THIS MODULE IS HARDCODED for half precision fp16 and bfloat16
module FPAddSub_AlignShift1(
		//bf16,
		MminP,
		Shift,
		Mmin
	);
	
	// Input ports
	//input bf16;
	input [`MANTISSA-1:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [`EXPONENT-3:0] Shift ;						// Shift amount. Last 2 bits of shifting are done in next stage. Hence, we have [`EXPONENT - 2] bits
	
	// Output ports
	output [`MANTISSA:0] Mmin ;						// The smaller mantissa
	

	wire bf16;
	`ifdef BFLOAT16
	assign bf16 = 1'b1;
	`else
	assign bf16 = 1'b0;
	`endif 

	// Internal signals
	reg	  [`MANTISSA:0]		Lvl1;
	reg	  [`MANTISSA:0]		Lvl2;
	wire    [2*`MANTISSA+1:0]    Stage1;	
	integer           i;                // Loop variable

	wire [`MANTISSA:0] temp_0; 

assign temp_0 = 0;

	always @(*) begin
		if (bf16 == 1'b1) begin						
//hardcoding for bfloat16
	//For bfloat16, we can shift the mantissa by a max of 7 bits since mantissa has a width of 7. 
	//Hence if either, bit[3]/bit[4]/bit[5]/bit[6]/bit[7] is 1, we can make it 0. This corresponds to bits [5:1] in our updated shift which doesn't contain last 2 bits.
		//Lvl1 <= (Shift[1]|Shift[2]|Shift[3]|Shift[4]|Shift[5]) ? {temp_0} : {1'b1, MminP};  // MANTISSA + 1 width	
		Lvl1 <= (|Shift[`EXPONENT-3:1]) ? {temp_0} : {1'b1, MminP};  // MANTISSA + 1 width	
		end
		else begin
		//for half precision fp16, 10 bits can be shifted. Hence, only shifts till 10 (01010)can be made. 
		Lvl1 <= Shift[2] ? {temp_0} : {1'b1, MminP};
		end
	end
	
	assign Stage1 = { temp_0, Lvl1}; //2*MANTISSA + 2 width

	always @(*) begin    					// Rotate {0 | 4 } bits
	if(bf16 == 1'b1) begin
	  case (Shift[0])
			// Rotate by 0	
			1'b0:  Lvl2 <= Stage1[`MANTISSA:0];       			
			// Rotate by 4	
			1'b1:  begin for (i=0; i<=`MANTISSA; i=i+1) begin Lvl2[i] <= Stage1[i+4]; end Lvl2[`MANTISSA:`MANTISSA-3] <= 0; end
	  endcase
	end
	else begin
	  case (Shift[1:0])					// Rotate {0 | 4 | 8} bits
			// Rotate by 0	
			2'b00:  Lvl2 <= Stage1[`MANTISSA:0];       			
			// Rotate by 4	
			2'b01:  begin for (i=0; i<=`MANTISSA; i=i+1) begin Lvl2[i] <= Stage1[i+4]; end Lvl2[`MANTISSA:`MANTISSA-3] <= 0; end
			// Rotate by 8
			2'b10:  begin for (i=0; i<=`MANTISSA; i=i+1) begin Lvl2[i] <= Stage1[i+8]; end Lvl2[`MANTISSA:`MANTISSA-7] <= 0; end
			// Rotate by 12	
			2'b11: Lvl2[`MANTISSA: 0] <= 0; 
			//2'b11:  begin for (i=0; i<=`MANTISSA; i=i+1) begin Lvl2[i] <= Stage1[i+12]; end Lvl2[`MANTISSA:`MANTISSA-12] <= 0; end
	  endcase
	end
	end

	// Assign output to next shift stage
	assign Mmin = Lvl2;
	
endmodule


// Description:	 Alignment shift stage 2, performs 3|2|1 shift
//


module FPAddSub_AlignShift2(
		MminP,
		Shift,
		Mmin
	);
	
	// Input ports
	input [`MANTISSA:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [1:0] Shift ;						// Shift amount. Last 2 bits
	
	// Output ports
	output [`MANTISSA:0] Mmin ;						// The smaller mantissa
	
	// Internal Signal
	reg	  [`MANTISSA:0]		Lvl3;
	wire    [2*`MANTISSA+1:0]    Stage2;	
	integer           j;               // Loop variable
	
	assign Stage2 = {11'b0, MminP};

	always @(*) begin    // Rotate {0 | 1 | 2 | 3} bits
	  case (Shift[1:0])
			// Rotate by 0
			2'b00:  Lvl3 <= Stage2[`MANTISSA:0];   
			// Rotate by 1
			2'b01:  begin for (j=0; j<=`MANTISSA; j=j+1)  begin Lvl3[j] <= Stage2[j+1]; end Lvl3[`MANTISSA] <= 0; end 
			// Rotate by 2
			2'b10:  begin for (j=0; j<=`MANTISSA; j=j+1)  begin Lvl3[j] <= Stage2[j+2]; end Lvl3[`MANTISSA:`MANTISSA-1] <= 0; end 
			// Rotate by 3
			2'b11:  begin for (j=0; j<=`MANTISSA; j=j+1)  begin Lvl3[j] <= Stage2[j+3]; end Lvl3[`MANTISSA:`MANTISSA-2] <= 0; end 	  
	  endcase
	end
	
	// Assign output
	assign Mmin = Lvl3;						// Take out smaller mantissa				

endmodule


//
// Description:	 Module that executes the addition or subtraction on mantissas.
//


module FPAddSub_ExecutionModule(
		Mmax,
		Mmin,
		Sa,
		Sb,
		MaxAB,
		OpMode,
		Sum,
		PSgn,
		Opr
    );

	// Input ports
	input [`MANTISSA-1:0] Mmax ;					// The larger mantissa
	input [`MANTISSA:0] Mmin ;					// The smaller mantissa
	input Sa ;								// Sign bit of larger number
	input Sb ;								// Sign bit of smaller number
	input MaxAB ;							// Indicates the larger number (0/A, 1/B)
	input OpMode ;							// Operation to be performed (0/Add, 1/Sub)
	
	// Output ports
	output [`DWIDTH:0] Sum ;					// The result of the operation
	output PSgn ;							// The sign for the result
	output Opr ;							// The effective (performed) operation

	wire [`EXPONENT-1:0]temp_1;

	assign Opr = (OpMode^Sa^Sb); 		// Resolve sign to determine operation
	assign temp_1 = 0;
	// Perform effective operation
//SAMIDH_UNSURE 5--> 8

	assign Sum = (OpMode^Sa^Sb) ? ({1'b1, Mmax, temp_1} - {Mmin, temp_1}) : ({1'b1, Mmax, temp_1} + {Mmin, temp_1}) ;
	
	// Assign result sign
	assign PSgn = (MaxAB ? Sb : Sa) ;

endmodule


//
// Description:	 Determine the normalization shift amount and perform 16-shift
//


module FPAddSub_NormalizeModule(
		Sum,
		Mmin,
		Shift
    );

	// Input ports
	input [`DWIDTH:0] Sum ;					// Mantissa sum including hidden 1 and GRS
	
	// Output ports
	output [`DWIDTH:0] Mmin ;					// Mantissa after 16|0 shift
	output [4:0] Shift ;					// Shift amount
	//Changes in this doesn't matter since even Bfloat16 can't go beyond 7 shift to the mantissa (only 3 bits valid here)  
	// Determine normalization shift amount by finding leading nought
	assign Shift =  ( 
		Sum[16] ? 5'b00000 :	 
		Sum[15] ? 5'b00001 : 
		Sum[14] ? 5'b00010 : 
		Sum[13] ? 5'b00011 : 
		Sum[12] ? 5'b00100 : 
		Sum[11] ? 5'b00101 : 
		Sum[10] ? 5'b00110 : 
		Sum[9] ? 5'b00111 :
		Sum[8] ? 5'b01000 :
		Sum[7] ? 5'b01001 :
		Sum[6] ? 5'b01010 :
		Sum[5] ? 5'b01011 :
		Sum[4] ? 5'b01100 : 5'b01101
	//	Sum[19] ? 5'b01101 :
	//	Sum[18] ? 5'b01110 :
	//	Sum[17] ? 5'b01111 :
	//	Sum[16] ? 5'b10000 :
	//	Sum[15] ? 5'b10001 :
	//	Sum[14] ? 5'b10010 :
	//	Sum[13] ? 5'b10011 :
	//	Sum[12] ? 5'b10100 :
	//	Sum[11] ? 5'b10101 :
	//	Sum[10] ? 5'b10110 :
	//	Sum[9] ? 5'b10111 :
	//	Sum[8] ? 5'b11000 :
	//	Sum[7] ? 5'b11001 : 5'b11010
	);
	
	reg	  [`DWIDTH:0]		Lvl1;
	
	always @(*) begin
		// Rotate by 16?
		Lvl1 <= Shift[4] ? {Sum[8:0], 8'b00000000} : Sum; 
	end
	
	// Assign outputs
	assign Mmin = Lvl1;						// Take out smaller mantissa

endmodule


// Description:	 Normalization shift stage 1, performs 12|8|4|3|2|1|0 shift
//
//Hardcoding loop start and end values of i. To avoid ODIN limitations. i=`DWIDTH*2+1 wasn't working.


module FPAddSub_NormalizeShift1(
		MminP,
		Shift,
		Mmin
	);
	
	// Input ports
	input [`DWIDTH:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [3:0] Shift ;						// Shift amount
	
	// Output ports
	output [`DWIDTH:0] Mmin ;						// The smaller mantissa
	
	reg	  [`DWIDTH:0]		Lvl2;
	wire    [2*`DWIDTH+1:0]    Stage1;	
	reg	  [`DWIDTH:0]		Lvl3;
	wire    [2*`DWIDTH+1:0]    Stage2;	
	integer           i;               	// Loop variable
	
	assign Stage1 = {MminP, MminP};

	always @(*) begin    					// Rotate {0 | 4 | 8 | 12} bits
	  case (Shift[3:2])
			// Rotate by 0
			2'b00: Lvl2 <= Stage1[`DWIDTH:0];       		
			// Rotate by 4
			2'b01: begin for (i=33; i>=17; i=i-1) begin Lvl2[i-`DWIDTH-1] <= Stage1[i-4]; end Lvl2[3:0] <= 0; end
			// Rotate by 8
			2'b10: begin for (i=33; i>=17; i=i-1) begin Lvl2[i-`DWIDTH-1] <= Stage1[i-8]; end Lvl2[7:0] <= 0; end
			// Rotate by 12
			2'b11: begin for (i=33; i>=17; i=i-1) begin Lvl2[i-`DWIDTH-1] <= Stage1[i-12]; end Lvl2[11:0] <= 0; end
	  endcase
	end
	
	assign Stage2 = {Lvl2, Lvl2};

	always @(*) begin   				 		// Rotate {0 | 1 | 2 | 3} bits
	  case (Shift[1:0])
			// Rotate by 0
			2'b00:  Lvl3 <= Stage2[`DWIDTH:0];
			// Rotate by 1
			2'b01: begin for (i=33; i>=17; i=i-1) begin Lvl3[i-`DWIDTH-1] <= Stage2[i-1]; end Lvl3[0] <= 0; end 
			// Rotate by 2
			2'b10: begin for (i=33; i>=17; i=i-1) begin Lvl3[i-`DWIDTH-1] <= Stage2[i-2]; end Lvl3[1:0] <= 0; end
			// Rotate by 3
			2'b11: begin for (i=33; i>=17; i=i-1) begin Lvl3[i-`DWIDTH-1] <= Stage2[i-3]; end Lvl3[2:0] <= 0; end
	  endcase
	end
	
	// Assign outputs
	assign Mmin = Lvl3;						// Take out smaller mantissa			
	
endmodule


// Description:	 Normalization shift stage 2, calculates post-normalization
//						 mantissa and exponent, as well as the bits used in rounding		
//


module FPAddSub_NormalizeShift2(
		PSSum,
		CExp,
		Shift,
		NormM,
		NormE,
		ZeroSum,
		NegE,
		R,
		S,
		FG
	);
	
	// Input ports
	input [`DWIDTH:0] PSSum ;					// The Pre-Shift-Sum
	input [`EXPONENT-1:0] CExp ;
	input [4:0] Shift ;					// Amount to be shifted

	// Output ports
	output [`MANTISSA-1:0] NormM ;				// Normalized mantissa
	output [`EXPONENT:0] NormE ;					// Adjusted exponent
	output ZeroSum ;						// Zero flag
	output NegE ;							// Flag indicating negative exponent
	output R ;								// Round bit
	output S ;								// Final sticky bit
	output FG ;

	// Internal signals
	wire MSBShift ;						// Flag indicating that a second shift is needed
	wire [`EXPONENT:0] ExpOF ;					// MSB set in sum indicates overflow
	wire [`EXPONENT:0] ExpOK ;					// MSB not set, no adjustment
	
	// Calculate normalized exponent and mantissa, check for all-zero sum
	assign MSBShift = PSSum[`DWIDTH] ;		// Check MSB in unnormalized sum
	assign ZeroSum = ~|PSSum ;			// Check for all zero sum
	assign ExpOK = CExp - Shift ;		// Adjust exponent for new normalized mantissa
	assign NegE = ExpOK[`EXPONENT] ;			// Check for exponent overflow
	assign ExpOF = CExp - Shift + 1'b1 ;		// If MSB set, add one to exponent(x2)
	assign NormE = MSBShift ? ExpOF : ExpOK ;			// Check for exponent overflow
	assign NormM = PSSum[`DWIDTH-1:`EXPONENT+1] ;		// The new, normalized mantissa
	
	// Also need to compute sticky and round bits for the rounding stage
	assign FG = PSSum[`EXPONENT] ; 
	assign R = PSSum[`EXPONENT-1] ;
	assign S = |PSSum[`EXPONENT-2:0] ;
	
endmodule


// Description:	 Performs 'Round to nearest, tie to even'-rounding on the
//						 normalized mantissa according to the G, R, S bits. Calculates
//						 final result and checks for exponent overflow.
//


module FPAddSub_RoundModule(
		ZeroSum,
		NormE,
		NormM,
		R,
		S,
		G,
		Sa,
		Sb,
		Ctrl,
		MaxAB,
		Z,
		EOF
    );

	// Input ports
	input ZeroSum ;					// Sum is zero
	input [`EXPONENT:0] NormE ;				// Normalized exponent
	input [`MANTISSA-1:0] NormM ;				// Normalized mantissa
	input R ;							// Round bit
	input S ;							// Sticky bit
	input G ;
	input Sa ;							// A's sign bit
	input Sb ;							// B's sign bit
	input Ctrl ;						// Control bit (operation)
	input MaxAB ;
	
	// Output ports
	output [`DWIDTH-1:0] Z ;					// Final result
	output EOF ;
	
	// Internal signals
	wire [`MANTISSA:0] RoundUpM ;			// Rounded up sum with room for overflow
	wire [`MANTISSA-1:0] RoundM ;				// The final rounded sum
	wire [`EXPONENT:0] RoundE ;				// Rounded exponent (note extra bit due to poential overflow	)
	wire RoundUp ;						// Flag indicating that the sum should be rounded up
        wire FSgn;
	wire ExpAdd ;						// May have to add 1 to compensate for overflow 
	wire RoundOF ;						// Rounding overflow
	
	wire [`EXPONENT:0]temp_2;
	assign temp_2 = 0;
	// The cases where we need to round upwards (= adding one) in Round to nearest, tie to even
	assign RoundUp = (G & ((R | S) | NormM[0])) ;
	
	// Note that in the other cases (rounding down), the sum is already 'rounded'
	assign RoundUpM = (NormM + 1) ;								// The sum, rounded up by 1
	assign RoundM = (RoundUp ? RoundUpM[`MANTISSA-1:0] : NormM) ; 	// Compute final mantissa	
	assign RoundOF = RoundUp & RoundUpM[`MANTISSA] ; 				// Check for overflow when rounding up

	// Calculate post-rounding exponent
	assign ExpAdd = (RoundOF ? 1'b1 : 1'b0) ; 				// Add 1 to exponent to compensate for overflow
	assign RoundE = ZeroSum ? temp_2 : (NormE + ExpAdd) ; 							// Final exponent

	// If zero, need to determine sign according to rounding
	assign FSgn = (ZeroSum & (Sa ^ Sb)) | (ZeroSum ? (Sa & Sb & ~Ctrl) : ((~MaxAB & Sa) | ((Ctrl ^ Sb) & (MaxAB | Sa)))) ;

	// Assign final result
	assign Z = {FSgn, RoundE[`EXPONENT-1:0], RoundM[`MANTISSA-1:0]} ;
	
	// Indicate exponent overflow
	assign EOF = RoundE[`EXPONENT];
	
endmodule


//
// Description:	 Check the final result for exception conditions and set
//						 flags accordingly.
//


module FPAddSub_ExceptionModule(
		Z,
		NegE,
		R,
		S,
		InputExc,
		EOF,
		P,
		Flags
    );
	 
	// Input ports
	input [`DWIDTH-1:0] Z	;					// Final product
	input NegE ;						// Negative exponent?
	input R ;							// Round bit
	input S ;							// Sticky bit
	input [4:0] InputExc ;			// Exceptions in inputs A and B
	input EOF ;
	
	// Output ports
	output [`DWIDTH-1:0] P ;					// Final result
	output [4:0] Flags ;				// Exception flags
	
	// Internal signals
	wire Overflow ;					// Overflow flag
	wire Underflow ;					// Underflow flag
	wire DivideByZero ;				// Divide-by-Zero flag (always 0 in Add/Sub)
	wire Invalid ;						// Invalid inputs or result
	wire Inexact ;						// Result is inexact because of rounding
	
	// Exception flags
	
	// Result is too big to be represented
	assign Overflow = EOF | InputExc[1] | InputExc[0] ;
	
	// Result is too small to be represented
	assign Underflow = NegE & (R | S);
	
	// Infinite result computed exactly from finite operands
	assign DivideByZero = &(Z[`MANTISSA+`EXPONENT-1:`MANTISSA]) & ~|(Z[`MANTISSA+`EXPONENT-1:`MANTISSA]) & ~InputExc[1] & ~InputExc[0];
	
	// Invalid inputs or operation
	assign Invalid = |(InputExc[4:2]) ;
	
	// Inexact answer due to rounding, overflow or underflow
	assign Inexact = (R | S) | Overflow | Underflow;
	
	// Put pieces together to form final result
	assign P = Z ;
	
	// Collect exception flags	
	assign Flags = {Overflow, Underflow, DivideByZero, Invalid, Inexact} ; 	
	
endmodule
module FPMult_16(
		clk,
		rst,
		a,
		b,
		result,
		flags
    );
	
	// Input Ports
	input clk ;							// Clock
	input rst ;							// Reset signal
	input [`DWIDTH-1:0] a;						// Input A, a 32-bit floating point number
	input [`DWIDTH-1:0] b;						// Input B, a 32-bit floating point number
	
	// Output ports
	output [`DWIDTH-1:0] result ;					// Product, result of the operation, 32-bit FP number
	output [4:0] flags ;						// Flags indicating exceptions according to IEEE754
	
	// Internal signals
	wire [`DWIDTH-1:0] Z_int ;					// Product, result of the operation, 32-bit FP number
	wire [4:0] Flags_int ;						// Flags indicating exceptions according to IEEE754
	
	wire Sa ;							// A's sign
	wire Sb ;							// B's sign
	wire Sp ;							// Product sign
	wire [`EXPONENT-1:0] Ea ;					// A's exponent
	wire [`EXPONENT-1:0] Eb ;					// B's exponent
	wire [2*`MANTISSA+1:0] Mp ;					// Product mantissa
	wire [4:0] InputExc ;						// Exceptions in inputs
	wire [`MANTISSA-1:0] NormM ;					// Normalized mantissa
	wire [`EXPONENT:0] NormE ;					// Normalized exponent
	wire [`MANTISSA:0] RoundM ;					// Normalized mantissa
	wire [`EXPONENT:0] RoundE ;					// Normalized exponent
	wire [`MANTISSA:0] RoundMP ;					// Normalized mantissa
	wire [`EXPONENT:0] RoundEP ;					// Normalized exponent
	wire GRS ;

	//reg [63:0] pipe_0;						// Pipeline register Input->Prep
	reg [2*`DWIDTH-1:0] pipe_0;					// Pipeline register Input->Prep

	//reg [92:0] pipe_1;						// Pipeline register Prep->Execute
	//reg [3*`MANTISSA+2*`EXPONENT+7:0] pipe_1;			// Pipeline register Prep->Execute
	reg [3*`MANTISSA+2*`EXPONENT+18:0] pipe_1;

	//reg [38:0] pipe_2;						// Pipeline register Execute->Normalize
	reg [`MANTISSA+`EXPONENT+7:0] pipe_2;				// Pipeline register Execute->Normalize
	
	//reg [72:0] pipe_3;						// Pipeline register Normalize->Round
	reg [2*`MANTISSA+2*`EXPONENT+10:0] pipe_3;			// Pipeline register Normalize->Round

	//reg [36:0] pipe_4;						// Pipeline register Round->Output
	reg [`DWIDTH+4:0] pipe_4;					// Pipeline register Round->Output
	
	assign result = pipe_4[`DWIDTH+4:5] ;
	assign flags = pipe_4[4:0] ;
	
	// Prepare the operands for alignment and check for exceptions
	FPMult_PrepModule PrepModule(clk, rst, pipe_0[2*`DWIDTH-1:`DWIDTH], pipe_0[`DWIDTH-1:0], Sa, Sb, Ea[`EXPONENT-1:0], Eb[`EXPONENT-1:0], Mp[2*`MANTISSA+1:0], InputExc[4:0]) ;

	// Perform (unsigned) mantissa multiplication
	FPMult_ExecuteModule ExecuteModule(pipe_1[3*`MANTISSA+`EXPONENT*2+7:2*`MANTISSA+2*`EXPONENT+8], pipe_1[2*`MANTISSA+2*`EXPONENT+7:2*`MANTISSA+7], pipe_1[2*`MANTISSA+6:5], pipe_1[2*`MANTISSA+2*`EXPONENT+6:2*`MANTISSA+`EXPONENT+7], pipe_1[2*`MANTISSA+`EXPONENT+6:2*`MANTISSA+7], pipe_1[2*`MANTISSA+2*`EXPONENT+8], pipe_1[2*`MANTISSA+2*`EXPONENT+7], Sp, NormE[`EXPONENT:0], NormM[`MANTISSA-1:0], GRS) ;

	// Round result and if necessary, perform a second (post-rounding) normalization step
	FPMult_NormalizeModule NormalizeModule(pipe_2[`MANTISSA-1:0], pipe_2[`MANTISSA+`EXPONENT:`MANTISSA], RoundE[`EXPONENT:0], RoundEP[`EXPONENT:0], RoundM[`MANTISSA:0], RoundMP[`MANTISSA:0]) ;		

	// Round result and if necessary, perform a second (post-rounding) normalization step
	//FPMult_RoundModule RoundModule(pipe_3[47:24], pipe_3[23:0], pipe_3[65:57], pipe_3[56:48], pipe_3[66], pipe_3[67], pipe_3[72:68], Z_int[31:0], Flags_int[4:0]) ;		
	FPMult_RoundModule RoundModule(pipe_3[2*`MANTISSA+1:`MANTISSA+1], pipe_3[`MANTISSA:0], pipe_3[2*`MANTISSA+2*`EXPONENT+3:2*`MANTISSA+`EXPONENT+3], pipe_3[2*`MANTISSA+`EXPONENT+2:2*`MANTISSA+2], pipe_3[2*`MANTISSA+2*`EXPONENT+4], pipe_3[2*`MANTISSA+2*`EXPONENT+5], pipe_3[2*`MANTISSA+2*`EXPONENT+10:2*`MANTISSA+2*`EXPONENT+6], Z_int[`DWIDTH-1:0], Flags_int[4:0]) ;		

//adding always@ (*) instead of posedge clock to make design combinational
	always @ (*) begin	
		if(rst) begin
			pipe_0 = 0;
			pipe_1 = 0;
			pipe_2 = 0; 
			pipe_3 = 0;
			pipe_4 = 0;
		end 
		else begin		
			/* PIPE 0
				[2*`DWIDTH-1:`DWIDTH] A
				[`DWIDTH-1:0] B
			*/
                       pipe_0 = {a, b} ;


			/* PIPE 1
				[2*`EXPONENT+3*`MANTISSA + 18: 2*`EXPONENT+2*`MANTISSA + 18] //pipe_0[`DWIDTH+`MANTISSA-1:`DWIDTH] , mantissa of A
				[2*`EXPONENT+2*`MANTISSA + 17 :2*`EXPONENT+2*`MANTISSA + 9] // pipe_0[8:0]
				[2*`EXPONENT+2*`MANTISSA + 8] Sa
				[2*`EXPONENT+2*`MANTISSA + 7] Sb
				[2*`EXPONENT+2*`MANTISSA + 6:`EXPONENT+2*`MANTISSA+7] Ea
				[`EXPONENT +2*`MANTISSA+6:2*`MANTISSA+7] Eb
				[2*`MANTISSA+1+5:5] Mp
				[4:0] InputExc
			*/
			//pipe_1 <= {pipe_0[`DWIDTH+`MANTISSA-1:`DWIDTH], pipe_0[`MANTISSA_MUL_SPLIT_LSB-1:0], Sa, Sb, Ea[`EXPONENT-1:0], Eb[`EXPONENT-1:0], Mp[2*`MANTISSA-1:0], InputExc[4:0]} ;
			pipe_1 = {pipe_0[`DWIDTH+`MANTISSA-1:`DWIDTH], pipe_0[8:0], Sa, Sb, Ea[`EXPONENT-1:0], Eb[`EXPONENT-1:0], Mp[2*`MANTISSA+1:0], InputExc[4:0]} ;
			
			/* PIPE 2
				[`EXPONENT + `MANTISSA + 7:`EXPONENT + `MANTISSA + 3] InputExc
				[`EXPONENT + `MANTISSA + 2] GRS
				[`EXPONENT + `MANTISSA + 1] Sp
				[`EXPONENT + `MANTISSA:`MANTISSA] NormE
				[`MANTISSA-1:0] NormM
			*/
			pipe_2 = {pipe_1[4:0], GRS, Sp, NormE[`EXPONENT:0], NormM[`MANTISSA-1:0]} ;
			/* PIPE 3
				[2*`EXPONENT+2*`MANTISSA+10:2*`EXPONENT+2*`MANTISSA+6] InputExc
				[2*`EXPONENT+2*`MANTISSA+5] GRS
				[2*`EXPONENT+2*`MANTISSA+4] Sp	
				[2*`EXPONENT+2*`MANTISSA+3:`EXPONENT+2*`MANTISSA+3] RoundE
				[`EXPONENT+2*`MANTISSA+2:2*`MANTISSA+2] RoundEP
				[2*`MANTISSA+1:`MANTISSA+1] RoundM
				[`MANTISSA:0] RoundMP
			*/
			pipe_3 = {pipe_2[`EXPONENT+`MANTISSA+7:`EXPONENT+`MANTISSA+1], RoundE[`EXPONENT:0], RoundEP[`EXPONENT:0], RoundM[`MANTISSA:0], RoundMP[`MANTISSA:0]} ;
			/* PIPE 4
				[`DWIDTH+4:5] Z
				[4:0] Flags
			*/				
			pipe_4 = {Z_int[`DWIDTH-1:0], Flags_int[4:0]} ;
		end
	end
		
endmodule



module FPMult_PrepModule (
		clk,
		rst,
		a,
		b,
		Sa,
		Sb,
		Ea,
		Eb,
		Mp,
		InputExc
	);
	
	// Input ports
	input clk ;
	input rst ;
	input [`DWIDTH-1:0] a ;								// Input A, a 32-bit floating point number
	input [`DWIDTH-1:0] b ;								// Input B, a 32-bit floating point number
	
	// Output ports
	output Sa ;										// A's sign
	output Sb ;										// B's sign
	output [`EXPONENT-1:0] Ea ;								// A's exponent
	output [`EXPONENT-1:0] Eb ;								// B's exponent
	output [2*`MANTISSA+1:0] Mp ;							// Mantissa product
	output [4:0] InputExc ;						// Input numbers are exceptions
	
	// Internal signals							// If signal is high...
	wire ANaN ;										// A is a signalling NaN
	wire BNaN ;										// B is a signalling NaN
	wire AInf ;										// A is infinity
	wire BInf ;										// B is infinity
    wire [`MANTISSA-1:0] Ma;
    wire [`MANTISSA-1:0] Mb;
	
	assign ANaN = &(a[`DWIDTH-2:`MANTISSA]) &  |(a[`DWIDTH-2:`MANTISSA]) ;			// All one exponent and not all zero mantissa - NaN
	assign BNaN = &(b[`DWIDTH-2:`MANTISSA]) &  |(b[`MANTISSA-1:0]);			// All one exponent and not all zero mantissa - NaN
	assign AInf = &(a[`DWIDTH-2:`MANTISSA]) & ~|(a[`DWIDTH-2:`MANTISSA]) ;		// All one exponent and all zero mantissa - Infinity
	assign BInf = &(b[`DWIDTH-2:`MANTISSA]) & ~|(b[`DWIDTH-2:`MANTISSA]) ;		// All one exponent and all zero mantissa - Infinity
	
	// Check for any exceptions and put all flags into exception vector
	assign InputExc = {(ANaN | BNaN | AInf | BInf), ANaN, BNaN, AInf, BInf} ;
	//assign InputExc = {(ANaN | ANaN | BNaN |BNaN), ANaN, ANaN, BNaN,BNaN} ;
	
	// Take input numbers apart
	assign Sa = a[`DWIDTH-1] ;							// A's sign
	assign Sb = b[`DWIDTH-1] ;							// B's sign
	assign Ea = a[`DWIDTH-2:`MANTISSA];						// Store A's exponent in Ea, unless A is an exception
	assign Eb = b[`DWIDTH-2:`MANTISSA];						// Store B's exponent in Eb, unless B is an exception	
//    assign Ma = a[`MANTISSA_MSB:`MANTISSA_LSB];
  //  assign Mb = b[`MANTISSA_MSB:`MANTISSA_LSB];
	


	//assign Mp = ({4'b0001, a[`MANTISSA-1:0]}*{4'b0001, b[`MANTISSA-1:9]}) ;
	assign Mp = ({1'b1,a[`MANTISSA-1:0]}*{1'b1, b[`MANTISSA-1:0]}) ;

	
    //We multiply part of the mantissa here
    //Full mantissa of A
    //Bits MANTISSA_MUL_SPLIT_MSB:MANTISSA_MUL_SPLIT_LSB of B
   // wire [`ACTUAL_MANTISSA-1:0] inp_A;
   // wire [`ACTUAL_MANTISSA-1:0] inp_B;
   // assign inp_A = {1'b1, Ma};
   // assign inp_B = {{(`MANTISSA-(`MANTISSA_MUL_SPLIT_MSB-`MANTISSA_MUL_SPLIT_LSB+1)){1'b0}}, 1'b1, Mb[`MANTISSA_MUL_SPLIT_MSB:`MANTISSA_MUL_SPLIT_LSB]};
   // DW02_mult #(`ACTUAL_MANTISSA,`ACTUAL_MANTISSA) u_mult(.A(inp_A), .B(inp_B), .TC(1'b0), .PRODUCT(Mp));
endmodule


module FPMult_ExecuteModule(
		a,
		b,
		MpC,
		Ea,
		Eb,
		Sa,
		Sb,
		Sp,
		NormE,
		NormM,
		GRS
    );

	// Input ports
	input [`MANTISSA-1:0] a ;
	input [2*`EXPONENT:0] b ;
	input [2*`MANTISSA+1:0] MpC ;
	input [`EXPONENT-1:0] Ea ;						// A's exponent
	input [`EXPONENT-1:0] Eb ;						// B's exponent
	input Sa ;								// A's sign
	input Sb ;								// B's sign
	
	// Output ports
	output Sp ;								// Product sign
	output [`EXPONENT:0] NormE ;													// Normalized exponent
	output [`MANTISSA-1:0] NormM ;												// Normalized mantissa
	output GRS ;
	
	wire [2*`MANTISSA+1:0] Mp ;
	
	assign Sp = (Sa ^ Sb) ;												// Equal signs give a positive product
	
   // wire [`ACTUAL_MANTISSA-1:0] inp_a;
   // wire [`ACTUAL_MANTISSA-1:0] inp_b;
   // assign inp_a = {1'b1, a};
   // assign inp_b = {{(`MANTISSA-`MANTISSA_MUL_SPLIT_LSB){1'b0}}, 1'b0, b};
   // DW02_mult #(`ACTUAL_MANTISSA,`ACTUAL_MANTISSA) u_mult(.A(inp_a), .B(inp_b), .TC(1'b0), .PRODUCT(Mp_temp));
   // DW01_add #(2*`ACTUAL_MANTISSA) u_add(.A(Mp_temp), .B(MpC<<`MANTISSA_MUL_SPLIT_LSB), .CI(1'b0), .SUM(Mp), .CO());

	//assign Mp = (MpC<<(2*`EXPONENT+1)) + ({4'b0001, a[`MANTISSA-1:0]}*{1'b0, b[2*`EXPONENT:0]}) ;
	assign Mp = MpC;


	assign NormM = (Mp[2*`MANTISSA+1] ? Mp[2*`MANTISSA:`MANTISSA+1] : Mp[2*`MANTISSA-1:`MANTISSA]); 	// Check for overflow
	assign NormE = (Ea + Eb + Mp[2*`MANTISSA+1]);								// If so, increment exponent
	
	assign GRS = ((Mp[`MANTISSA]&(Mp[`MANTISSA+1]))|(|Mp[`MANTISSA-1:0])) ;
	
endmodule

module FPMult_NormalizeModule(
		NormM,
		NormE,
		RoundE,
		RoundEP,
		RoundM,
		RoundMP
    );

	// Input Ports
	input [`MANTISSA-1:0] NormM ;									// Normalized mantissa
	input [`EXPONENT:0] NormE ;									// Normalized exponent

	// Output Ports
	output [`EXPONENT:0] RoundE ;
	output [`EXPONENT:0] RoundEP ;
	output [`MANTISSA:0] RoundM ;
	output [`MANTISSA:0] RoundMP ; 
	
// EXPONENT = 5 
// EXPONENT -1 = 4
// NEED to subtract 2^4 -1 = 15

wire [`EXPONENT-1 : 0] bias;

assign bias =  ((1<< (`EXPONENT -1)) -1);

	assign RoundE = NormE - bias ;
	assign RoundEP = NormE - bias -1 ;
	assign RoundM = NormM ;
	assign RoundMP = NormM ;

endmodule

module FPMult_RoundModule(
		RoundM,
		RoundMP,
		RoundE,
		RoundEP,
		Sp,
		GRS,
		InputExc,
		Z,
		Flags
    );

	// Input Ports
	input [`MANTISSA:0] RoundM ;									// Normalized mantissa
	input [`MANTISSA:0] RoundMP ;									// Normalized exponent
	input [`EXPONENT:0] RoundE ;									// Normalized mantissa + 1
	input [`EXPONENT:0] RoundEP ;									// Normalized exponent + 1
	input Sp ;												// Product sign
	input GRS ;
	input [4:0] InputExc ;
	
	// Output Ports
	output [`DWIDTH-1:0] Z ;										// Final product
	output [4:0] Flags ;
	
	// Internal Signals
	wire [`EXPONENT:0] FinalE ;									// Rounded exponent
	wire [`MANTISSA:0] FinalM;
	wire [`MANTISSA:0] PreShiftM;
	
	assign PreShiftM = GRS ? RoundMP : RoundM ;	// Round up if R and (G or S)
	
	// Post rounding normalization (potential one bit shift> use shifted mantissa if there is overflow)
	assign FinalM = (PreShiftM[`MANTISSA] ? {1'b0, PreShiftM[`MANTISSA:1]} : PreShiftM[`MANTISSA:0]) ;
	
	assign FinalE = (PreShiftM[`MANTISSA] ? RoundEP : RoundE) ; // Increment exponent if a shift was done
	
	assign Z = {Sp, FinalE[`EXPONENT-1:0], FinalM[`MANTISSA-1:0]} ;   // Putting the pieces together
	assign Flags = InputExc[4:0];

endmodule


module array_mux_2to1 #(parameter size = 10) (clk,reset,start,out,in0,in1,sel,out_data_available);

    input [size-1:0] in0, in1;
    input sel,clk;
	input reset,start;
    output reg [size-1:0] out;
	output reg out_data_available;

	always@(posedge clk) begin
		if((reset==1'b1) || (start==1'b0)) begin
			out <= 'bX;
			out_data_available <= 0;
		end
		else begin
			out <= (sel) ? in1 : in0;
			out_data_available <= 1;
		end
	end
    
endmodule

module barrel_shifter_right (
	input clk,
	input reset,
	input start,
    input [4:0] shift_amt,
    input [5:0] significand,
    output [5:0] shifted_sig,
	output out_data_available
);

    //3-level distributed barrel shifter using 10 2:1 MUX array

    //level 0
    wire [6:0] out0;
	wire out_data_available_arr_0;

    array_mux_2to1 #(.size(7)) M0 (
		.clk(clk),
		.reset(reset),
		.start(start),
		.out(out0),
		.in0({significand[5:0],1'b0}),
		.in1({1'b0,significand[5:0]}),
		.sel(shift_amt[0]),
		.out_data_available(out_data_available_arr_0)
	);

    //level 1
    wire [8:0] out1;
	wire out_data_available_arr_1;

    array_mux_2to1 #(.size(9)) M1 (
		.clk(clk),
		.reset(reset),
		.start(out_data_available_arr_0),
		.out(out1),
		.in0({out0[6:0],2'b0}),
		.in1({2'b0,out0[6:0]}),
		.sel(shift_amt[1]),
		.out_data_available(out_data_available_arr_1)
	);

	//level 2
    wire [12:0] out2;

    array_mux_2to1 #(.size(13)) M2 (
		.clk(clk),
		.reset(reset),
		.start(out_data_available_arr_1),
		.out(out2),
		.in0({out1[8:0],4'b0}),
		.in1({4'b0,out1[8:0]}),
		.sel(shift_amt[2]),
		.out_data_available(out_data_available)
	);

    //shifted significand
    assign shifted_sig = (reset==1'b1) ? 'bX : out2[12:7];

endmodule

module barrel_shifter_left (
	input clk,
	input reset,
	input start,
    input [4:0] shift_amt,
    input [5:0] significand,
    output [5:0] shifted_sig,
	output out_data_available
);

    //3-level distributed barrel shifter using 10 2:1 MUX array

    //level 0
    wire [6:0] out0;
	wire out_data_available_arr_0;

    array_mux_2to1 #(.size(7)) M0 (
		.clk(clk),
		.reset(reset),
		.start(start),
		.out(out0),
		.in0({1'b0,significand[5:0]}),
		.in1({significand[5:0],1'b0}),
		.sel(shift_amt[0]),
		.out_data_available(out_data_available_arr_0)
	);

    //level 1
    wire [8:0] out1;
	wire out_data_available_arr_1;

    array_mux_2to1 #(.size(9)) M1 (
		.clk(clk),
		.reset(reset),
		.start(out_data_available_arr_0),
		.out(out1),
		.in0({2'b0,out0[6:0]}),
		.in1({out0[6:0],2'b0}),
		.sel(shift_amt[1]),
		.out_data_available(out_data_available_arr_1)
	);

	//level 2
    wire [12:0] out2;

    array_mux_2to1 #(.size(13)) M2 (
		.clk(clk),
		.reset(reset),
		.start(out_data_available_arr_1),
		.out(out2),
		.in0({4'b0,out1[8:0]}),
		.in1({out1[8:0],4'b0}),
		.sel(shift_amt[2]),
		.out_data_available(out_data_available)
	);

    //shifted significand
    assign shifted_sig = (reset==1'b1) ? 'bX : out2[5:0];

endmodule

module leading_zero_detector_6bit(
	input clk,
    input[5:0] a,
	input reset,
	input start,
    output reg [2:0] position,
    output reg is_valid,
	output reg out_data_available
);

    wire[1:0] posi_upper, posi_lower;
    wire valid_upper, valid_lower;

	reg[3:0] num_cycles;

	always@(posedge clk) begin
		if((reset==1'b1) || (start==1'b0)) begin
			num_cycles <= 0;
			out_data_available <= 0;
		end
		else begin
			if(num_cycles==`NUM_LZD_CYCLES) begin
				out_data_available <= 1;
			end
			else begin
				num_cycles <= num_cycles + 1;
			end
		end
	end

    leading_zero_detector_4bit lzd4_upper(
		.clk(clk),
		.reset(reset),
		.start(start),
        .a(a[5:2]),
        .position(posi_upper),
        .is_valid(valid_upper)
    );

    leading_zero_detector_4bit lzd4_lower(
		.clk(clk),
		.reset(reset),
		.start(start),
        .a({a[1:0],2'b00}),
        .position(posi_lower),
        .is_valid(valid_lower)
    );

    always@(posedge clk) begin
		if((reset==1'b1) || (start==1'b0)) begin
			is_valid <= 0;
			position <= 'bX;
		end
		else begin
			is_valid <= valid_upper | valid_lower;

			position[2] <= ~valid_upper;
    		position[1] <= valid_upper ? posi_upper[1] : posi_lower[1];
    		position[0] <= valid_upper ? posi_upper[0] : posi_lower[0];
		end
	end

endmodule

module leading_zero_detector_4bit(
	input clk,
    input[3:0] a,
	input reset,
	input start,
    output reg [1:0] position,
    output reg is_valid
);

    wire posi_upper, posi_lower;
    wire valid_upper, valid_lower;

    leading_zero_detector_2bit lzd2_upper(
		.clk(clk),
		.reset(reset),
		.start(start),
        .a(a[3:2]),
        .position(posi_upper),
        .is_valid(valid_upper)
    );

    leading_zero_detector_2bit lzd2_lower(
		.clk(clk),
		.reset(reset),
		.start(start),
        .a(a[1:0]),
        .position(posi_lower),
        .is_valid(valid_lower)
    );

    always@(posedge clk) begin
		if((reset==1) || (start==0)) begin
			is_valid <= 0;
		end
		else begin
			is_valid <= valid_upper | valid_lower;

			position[1] <= ~valid_upper;
    		position[0] <= valid_upper ? posi_upper : posi_lower;
		end
	end

endmodule

module leading_zero_detector_2bit(
	input clk,
    input[1:0] a,
	input reset,
	input start,
    output reg position,
    output reg is_valid
);

	always@(posedge clk) begin
		if((reset==1) || (start==0)) begin
			is_valid <= 0;
		end
		else begin
			is_valid <= a[1] | a[0];
			position <= ~a[1];
		end
	end
endmodule
