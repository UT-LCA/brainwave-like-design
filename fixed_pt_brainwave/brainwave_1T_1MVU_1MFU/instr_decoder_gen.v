`include "includes.v"
`define DRAM_DWIDTH `VRF_DWIDTH
`define DRAM_AWIDTH `VRF_AWIDTH

`define MEM_ID_WIDTH 4
`define OPCODE_WIDTH 4 
`define TARGET_OP_WIDTH 2

`define INSTR_WIDTH `OPCODE_WIDTH+`TARGET_OP_WIDTH+`DRAM_AWIDTH+`TARGET_OP_WIDTH+`VRF_AWIDTH

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
`define MV_MUL 3
`define VV_ADD 4
`define VV_SUB 5 //QUESTIONED
`define VV_PASS 6
`define VV_MUL 7
`define V_RELU 8
`define V_SIGM 9
`define V_TANH 10
`define END_CHAIN 11

//MEM_IDS
`define VRF_0 0
`define VRF_1 1
`define VRF_2 2
`define VRF_3 3

module instruction_decoder(
    input clk,
    
    input reset_npu,
    input[`INSTR_WIDTH-1:0] instruction,
    input[`DRAM_DWIDTH-1:0] input_data,
    output reg[`DRAM_AWIDTH-1:0] dram_addr_wr,
    output reg dram_wr_enable,
    output reg [`DRAM_DWIDTH-1:0] output_data,

    output reg start_mvu,
    output reg reset_mfu,
    output reg reset_mvu,
    output reg in_data_available,
    output reg[1:0] activation,
    output reg[1:0] operation,

    input[`VRF_DWIDTH-1:0] vrf_out_data0,
    output reg vrf_readn_enable0,
    output reg vrf_rw_enable0,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_read0,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_rw0,

    input[`VRF_DWIDTH-1:0] vrf_out_data1,
    output reg vrf_readn_enable1,
    output reg vrf_rw_enable1,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_read1,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_rw1,

    input[`VRF_DWIDTH-1:0] vrf_out_data2,
    output reg vrf_readn_enable2,
    output reg vrf_rw_enable2,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_read2,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_rw2,

    output reg[`VRF_DWIDTH-1:0] vrf_in_data,

    output reg[`MRF_AWIDTH*`NUM_LDPES-1:0] mrf_addr_rw,

    output reg[(1<<`TARGET_OP_WIDTH)-1:0] mrf_rw_enable, //NOTE: LOG(NUM_LDPES) = TARGET_OP_WIDTH
    output reg[`MRF_DWIDTH-1:0] mrf_in_data,
    output reg orf_addr_increment
);

    wire[`OPCODE_WIDTH-1:0] opcode;
    wire[`VRF_AWIDTH-1:0] op1_address;
    wire[`VRF_AWIDTH-1:0] op2_address;
    wire[`TARGET_OP_WIDTH-1:0] op1_id;

    //NOTE - CORRECT NAMING FOR OPERANDS AND EXTRACTION SCHEME FOR YOUR PARTS OF INSTRUCTION
    assign op1_address = instruction[2*(`VRF_AWIDTH+`TARGET_OP_WIDTH)-1:`VRF_AWIDTH+`TARGET_OP_WIDTH];
    assign op2_address = instruction[`VRF_AWIDTH-1:0];
    assign opcode = instruction[`INSTR_WIDTH-1:`INSTR_WIDTH-`OPCODE_WIDTH];
    assign op1_id = instruction[2*(`VRF_AWIDTH+`TARGET_OP_WIDTH):2*`VRF_AWIDTH+`TARGET_OP_WIDTH]; //mem_id

    //TODO - MAKE THIS SEQUENTIAL LOGIC
    always@(posedge clk) begin
    if(reset_npu == 1'b1) begin
          reset_mvu<=1'b1;
          start_mvu<=1'b0;
          in_data_available<=1'b0;
          reset_mfu<=1'b0;
          mrf_rw_enable<=0;
          vrf_rw_enable0<=0;
          vrf_rw_enable1<=0;
          vrf_rw_enable2<=0;
          
          vrf_readn_enable0<=0;
          vrf_readn_enable1<=0;
          vrf_readn_enable2<=0;
          orf_addr_increment<=1'b0;
          mrf_addr_rw <= 0;
    end
    else begin
      case(opcode)
        `V_WR: begin
            case(op1_id) 
            `VRF_0: begin vrf_rw_enable0 <= 1'b0;
            vrf_addr_rw0 <= op1_address; 
            output_data <= vrf_out_data0;
            end

            `VRF_1: begin vrf_rw_enable1 <= 1'b0;
            vrf_addr_rw1 <= op1_address; 
            output_data <= vrf_out_data1;
            end

            `VRF_2: begin vrf_rw_enable2 <= 1'b0;
            vrf_addr_rw2 <= op1_address; 
            output_data <= vrf_out_data2;
            end
            
            default: begin 
            vrf_rw_enable0 <= 1'b0;
            vrf_addr_rw0 <= op1_address; 
            output_data <= vrf_out_data0;
            end

            endcase
            dram_addr_wr <= op2_address;
            dram_wr_enable <= 1'b1;
        end
        `V_RD: begin
            case(op1_id) 
              `VRF_0: begin 
              vrf_rw_enable0 <= 1'b1;
              vrf_addr_rw0 <= op1_address;
              end

              `VRF_1: begin 
              vrf_rw_enable1 <= 1'b1;
              vrf_addr_rw1 <= op1_address;
              end

              `VRF_2: begin 
              vrf_rw_enable2 <= 1'b1;
              vrf_addr_rw2 <= op1_address;
              end

              default: begin 
                vrf_rw_enable1 <= 1'b1;
                vrf_addr_rw1 <= op1_address;
              end
            endcase
            vrf_in_data <= input_data[`VRF_DWIDTH-1:0];
            dram_addr_wr <= op2_address;
            dram_wr_enable <= 1'b0;
        end
        //CHANGE NAMING CONVENTION FOR WRITE AND READ TO STORE AND LOAD
        //ADD COMMENTS FOR SRC AND DESTINATION
        `M_RD: begin
            case(op1_id) 
              0: begin 
                mrf_rw_enable[0] <= 1'b1;
                mrf_addr_rw[1*`MRF_AWIDTH-1:0*`MRF_AWIDTH] = op1_address;
              end

              1: begin 
                mrf_rw_enable[1] <= 1'b1;
                mrf_addr_rw[2*`MRF_AWIDTH-1:1*`MRF_AWIDTH] = op1_address;
              end

              2: begin 
                mrf_rw_enable[2] <= 1'b1;
                mrf_addr_rw[3*`MRF_AWIDTH-1:2*`MRF_AWIDTH] = op1_address;
              end

              3: begin 
                mrf_rw_enable[3] <= 1'b1;
                mrf_addr_rw[4*`MRF_AWIDTH-1:3*`MRF_AWIDTH] = op1_address;
              end

              default: begin 
                mrf_rw_enable[0] <= 1'b1;
                mrf_addr_rw[1*`MRF_AWIDTH-1:0*`MRF_AWIDTH] = op1_address;
              end
            endcase
            dram_addr_wr <= op2_address;
            dram_wr_enable <= 1'b0;
            mrf_in_data <= input_data;
        end
        `MV_MUL: begin
          //op1_id is don't care for this instructions
           start_mvu <= 1'b1;
           reset_mvu <= 1'b0;
           mrf_addr_rw <= op1_address;
           vrf_readn_enable0 <= 1'b0;
           mrf_rw_enable <= 0;
        end
        `VV_ADD:begin
          reset_mfu<=1'b1;
          operation<=`ELT_WISE_ADD;      //NOTE - 2nd VRF INDEX IS FOR ADD UNITS ELT WISE
          vrf_addr_read1 <= op1_address;
          vrf_readn_enable1 <= 1'b0;
          orf_addr_increment<=1'b1;
        end
        `VV_SUB: begin
          reset_mfu<=1'b1;
          operation<=`ELT_WISE_ADD;
          vrf_addr_read1 <= op1_address;
          vrf_readn_enable1 <= 1'b0;
          orf_addr_increment<=1'b1;
        end
        `VV_MUL:begin
          reset_mfu<=1'b1;
          operation<=`ELT_WISE_MULTIPLY;     //NOTE - 3RD VRF INDEX IS FOR ADD UNITS ELT WISE
          vrf_addr_read2 <= op1_address;
          vrf_readn_enable2 <= 1'b0;
          orf_addr_increment<=1'b1;
        end
        `V_RELU:begin
          reset_mfu<=1'b1;
          in_data_available<=1'b1;
          operation<=`ACTIVATION;
          activation<=`RELU;
          orf_addr_increment<=1'b1;
        end
        `V_SIGM:begin
          reset_mfu<=1'b1;
          in_data_available<=1'b1;
          operation<=`ACTIVATION;
          activation<=`SIGM;
          orf_addr_increment<=1'b1;
        end
        `V_TANH:begin
          reset_mfu<=1'b1;
          in_data_available<=1'b1;
          operation<=`ACTIVATION;
          activation<=`TANH;
          orf_addr_increment<=1'b1;
        end
        `END_CHAIN:begin
          reset_mvu<=1'b1;
          start_mvu<=1'b0;
          in_data_available<=1'b0;
          reset_mfu<=1'b0;
          mrf_rw_enable<=0;
          vrf_rw_enable0<=0;
          vrf_rw_enable1<=0;
          vrf_rw_enable2<=0;
          orf_addr_increment<=1'b0;
          vrf_readn_enable0<=0;
          vrf_readn_enable1<=0;
          vrf_readn_enable2<=0;
        end
      endcase
     end
    end             
endmodule             