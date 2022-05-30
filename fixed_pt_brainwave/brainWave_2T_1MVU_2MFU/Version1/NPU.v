`include "instr_decoder_gen.v"
`include "MVU_tile.v"
`include "MFU_gen.v"
`define NUM_MVM_CYCLES 5


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
    wire[`NUM_LDPES*`OUT_PRECISION-1:0] output_final_stage;
    
   
    wire start_mv_mul_signal;
    wire start_mfu_0_signal;
    wire start_mfu_1_signal;
    

    //SAME SIGNAL FOR BOTH THE TILES AS PARALLEL EXECUTION OF TILES IS REQUIRED
    reg start_tile_with_single_cyc_latency;
    reg reset_tile_with_single_cyc_latency;
    //
    
    
    
    wire [`VRF_DWIDTH-1:0] vrf_in_data;
    wire [`MRF_DWIDTH-1:0] mrf_in_data;
    
    
    //MRF SIGNALS
    wire[`NUM_LDPES*`NUM_TILES-1:0] mrf_we;
    wire [`MRF_AWIDTH*`NUM_LDPES*`NUM_TILES-1:0] mrf_addr_wr;
    //
    
    //FINAL STAGE OUTPUT SIGNALS
    wire[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm; 
    //reg[`ORF_AWIDTH-1:0] result_addr_mvu_orf;
    
    //wire orf_addr_increment;
  
    //
    
    reg done_mvm; //CHANGES THE REST STATE OF INSTR DECODER
    

    wire [`NUM_LDPES-1:0] mrf_we_0;
    assign mrf_we_0 = mrf_we[`NUM_LDPES-1:0];
    
    wire [`NUM_LDPES-1:0] mrf_we_1;
    assign mrf_we_1 = mrf_we[2*`NUM_LDPES-1:`NUM_LDPES];
    
    wire[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm_0;
    
    
    wire[`VRF_DWIDTH-1:0] vrf_mvu_out_0;
    wire vrf_mvu_wr_enable_0;
    wire vrf_mvu_readn_enable_0;
    wire[`VRF_AWIDTH-1:0] vrf_mvu_read_addr_0;
    wire [`VRF_AWIDTH-1:0] vrf_tile_wr_addr_0_f;
    wire [`VRF_AWIDTH-1:0] vrf_mvu_wr_addr_0;
    
    MVU_tile tile_0(.clk(clk),
    .start(start_tile_with_single_cyc_latency),
    .reset(reset_tile_with_single_cyc_latency),
    .done(done_mvm), //WITH TAG
    .vrf_wr_addr(vrf_mvu_wr_addr_0),
    .vec(vrf_in_data),
    .vrf_data_out(vrf_mvu_out_0), //WITH TAG
    .vrf_wr_enable(vrf_mvu_wr_enable_0), //WITH TAG
    .vrf_readn_enable(vrf_mvu_readn_enable_0), //WITH TAG
    .vrf_read_addr(vrf_mvu_read_addr_0),
    .mrf_in(mrf_in_data),
    .mrf_we(mrf_we_0),  //WITH TAG 
    .mrf_addr(mrf_addr_wr[1*`NUM_LDPES*`MRF_AWIDTH-1:0*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_0) //WITH TAG
    //.result_addr(result_addr_mvu_orf)
    );


    wire[`VRF_DWIDTH-1:0] vrf_mvu_out_1;
    wire vrf_mvu_readn_enable_1;
    wire vrf_mvu_wr_enable_1;
    wire[`VRF_AWIDTH-1:0] vrf_mvu_read_addr_1;
    wire [`VRF_AWIDTH-1:0] vrf_mvu_wr_addr_1;

    wire[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm_1;
    
    MVU_tile tile_1(.clk(clk),
    .start(start_tile_with_single_cyc_latency),
    .reset(reset_tile_with_single_cyc_latency),
    .done(done_mvm), //WITH TAG
    .vrf_wr_addr(vrf_mvu_wr_addr_1),
    .vec(vrf_in_data),
    .vrf_data_out(vrf_mvu_out_1),   //WITH TAG
    .vrf_wr_enable(vrf_mvu_wr_enable_1), //WITH TAG
    .vrf_readn_enable(vrf_mvu_readn_enable_1), //WITH TAG
    .vrf_read_addr(vrf_mvu_read_addr_1),
    .mrf_in(mrf_in_data),
    .mrf_we(mrf_we_1), //WITH TAG
    .mrf_addr(mrf_addr_wr[2*`NUM_LDPES*`MRF_AWIDTH-1:1*`NUM_LDPES*`MRF_AWIDTH]),
    .result(result_mvm_1) //WITH TAG
   // .result_addr(result_addr_mvu_orf)
    );
    
    
    reg[3:0] num_cycles_mvm;
    
    //*******SCHEDULING NEXT MFU INSTRUCTIION BY CHECKING IF MVU IS COMPELETE *******
    
    always@(posedge clk) begin
        $display("%b", mrf_addr_wr);
        if((reset_npu==1'b1) || (start_mv_mul_signal==1'b0)) begin
            done_mvm <= 1'b0;
            num_cycles_mvm<=0;
        end
        else begin
            if(num_cycles_mvm!=`NUM_MVM_CYCLES-1) begin
                num_cycles_mvm <= num_cycles_mvm+1'b1;
            end
            else begin
                done_mvm<=1'b1;
            end
        end
    end
    /*
    
      always@(posedge clk) begin
        if(reset_npu) begin
            result_addr_mvu_orf <= 0;
        end
        else if((orf_addr_increment==1'b1) && (done_mvm!=1'b1)) begin
            result_addr_mvu_orf<=result_addr_mvu_orf+1'b1;
        end
    end
    */
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
    wire[`VRF_DWIDTH-1:0] vrf_mfu_out_data_add_0;
    wire vrf_mfu_readn_enable_add_0;
    wire vrf_mfu_wr_enable_add_0;
    wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_read_add_0;
    wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_wr_add_0;

    wire[`VRF_DWIDTH-1:0] vrf_mfu_out_data_mul_0;
    wire vrf_mfu_readn_enable_mul_0;
    wire vrf_mfu_wr_enable_mul_0;
    wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_read_mul_0;
    wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_wr_mul_0;
    
    //wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_read_add_1;
    
    //MFU - STAGE 1 VRF SIGNALS 

    wire[`VRF_DWIDTH-1:0] vrf_mfu_out_data_add_1;
    wire vrf_mfu_readn_enable_add_1;
    wire vrf_mfu_wr_enable_add_1;
    wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_read_add_1;
    wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_wr_add_1;

    wire[`VRF_DWIDTH-1:0] vrf_mfu_out_data_mul_1;
    wire vrf_mfu_readn_enable_mul_1;
    wire vrf_mfu_wr_enable_mul_1;
    wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_read_mul_1;
    wire[`VRF_AWIDTH-1:0] vrf_mfu_addr_wr_mul_1;
    
    //************************************************************

    //****************************REDUCTION UNIT FOR MVM *******************************************

   wire[`NUM_LDPES*`OUT_PRECISION-1:0] output_mvu_stage;
    mvm_reduction_unit mvm_reduction(
      .clk(clk),
      .reset_reduction_mvm(reset_tile_with_single_cyc_latency),
      .inp0(result_mvm_0),
      .inp1(result_mvm_1),
      .result_mvm_final_stage(result_mvm)
    );
    
    wire[`TARGET_OP_WIDTH-1:0] dstn_id;
    assign output_mvu_stage = result_mvm;
    
    //************** INTER MFU MVU DATAPATH SIGNALS *************************************************
    reg[`ORF_DWIDTH*`NUM_LDPES-1:0] output_mvu_stage_buffer;
    reg[`ORF_DWIDTH*`NUM_LDPES-1:0] output_mfu_stage_0_buffer;
    
    wire[`ORF_DWIDTH*`NUM_LDPES-1:0] primary_in_data_mfu_stage_0;
    wire[`ORF_DWIDTH*`NUM_LDPES-1:0] primary_in_data_mfu_stage_1;
    
    
    wire[`NUM_LDPES*`OUT_PRECISION-1:0] output_mfu_stage_0;
    wire[`NUM_LDPES*`OUT_PRECISION-1:0] output_mfu_stage_1;
    
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
    wire[`VRF_DWIDTH-1:0] vrf_muxed_in_data_fake;
    //************* MUXED MVU-MFU VRF **********************************************************
    
    wire[`VRF_AWIDTH-1:0] vrf_muxed_wr_addr_dram;
    wire[`VRF_DWIDTH-1:0] vrf_muxed_in_data_dram;
    wire[`VRF_DWIDTH-1:0] vrf_muxed_out_data_dram;
    wire vrf_muxed_wr_enable_dram;
    wire vrf_muxed_readn_enable;
    
    wire[`VRF_AWIDTH-1:0] vrf_muxed_read_addr;
    wire[`VRF_DWIDTH-1:0] vrf_muxed_out_data;
    
    
    VRF vrf_muxed (
        .clk(clk),
        
        .addra(vrf_muxed_wr_addr_dram),
        .ina(vrf_in_data),
        .wea(vrf_muxed_wr_enable_dram),
        .outa(vrf_muxed_data_out_dram),
        
        .addrb(vrf_muxed_read_addr),
        .inb(vrf_muxed_in_data_fake),
        .web(vrf_muxed_readn_enable),
        .outb(vrf_muxed_out_data) 
    );
    
    wire mvu_or_vrf_mux_select;
    assign primary_in_data_mfu_stage_0 = (mvu_or_vrf_mux_select) ? vrf_muxed_out_data : output_mvu_stage_buffer;
    
    assign primary_in_data_mfu_stage_1 = output_mfu_stage_0_buffer;
    
    //*********************************************************************************************
    
    //*********************************INSTRUCTION DECODER *****************************************
     instruction_decoder instr_dec(
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

    //.start_mvu(start_tile),
    .start_mfu_0(start_mfu_0_signal),
    .start_mfu_1(start_mfu_1_signal),
    .start_mv_mul(start_mv_mul_signal),
    //.reset_mvu(reset_tile), //FIX NOMENCLATURE FOR MVU AND MFU FOR RESET SIGNALS - FIXED
    .in_data_available_mfu_0(in_data_available_mfu_0),
    .in_data_available_mfu_1(in_data_available_mfu_1),

    .activation(activation),
    .operation(operation),

    .vrf_out_data_mvu_0(vrf_mvu_out_0),               //MVU TILE VRF
    .vrf_readn_enable_mvu_0(vrf_mvu_readn_enable_0),
    .vrf_wr_enable_mvu_0(vrf_mvu_wr_enable_0),
    .vrf_addr_read_mvu_0(vrf_mvu_read_addr_0),
    .vrf_addr_wr_mvu_0(vrf_mvu_wr_addr_0),

    .vrf_out_data_mvu_1(vrf_mvu_out_1),               //MVU TILE VRF
    .vrf_readn_enable_mvu_1(vrf_mvu_readn_enable_1),
    .vrf_wr_enable_mvu_1(vrf_mvu_wr_enable_1),
    .vrf_addr_read_mvu_1(vrf_mvu_read_addr_1),
    .vrf_addr_wr_mvu_1(vrf_mvu_wr_addr_0),
    
    //.reset_reduction_unit_mvm(reset_reduction_mvm),
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
    
    //.orf_addr_increment(orf_addr_increment),
    
    .dstn_id(dstn_id)
    );
    //***************************************************************************
    
    //DELAYS START SIGNALS OF MVU TILE BY ONE CYCLE TO AVOID ARITHEMETIC OF DONT CARES ***********
    always@(posedge clk) begin
        if(start_mv_mul_signal==1'b1) begin
            start_tile_with_single_cyc_latency<=1'b1;
            reset_tile_with_single_cyc_latency<=1'b0;
        end
        else begin
            start_tile_with_single_cyc_latency<=1'b0;
            reset_tile_with_single_cyc_latency<=1'b1;
        end
    end
    
    always@(posedge clk) begin
        if(start_mfu_0_signal==1'b1) begin
            reset_mfu_0_with_single_cyc_latency<=1'b0;
        end
        else begin
            reset_mfu_0_with_single_cyc_latency<=1'b1;
        end
    end
    
    always@(posedge clk) begin
        if(start_mfu_1_signal==1'b1) begin
            reset_mfu_1_with_single_cyc_latency<=1'b0;
        end
        else begin
            reset_mfu_1_with_single_cyc_latency<=1'b1;
        end
    end
    
    //*********************************************************************************************
    
   MFU mfu_stage_0( 
    .activation_type(activation_type),
    .operation(operation),
    .in_data_available(in_data_available_mfu_0),
    
    .vrf_addr_read_add(vrf_mfu_addr_read_add_0),
    .vrf_addr_wr_add(vrf_mfu_addr_wr_add_0),
    .vrf_readn_enable_add(vrf_mfu_readn_enable_add_0),
    .vrf_wr_enable_add(vrf_mfu_wr_enable_add_0),

    .vrf_addr_read_mul(vrf_mfu_addr_read_mul_0),
    .vrf_addr_wr_mul(vrf_mfu_addr_wr_mul_0),
    .vrf_readn_enable_mul(vrf_mfu_readn_enable_mul_0),
    .vrf_wr_enable_mul(vrf_mfu_wr_enable_mul_0),
    
    .primary_inp(primary_in_data_mfu_stage_0),
    .secondary_inp(vrf_in_data),
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
    MFU mfu_stage_1( 
    .activation_type(activation_type),
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
    .secondary_inp(vrf_in_data),
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

module mvm_reduction_unit(
    input[`ORF_DWIDTH*`NUM_LDPES-1:0] inp0,
    input[`ORF_DWIDTH*`NUM_LDPES-1:0] inp1,
    output reg[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm_final_stage,
    
    //CONTROL SIGNALS
    input clk,
    //input done,
    //input continue_past_reduction,
   input reset_reduction_mvm
);
    wire[`ORF_DWIDTH*`NUM_LDPES-1:0] reduction_output_wire;
    reg[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm;
    
    always @(*) begin
        if (reset_reduction_mvm) begin
          result_mvm_final_stage <= 0;
        end
        else begin
        
           result_mvm_final_stage <= reduction_output_wire;
        end
     end
     /*
     always @(posedge clk) begin
        if (add_with_prev_mvm_result) begin
          result_mvm <= 0;
        end
        else begin
        
           result_mvm <= reduction_output_wire;
        end
     end
     */
    genvar i;
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder adder_units(
              .a(inp0[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH]),
              .b(inp1[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH]),
              .clk(clk),
              .reset(reset_reduction_unit),
              .sum(reduction_output_wire[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH])
            );
        end
        
    endgenerate
    /*
    generate
        for(i=1; i<=`NUM_LDPES; i=i+1) begin
           myadder adder_units(
              .a(inp0[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH]),
              .b(inp1[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH]),
              .sum(reduction_output_wire[i*`ORF_DWIDTH-1:(i-1)*`ORF_DWIDTH])
            );
        end
        
    endgenerate
*/
endmodule