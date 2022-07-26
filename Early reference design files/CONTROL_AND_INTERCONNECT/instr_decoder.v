
/* Author: Tanmay Anand, Visiting Student, UT-LCA
Email: tanmay.anand29@gmail.com
GItHub Username: saitama0300 */

`define VRF_AWIDTH 10
`define VRF_DWIDTH 160
`define DRAM_DWIDTH 160
`define DRAM_AWIDTH 10


`define MRF_AWIDTH 10
`define MRF_DWIDTH 160
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
`define M_WR 3
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

module instruction_decoder(
    input[`INSTR_WIDTH-1:0] instruction,
    input[`DRAM_DWIDTH-1:0] input_data,
    output reg[`DRAM_AWIDTH-1:0] dram_addr_we,
    output reg dram_wr_enable,
    output reg [`DRAM_DWIDTH-1:0] output_data,

    output reg start,
    output reg resetn,
    output reg reset,
    output reg in_data_available,
    output reg vrf_read_enable,
    output reg vrf_write_enable,
    output reg[1:0] activation,
    output reg[1:0] operation,

    input[`VRF_DWIDTH-1:0] vrf_out_data0,
    output reg vrf_read_enable0,
    output reg vrf_rw_enable0,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_read0,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_rw0,
    output reg[`VRF_DWIDTH-1:0] vrf_in_data0,
    
    input[`VRF_DWIDTH-1:0] vrf_out_data3,
    output reg vrf_read_enable3,
    output reg vrf_rw_enable3,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_read3,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_rw3,
    output reg[`VRF_DWIDTH-1:0] vrf_in_data3,

    input[`VRF_DWIDTH-1:0] vrf_out_data1,
    output reg vrf_read_enable1,
    output reg vrf_rw_enable1,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_read1,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_rw1,
    output reg[`VRF_DWIDTH-1:0] vrf_in_data1,

    input[`VRF_DWIDTH-1:0] vrf_out_data2,
    output reg vrf_read_enable2,
    output reg vrf_rw_enable2,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_read2,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_rw2,
    output reg[`VRF_DWIDTH-1:0] vrf_in_data2,

    output reg[`MRF_AWIDTH-1:0] mrf_addr_rw0,
    output reg[`MRF_AWIDTH-1:0] mrf_addr_rw1,
    output reg[`MRF_AWIDTH-1:0] mrf_addr_rw2,
    output reg[`MRF_AWIDTH-1:0] mrf_addr_rw3,

    output reg[(1<<`TARGET_OP_WIDTH)-1:0] mrf_rw_enable,
    output reg[`MRF_DWIDTH-1:0] mrf_in_data
);

    wire[`OPCODE_WIDTH-1:0] opcode;
    wire[`VRF_AWIDTH-1:0] op1;
    wire[`VRF_AWIDTH-1:0] op2;
    wire[`TARGET_OP_WIDTH-1:0] target;

    assign op1 = instruction[2*`VRF_AWIDTH-1:`VRF_AWIDTH+`TARGET_OP_WIDTH];
    assign op2 = instruction[`VRF_AWIDTH-1:0];
    assign opcode = instruction[`INSTR_WIDTH-1:`INSTR_WIDTH-`OPCODE_WIDTH+`TARGET_OP_WIDTH];
    assign target = instruction[2*`VRF_AWIDTH+`TARGET_OP_WIDTH:2*`VRF_AWIDTH];

    always@(*) begin
      case(target)
        `V_RD: begin
            case(op1) 
            `VRF_0: begin vrf_rw_enable0 = 1'b0;
            vrf_addr_rw0 = op1; 
            output_data = vrf_out_data0;
            end

            `VRF_1: begin vrf_rw_enable1 = 1'b0;
            vrf_addr_rw1 = op1; 
            output_data = vrf_out_data1;
            end

            `VRF_2: begin vrf_rw_enable2 = 1'b0;
            vrf_addr_rw2 = op1; 
            output_data = vrf_out_data2;
            end

            `VRF_3: begin vrf_rw_enable3 = 1'b0;
            vrf_addr_rw3 = op1; 
            output_data = vrf_out_data3;
            end

            default: begin 
            vrf_rw_enable0 = 1'b0;
            vrf_addr_rw0 = op1; 
            output_data = vrf_out_data0;
            end
            endcase
            dram_addr_wr<=op2;
            dram_wr_enable<1'b0;
        end
        `V_WR: begin
            case(target) 
              `VRF_0: begin 
              vrf_rw_enable0 = 1'b1;
              vrf_addr_rw0 = op1;
              end

              `VRF_1: begin 
              vrf_rw_enable1 = 1'b1;
              vrf_addr_rw1 = op1;
              end

              `VRF_2: begin 
              vrf_rw_enable2 = 1'b1;
              vrf_addr_rw2 = op1;
              end

              `VRF_3: begin 
              vrf_rw_enable3 = 1'b1;
              vrf_addr_rw3 = op1;
              end

              default: begin 
                vrf_rw_enable3 = 1'b1;
                vrf_addr_rw3 = op1;
              end
            endcase
            dram_addr_wr<=op2;
            dram_wr_enable<1'b1;
        end
        `M_WR: begin
            case(target) 
              0: begin 
                mrf_rw_enable[0] = 1'b1;
                mrf_addr_rw0 = op1;
              end

              1: begin 
                mrf_rw_enable[1] = 1'b1;
                mrf_addr_rw1 = op1;
              end

              2: begin 
                mrf_rw_enable[2] = 1'b1;
                mrf_addr_rw2 = op1;
              end

              3: begin 
                mrf_rw_enable[3] = 1'b1;
                mrf_addr_rw3 = op1;
              end

              default: begin 
                mrf_rw_enable[0] = 1'b1;
                mrf_addr_rw0 = op1;
              end
            endcase
            
            mrf_in_data = input_data;
        end
        `MV_MUL: begin
           start = 1'b1;
           reset = 1'b0;
           mrf_addr_rw = op1;
           mrf_rw_enable = 0;
        end
        `VV_ADD:begin
          resetn=1'b1;
          operation=`ELT_WISE_ADD;      //NOTE - 2nd VRF INDEX IS FOR ADD UNITS ELT WISE
          vrf_addr_read2 = op1;
          vrf_read_enable2 = 1'b1;
        end
        `VV_SUB: begin
          resetn=1'b1;
          operation=`ELT_WISE_ADD;
          vrf_addr_read2 = op1;
          vrf_read_enable2 = 1'b1;
        end
        `VV_PASS:begin
          ;
        end
        `VV_MUL:begin
          resetn=1'b1;
          operation=`ELT_WISE_MULTIPLY;     //NOTE - 3RD VRF INDEX IS FOR ADD UNITS ELT WISE
          vrf_addr_read3 = op1;
          vrf_read_enable3 = 1'b1;
        end
        `V_RELU:begin
          resetn=1'b1;
          in_data_available=1'b1;
          operation=`ACTIVATION;
          activation=`RELU;
        end
        `V_SIGM:begin
          resetn=1'b1;
          in_data_available=1'b1;
          operation=`ACTIVATION;
          activation=`SIGM;
        end
        `V_TANH:begin
          resetn=1'b1;
          in_data_available=1'b1;
          operation=`ACTIVATION;
          activation=`TANH;
        end
        `END_CHAIN:begin
          reset=1'b1;
          start=1'b0;
          in_data_available=1'b0;
          resetn=1'b0;
        end
      endcase
    end
endmodule