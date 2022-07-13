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
                    mrf_in_data[16*`MRF_DWIDTH-1:15*`MRF_DWIDTH] <= input_data_from_dram;
                    mrf_addr_for_dram[16*`MRF_AWIDTH-1:15*`MRF_AWIDTH] = dstn_address;            
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