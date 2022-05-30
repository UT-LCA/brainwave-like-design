`include "instr_decoder_gen.v"
`include "MVU_tile.v"
`include "MFU_gen.v"

module NPU(
    input reset_npu,
    input[`INSTR_WIDTH-1:0] instruction,
    input[`DRAM_DWIDTH-1:0] input_data_DRAM,
    output [`DRAM_DWIDTH-1:0] output_data_DRAM,
    output [`DRAM_AWIDTH-1:0] dram_addr,
    output dram_write_enable,
    output[`NUM_LDPES*`OUT_PRECISION-1:0] output_final_stage, //WRITE IT BACK TO DRAM 
    //WRITE DOCUMENTATION EXPLAINING HOW MANY PORTS EACH VRF,MRF, ORF HAS and WHERE IS IT CONNECTED TO
    input clk,
    input done_mvm
);

    wire start_tile;
    wire reset_tile;
    wire [`VRF_AWIDTH-1:0] vrf_tile_rw_addr;
    wire [`VRF_DWIDTH-1:0] vrf_in_data;
    wire[`VRF_DWIDTH-1:0] vrf_out;
    wire [`MRF_DWIDTH-1:0] mrf_in_data;
    wire vrf_rw_enable;
    wire vrf_readn_enable;
    wire[`NUM_LDPES-1:0] mrf_we;
    wire [`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_rw;
    wire[`ORF_DWIDTH*`NUM_LDPES-1:0] result_mvm;
    
    
    MVU_tile tile0(.clk(clk),
    .start(start_tile),
    .reset(reset_tile),
    .done(done_mvm),
    .vrf_wr_addr(vrf_tile_rw_addr),
    .vec(vrf_in_data),
    .vrf_data_out(vrf_out),
    .vrf_wr_enable(vrf_rw_enable),
    .vrf_readn_enable(vrf_readn_enable),
    .mrf_in(mrf_in_data),
    .mrf_we(mrf_we),
    .mrf_addr(mrf_addr_rw),
    .result(result_mvm),
    .result_addr(result_addr_mvu_orf)
    );
    reg [`ORF_AWIDTH-1:0] result_addr;
    
    wire orf_addr_increment;
    always@(posedge clk) begin
        if(orf_addr_increment==1'b0) begin
            result_addr<=0;
        end
        else begin
            result_addr<=result_addr+1'b1;
        end
    end
    wire in_data_available;
    wire reset_mfu;
    wire[1:0] activation;
    wire[1:0] operation;

    wire[`VRF_AWIDTH-1:0] vrf_addr_read0;

    wire[`VRF_DWIDTH-1:0] vrf_out_data1;
    wire vrf_read_enable1;
    wire vrf_rw_enable1;
    wire[`VRF_AWIDTH-1:0] vrf_addr_read1;
    wire[`VRF_AWIDTH-1:0] vrf_addr_rw1;

    wire[`VRF_DWIDTH-1:0] vrf_out_data2;
    wire vrf_read_enable2;
    wire vrf_rw_enable2;
    wire[`VRF_AWIDTH-1:0] vrf_addr_read2;
    wire[`VRF_AWIDTH-1:0] vrf_addr_rw2;

    wire[`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_rw;


     instruction_decoder instr_dec(
     .clk(clk),
     .reset_npu(reset_npu),
    .instruction(instruction),
    .input_data(input_data_DRAM),
    .dram_addr_wr(dram_addr),
    .dram_wr_enable(dram_write_enable),
    .output_data(output_data_DRAM),

    .start_mvu(start_tile),
    .reset_mfu(reset_mfu),
    .reset_mvu(reset_tile), //FIX NOMENCLATURE FOR MVU AND MFU FOR RESET SIGNALS
    .in_data_available(in_data_available),

    .activation(activation),
    .operation(operation),

    .vrf_out_data0(vrf_out),               //MVU TILE VRF
    .vrf_readn_enable0(vrf_readn_enable),
    .vrf_rw_enable0(vrf_rw_enable),
    .vrf_addr_read0(vrf_addr_read0),
    .vrf_addr_rw0(vrf_tile_rw_addr),

    //CHANGE INDEXING FOR VRFs--------------------------------------------
    
    .vrf_out_data1(vrf_out_data1),
    .vrf_readn_enable1(vrf_read_enable1),
    .vrf_rw_enable1(vrf_rw_enable1), //MFU VRF - ADD
    .vrf_addr_read1(vrf_addr_read1),
    .vrf_addr_rw1(vrf_addr_rw1),


    .vrf_out_data2(vrf_out_data2),      //MFU VRF - MUL
    .vrf_readn_enable2(vrf_read_enable2),
    .vrf_rw_enable2(vrf_rw_enable2),
    .vrf_addr_read2(vrf_addr_read2),
    .vrf_addr_rw2(vrf_addr_rw2),

    .vrf_in_data(vrf_in_data), //common

    .mrf_addr_rw(mrf_addr_rw),
    .mrf_rw_enable(mrf_we),
    .mrf_in_data(mrf_in_data),
    
    .orf_addr_increment(orf_addr_increment)
    );

    
   MFU mfu0( 
    .activation_type(activation_type),
    .operation(operation),
    .in_data_available(in_data_available),
    .vrf_addr_read_add(vrf_addr_read1),
    .vrf_addr_rw_add(vrf_addr_rw1),
    .vrf_read_enable_add(vrf_read_enable1),
    .vrf_rw_enable_add(vrf_rw_enable1),

    .vrf_addr_read_mul(vrf_addr_read2),
    .vrf_addr_rw_mul(vrf_addr_rw2),
    .vrf_read_enable_mul(vrf_read_enable2),
    .vrf_rw_enable_mul(vrf_rw_enable2),
    .primary_inp(result_mvm),
    .secondary_inp(vrf_in_data),
    .out_data(output_final_stage),
    .out_data_available(out_data_available),
    .clk(clk),
    .out_vrf_add(vrf_out_data1),
    .out_vrf_mul(vrf_out_data2),
    .reset(reset_mfu));


endmodule