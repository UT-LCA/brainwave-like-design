<%!
  from includes import num_tiles, num_ldpes, num_dsp_per_ldpe, num_reduction_stages
%>

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
    wire[`NUM_LDPES*`OUT_DWIDTH-1:0] result_ldpe; 
    //reg[`ORF_AWIDTH-1:0] result_addr_mvu_orf;
    
    //wire orf_addr_increment;
  
    //
% for i in range(num_tiles):
    wire[`VRF_DWIDTH-1:0] vrf_mvu_out_${i};
    wire vrf_mvu_wr_enable_${i};
    wire vrf_mvu_readn_enable_${i};
% endfor
    
    wire done_mvm; //CHANGES THE REST STATE OF INSTR DECODER
    wire out_data_available_mvm;
    wire out_data_available_ldpe;

    wire[`NUM_TILES*`NUM_LDPES-1:0] mrf_we_for_dram;
    wire [`NUM_TILES*`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_for_dram;
    wire [`NUM_TILES*`MRF_DWIDTH*`NUM_LDPES-1:0] mrf_outa_to_dram;

   wire mdpe_group_done;
   wire mdpe_group_out_vld;
   wire [`mdpe_group_out_used_dwidth-1:0] mdpe_group_out_data;
  

    MVU mvm_unit (
    .clk(clk),
    .start(start_tile_with_single_cyc_latency),
    .reset(reset_tile_with_single_cyc_latency),
    
    ////////////////////////
    //LDPE signals
    ////////////////////////
    .vrf_wr_addr(vrf_addr_wr),
    .vrf_read_addr(vrf_addr_read),
    .vec(vrf_in_data[`VRF_DWIDTH-1:0]),
% for i in range(num_tiles):
    .vrf_data_out_tile_${i}(vrf_mvu_out_${i}), //WITH TAG
    .vrf_wr_enable_tile_${i}(vrf_mvu_wr_enable_${i}), //WITH TAG
    .vrf_readn_enable_tile_${i}(vrf_mvu_readn_enable_${i}), //WITH TAG
% endfor
    
    .mrf_in(mrf_in_data),
    .mrf_we(mrf_we),  //WITH TAG 
    .mrf_addr(mrf_addr_wr),

    .mrf_we_for_dram(mrf_we_for_dram),
    .mrf_addr_for_dram(mrf_addr_for_dram),
    .mrf_outa_to_dram(mrf_outa_to_dram),

    .out_data_available(out_data_available_ldpe),
    .mvm_result(result_ldpe), //WITH TAG

    ////////////////////////
    //MDPE signals
    ////////////////////////
    .mdpe_vec_wr_addr(vrf_addr_wr),
    .mdpe_vec_wr_data(vrf_in_data[`VRF_DWIDTH-1:0]),
    .mdpe_vec_we(vrf_mvu_wr_enable_0), //Connecting to tile0
    .mdpe_group_done(mdpe_group_done),
    .mdpe_group_out_vld(mdpe_group_out_vld),
    .mdpe_group_out_data(mdpe_group_out_data)


    );
   
    assign out_data_available_mvm = out_data_available_ldpe | mdpe_group_out_vld;
    assign done_mvm = out_data_available_mvm;

    wire [(`NUM_LDPES*`OUT_DWIDTH) + `mdpe_group_out_used_dwidth - 1 : 0] result_mvm;
    assign result_mvm = {result_ldpe, mdpe_group_out_data};
    
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
    wire[`ORF_DWIDTH-1:0] output_mvu_stage;
    //************************************************************

    //Instantiate asymmetric FIFO here
    //Converts NUM_LDPES*OUT_DWIDTH into ORF_DWIDTH
    //assign output_mvu_stage = result_mvm;

    asymmetric_fifo u_afifo (
    .clk(clk),
    .reset(reset_npu),
    .in(result_mvm),
    .out(output_mvu_stage),
    .write_en(out_data_available_mvm),
    .read_en(in_data_available_mfu_0)
    );
    
    //************** INTER MFU MVU DATAPATH SIGNALS *************************************************
    reg[`ORF_DWIDTH-1:0] output_mvu_stage_buffer;
    reg[`ORF_DWIDTH-1:0] output_mfu_stage_0_buffer;
    
    wire[`ORF_DWIDTH-1:0] primary_in_data_mfu_stage_0;
    wire[`ORF_DWIDTH-1:0] primary_in_data_mfu_stage_1;
    
    
    wire[`ORF_DWIDTH-1:0] output_mfu_stage_0;
    wire[`ORF_DWIDTH-1:0] output_mfu_stage_1;
    
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

% for i in range(num_tiles):
    .vrf_out_data_mvu_${i}(vrf_mvu_out_${i}),               //MVU TILE VRF
    .vrf_readn_enable_mvu_${i}(vrf_mvu_readn_enable_${i}),
    .vrf_wr_enable_mvu_${i}(vrf_mvu_wr_enable_${i}),
% endfor
    
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