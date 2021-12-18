`include "NPU.v"

module dram # (
    parameter AWIDTH = 10,
    parameter DWIDTH = 1600
) (
    input clk,
    input [AWIDTH-1:0] addr,
    input [DWIDTH-1:0] in,
    input we,
    output reg [DWIDTH-1:0] out
);

reg [DWIDTH-1:0] ram [((1<<AWIDTH)-1):0];

initial begin
    $readmemh("/home/tanmay/Koios++ - Copy/dram_data.txt", ram,0); //MAKE THIS DATA RANDOM
end

always @(posedge clk)  begin

    if (we) begin
        ram[addr] <= in;
    end

    out <= ram[addr];
end

endmodule

module testbench;
    wire[`INSTR_WIDTH-1:0] instruction;
    wire[`VRF_DWIDTH-1:0] input_data_DRAM;
    wire[`VRF_DWIDTH-1:0] output_data_DRAM;
    wire[`DRAM_AWIDTH-1:0] dram_addr;
    wire dram_write_enable;
    wire[`NUM_LDPES*`OUT_PRECISION-1:0] output_final_stage; 
    reg clk;
    reg reset_npu;

    NPU npu_unit(
    .reset_npu(reset_npu),
    .instruction(instruction),
    .input_data_DRAM(input_data_DRAM),
    .output_data_DRAM(output_data_DRAM),
    .dram_addr(dram_addr),
    .dram_write_enable(dram_write_enable),
    .output_final_stage(output_final_stage), //WRITE IT BACK TO DRAM 
    //WRITE DOCUMENTATION EXPLAINING HOW MANY PORTS EACH VRF,MRF, ORF HAS and WHERE IS IT CONNECTED TO
    .clk(clk)
);

    dram # (
        .AWIDTH(`VRF_AWIDTH),
        .DWIDTH(`VRF_DWIDTH)
    ) dram_mem (
        .clk(clk),
        .addr(dram_addr),
        .in(output_data_DRAM),
        .we(dram_write_enable),
        .out(input_data_DRAM)
    );
    
    reg [`OPCODE_WIDTH-1:0] opcode;
    reg [`TARGET_OP_WIDTH-1:0] mem_id;
    reg [`VRF_AWIDTH-1:0] op1_address;
    reg [`VRF_AWIDTH-1:0] op2_address;
    
    assign instruction = {opcode,mem_id,op1_address,2'b00,op2_address};
    initial begin
        clk = 0;
        forever begin
            # 5 clk = ~clk;
        end
    end
    
    initial begin
        
        reset_npu=1'b1;
        #10 reset_npu=1'b0;
        //VECTOR READ INSTRUCTIONS WITH INPUT DATA
        
        //TODO - INSTANTIATE A BRAM IN THIS TESTBENCH TO MODEL DRAM
        #10 opcode = `V_RD; op1_address = 0; mem_id = 0; op2_address = 0;
        #10
        opcode = `V_RD; op1_address = 0; mem_id = 0; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `V_RD; op1_address = 1; mem_id = 0; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd2,8'd2,8'd2,8'd2,8'd2,8'd2,8'd2};
        
        #10 opcode = `V_RD; op1_address = 2; mem_id = 0; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd3,8'd3,8'd3,8'd3,8'd3,8'd3,8'd3};
        
        #10 opcode = `V_RD; op1_address = 3; mem_id = 0; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd4,8'd4,8'd4,8'd4,8'd4,8'd4,8'd4};
        
        #10 opcode = `V_RD; op1_address = 4; mem_id = 0; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};
        
        #10 opcode = `V_RD; op1_address = 5; mem_id = 0; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};
        
        #10 opcode = `V_RD; op1_address = 6; mem_id = 0; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};
        
        #10 opcode = `V_RD; op1_address = 7; mem_id = 0; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};
        
        //WRITE DATA TO DRAM FROM VRF 
        
       // #10 opcode = `V_WR; op1_address = 0; mem_id = 0; op2_address = 0;
        
        
        //READ DATA FROM DRAM TO MRF 
        #20 opcode = `M_RD; op1_address = 0; mem_id = 0; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 1; mem_id = 0; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 2; mem_id = 0; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 3; mem_id = 0; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 4; mem_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 5; mem_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 6; mem_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 7; mem_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 8; mem_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 9; mem_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 10; mem_id = 0; op2_address = 0;
        #10 opcode = `M_RD; op1_address = 11; mem_id = 0; op2_address = 0;
        #10 opcode = `M_RD; op1_address = 12; mem_id = 0; op2_address = 0;
        #10 opcode = `M_RD; op1_address = 13; mem_id = 0; op2_address = 0;
        
     //   input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};

        
        #10 opcode = `M_RD; op1_address = 0; mem_id = 1; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 1; mem_id = 1; op2_address = 0;
     //   input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 2; mem_id = 1; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 3; mem_id = 1; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 4; mem_id = 1; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 5; mem_id = 1; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
       #10 opcode = `M_RD; op1_address = 6; mem_id = 1; op2_address = 0;
       
       #10 opcode = `M_RD; op1_address = 7; mem_id = 1; op2_address = 0;
       #10 opcode = `M_RD; op1_address = 8; mem_id = 1; op2_address = 0;
       #10 opcode = `M_RD; op1_address = 9; mem_id = 1; op2_address = 0;
       #10 opcode = `M_RD; op1_address = 10; mem_id = 1; op2_address = 0;
       #10 opcode = `M_RD; op1_address = 11; mem_id = 1; op2_address = 0;       
       
       
        
        #10 opcode = `M_RD; op1_address = 0; mem_id = 2; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 1; mem_id = 2; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 2; mem_id = 2; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 3; mem_id = 2; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 4; mem_id = 2; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 5; mem_id = 2; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 6; mem_id = 2; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 7; mem_id = 2; op2_address = 0;
        #10 opcode = `M_RD; op1_address = 8; mem_id = 2; op2_address = 0;
        #10 opcode = `M_RD; op1_address = 9; mem_id = 2; op2_address = 0;
        #10 opcode = `M_RD; op1_address = 10; mem_id = 2; op2_address = 0;
        #10 opcode = `M_RD; op1_address = 11; mem_id = 2; op2_address = 0;
        
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        //WORKS-----------------------------------------------------
        
        //READ DATA FROM DRAM TO MFU VRFs
        #10 opcode = `V_RD; op1_address = 0; mem_id = 1; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd2,8'd3,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `V_RD; op1_address = 0; mem_id = 2; op2_address = 0;
       // input_data_DRAM = {8'd2,8'd3,8'd4,8'd1,8'd0,8'd0,8'd0,8'd1};
        //ADD READMEMH - TRY IT for VRF AND MRF
        //START MVM
        #10 opcode = `MV_MUL; op1_address = 0;
        
        #105 $finish;
    end 
    
endmodule
