f = open("instr_decoder_gen.v", "w")

NUM_VRFS = 4
a = '''`define INSTR_WIDTH 10+10+4
`define VRF_AWIDTH 10
`define VRF_DWIDTH 160
`define DRAM_DWIDTH 160

`define MRF_AWIDTH 10
`define MRF_DWIDTH 160
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
//MEM_IDS
'''
f.write(a)
for i in range(NUM_VRFS):
  a = '''`define VRF_{i} {i}
  '''.format(i=i)

  f.write(a)

a= '''module instruction_decoder(
    input[`INSTR_WIDTH-1:0] instruction,
    input[`DRAM_DWIDTH-1:0] input_data,
    output reg [`DRAM_DWIDTH-1:0] output_data,

    output reg start,
    output reg resetn,
    output reg reset,
    output reg in_data_available,
    output reg vrf_read_enable,
    output reg vrf_write_enable,
    output reg[1:0] activation,
    output reg[1:0] operation,
'''

f.write(a)

for i in range(0,NUM_VRFS):
  a = '''
      input[`VRF_DWIDTH-1:0] vrf_out_data{i},
      output reg vrf_read_enable{i},
      output reg vrf_rw_enable{i},
      output reg[`VRF_AWIDTH-1:0] vrf_addr_read{i},
      output reg[`VRF_AWIDTH-1:0] vrf_addr_rw{i},
      output reg[`VRF_DWIDTH-1:0] vrf_in_data{i},
  '''.format(i=i)
  f.write(a)

a = '''
    output reg[`MRF_AWIDTH-1:0] mrf_addr_rw,
    output reg mrf_rw_enable,
    output reg[`MRF_DWIDTH-1:0] mrf_in_data
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
            case(op1) 
'''
f.write(a)

for i in range(0,NUM_VRFS):
  a = '''
              `VRF_{i}: begin vrf_rw_enable{i} = 1'b0;
              vrf_addr_rw{i} = op2; 
              output_data = vrf_out_data{i};
              end
  '''.format(i=i)
  f.write(a)

a = '''default: begin 
            vrf_rw_enable0 = 1'b0;
            vrf_addr_rw0 = op2; 
            output_data = vrf_out_data0;
            end
            endcase
        end
        `V_WR: begin
            case(op1) 
            '''
f.write(a)

for i in range(0,NUM_VRFS):
  a = '''
              `VRF_{i}: begin vrf_rw_enable{i} = 1'b0;
              vrf_addr_rw{i} = op2; 
              output_data = vrf_out_data{i};
              end
  '''.format(i=i)
  f.write(a)

a = ''' default: begin 
                vrf_rw_enable3 = 1'b1;
                vrf_addr_rw3 = op2;
              end
            endcase
        end
        `M_RD: begin
            mrf_addr_rw = op2;
            mrf_rw_enable = 1'b0;
            //DOUBT
        end
        `M_WR: begin
            mrf_addr_rw = op2;
            mrf_rw_enable = 1'b1;
            mrf_in_data = input_data;
        end
        `MV_MUL: begin
           start = 1'b1;
           reset = 1'b0;
           mrf_addr_rw = op2;
           mrf_rw_enable = 1'b0;
        end
        `VV_ADD:begin
          resetn<=1'b1;
          operation<=`ELT_WISE_ADD;
          vrf_addr_read{i} = op2;
        end
        `VV_SUB: begin
          resetn<=1'b1;
          operation<=`ELT_WISE_ADD;
          vrf_addr_read{i} = op2;
          vrf_read_enable{i} = 1'b0;
        end
        `VV_PASS:begin
          ;
        end
        `VV_MUL:begin
          resetn<=1'b1;
          operation<=`ELT_WISE_MULTIPLY;
          vrf_addr_read{j} = op2;
          vrf_read_enable{j} = 1'b0;
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
endmodule'''.format(i=NUM_VRFS-2,j=NUM_VRFS-1)


f.write(a)


