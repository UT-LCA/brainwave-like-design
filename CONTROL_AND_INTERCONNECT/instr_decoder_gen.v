`define INSTR_WIDTH 10+10+4
`define VRF_AWIDTH 10
`define MRF_AWIDTH 10
`define MEM_ID_WIDTH 4
`define OPCODE_WIDTH 4 


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

module instruction_decoder(
    input[`INSTR_WIDTH-1:0] instruction,
    output reg start,
    output reg resetn,
    output reg reset,
    output reg in_data_available,
    output reg vrf_read_enable,
    output reg vrf_write_enable,
    output reg[1:0] activation,
    output reg[1:0] operation,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_read,
    output reg[`VRF_AWIDTH-1:0] vrf_addr_write,
    output reg[`MRF_AWIDTH-1:0] mrf_addr_read,
    output reg[`MRF_AWIDTH-1:0] mrf_addr_write,
    output reg mrf_read_enable,
    output reg mrf_write_enable,
    output reg[`MEM_ID_WIDTH-1:0] mem_id_vector,
    output reg[`MEM_ID_WIDTH-1:0] mem_id_matrix
);

    wire[`OPCODE_WIDTH-1:0] opcode;
    wire[`VRF_AWIDTH-1:0] op1;
    wire[`VRF_AWIDTH-1:0] op2;

    assign op1 = instruction[2*`VRF_AWIDTH-1:`VRF_AWIDTH];
    assign op2 = instruction[`VRF_AWIDTH-1:0];
    assign opcode = instruction[`INSTR_WIDTH-1:`INSTR_WIDTH-`OPCODE_WIDTH];

    always@(*) begin
      case(opcode)
        `V_RD: begin
            mem_id_vector<=op1;
            vrf_addr_read<=op2;
            vrf_read_enable<=1'b1;
        end
        `V_WR: begin
            mem_id_vector<=op1;
            vrf_addr_write<=op2;
            vrf_write_enable<=1'b1;
        end
        `M_RD: begin
            mem_id_matrix<=op1;
            mrf_addr_read<=op2;
            mrf_read_enable<=1'b1;
        end
        `M_WR: begin
            mem_id_matrix<=op1;
            mrf_addr_write<=op2;
            mrf_write_enable<=1'b1;
        end
        `MV_MUL: begin
           start<=1'b1;
           reset<=1'b0;
        end
        `VV_ADD:begin
          resetn<=1'b1;
          operation<=`ELT_WISE_ADD;
        end
        `VV_SUB: begin
          resetn<=1'b1;
          operation<=`ELT_WISE_ADD;
        end
        `VV_PASS:begin
          
        end
        `VV_MUL:begin
          resetn<=1'b1;
          operation<=`ELT_WISE_MULTIPLY;
        end
        `V_RELU:begin
          resetn<=1'b1;
          in_data_available<=1'b1;
          operation<=`ACTIVATION;
          activation<=`RELU;
        end
        `V_SIGM:begin
          resetn<=1'b1;
          in_data_available<=1'b1;
          operation<=`ACTIVATION;
          activation<=`SIGM;
        end
        `V_TANH:begin
          resetn<=1'b1;
          in_data_available<=1'b1;
          operation<=`ACTIVATION;
          activation<=`TANH;
        end
        `END_CHAIN:begin
          reset<=1'b1;
          start<=1'b0;
          in_data_available<=1'b0;
          resetn<=1'b0;
        end
      endcase
    end
endmodule
