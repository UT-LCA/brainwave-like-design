`include "npu_gen.v"


module testbench;
    wire[`INSTR_WIDTH-1:0] instruction;
    wire[`DRAM_DWIDTH-1:0] input_data_from_DRAM;
    wire[`DRAM_DWIDTH-1:0] output_data_to_DRAM;
    wire[`DRAM_AWIDTH-1:0] dram_addr;
    wire dram_write_enable;
    wire get_instr_enable;
    reg push_instr_enable;
    reg[`INSTR_WIDTH-1:0] push_instruction;
    wire[`INSTR_WIDTH-1:0] instruction_fake;
    wire[`INSTR_WIDTH-1:0] push_instruction_fake;
    wire[`INSTR_MEM_AWIDTH-1:0] get_instr_addr;
    reg[`INSTR_MEM_AWIDTH-1:0] push_instr_addr;
    //wire[`NUM_LDPES*`OUT_PRECISION-1:0] output_final_stage; 
    reg clk;
    reg reset_npu;
    

    NPU npu_unit(
    .reset_npu(reset_npu),
    .instruction(instruction),
    .input_data_DRAM(input_data_from_DRAM),
    .output_data_DRAM(output_data_to_DRAM),
    .dram_addr(dram_addr),
    .get_instr(get_instr_enable),
    .get_instr_addr(get_instr_addr),
    .dram_write_enable(dram_write_enable),//WRITE IT BACK TO DRAM 
    //WRITE DOCUMENTATION EXPLAINING HOW MANY PORTS EACH VRF,MRF, ORF HAS and WHERE IS IT CONNECTED TO
    .clk(clk)
);

    dram # (
        .AWIDTH(`ORF_AWIDTH),
        .DWIDTH(`ORF_DWIDTH)
    ) dram_mem (
        .clk(clk),
        .addr(dram_addr),
        .in(output_data_to_DRAM),
        .we(dram_write_enable),
        .out(input_data_from_DRAM)
    );
    
    always@(posedge clk) begin
        if(reset_npu==1'b1) begin
            //get_instr_addr <= 0;
            push_instr_addr <= 0;
            push_instr_enable <= 0;
            push_instruction <= 'bX;
        end
    end
    
    instruction_mem # (
        .AWIDTH(`INSTR_MEM_AWIDTH),
        .DWIDTH(`INSTR_WIDTH)
    ) instr_mem(
        .clk(clk),
        .addra(get_instr_addr), 
        .addrb(push_instr_addr),
        .ina(push_instr_fake), 
        .inb(push_instr),
        .wea(1'b0), 
        .web(1'b0),
        .outa(instruction), 
        .outb(instriction_fake)
    );
    
    reg [`OPCODE_WIDTH-1:0] opcode;
    reg [`TARGET_OP_WIDTH-1:0] src_id;
    reg [`TARGET_OP_WIDTH-1:0] dstn_id;
    reg [`VRF_AWIDTH-1:0] op1_address;
    reg [`VRF_AWIDTH-1:0] op2_address;
    reg [`VRF_AWIDTH-1:0] dstn_address;
    
    //assign instruction = {opcode,src_id,op1_address,op2_address,dstn_id,dstn_address};
    initial begin
        clk = 0;
        forever begin
            # 1 clk = ~clk;
        end
    end
    
    initial begin
        
        reset_npu=1'b1;
        #4 reset_npu=1'b0; 
        
        #2000 $finish;
    end 
    
endmodule



module dram # (
    parameter AWIDTH = 10,
    parameter DWIDTH = 80
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
//assign out = ram[addr];
endmodule


module instruction_mem # (
    parameter AWIDTH = `INSTR_MEM_AWIDTH,
    parameter DWIDTH = `INSTR_WIDTH
) (
    input clk,
    input [AWIDTH-1:0] addra, addrb,
    input [DWIDTH-1:0] ina, inb,
    input wea, web,
    output reg [DWIDTH-1:0] outa, outb
);


reg [DWIDTH-1:0] ram [((1<<AWIDTH)-1):0];

// Port A

initial begin
    $readmemb("/home/tanmay/Koios++ - Copy/instructions_binary.txt", ram); //MAKE THIS DATA RANDOM
end

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

//assign outa = ram[addra];
//assign outb = ram[addrb];

endmodule

/*
        //VECTOR READ INSTRUCTIONS WITH INPUT DATA
        
        //TODO - INSTANTIATE A BRAM IN THIS TESTBENCH TO MODEL DRAM
        #10 opcode = `V_RD; op1_address = 0; src_id = 0; op2_address = 0;
        
        #10 opcode = `V_RD; op1_address = 0; src_id = 0; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `V_RD; op1_address = 0; src_id = 1; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd2,8'd2,8'd2,8'd2,8'd2,8'd2,8'd2};
        
        #10 opcode = `V_RD; op1_address = 0; src_id = 2; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd3,8'd3,8'd3,8'd3,8'd3,8'd3,8'd3};
        
        #10 opcode = `V_RD; op1_address = 0; src_id = 3; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd4,8'd4,8'd4,8'd4,8'd4,8'd4,8'd4};
        
        #10 opcode = `V_RD; op1_address = 0; src_id = 4; op2_address = 0;
        //input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};
        
        #10 opcode = `V_RD; op1_address = 0; src_id = 5; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};
        
        #10 opcode = `V_RD; op1_address = 0; src_id = 6; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};
        
        #10 opcode = `V_RD; op1_address = 1; src_id = 0; op2_address = 0;
        
        #10 opcode = `V_RD; op1_address = 1; src_id = 1; op2_address = 0;
        
        #10 opcode = `V_RD; op1_address = 1; src_id = 2; op2_address = 0;
        
        #10 opcode = `V_RD; op1_address = 1; src_id = 3; op2_address = 0;
        
        #10 opcode = `V_RD; op1_address = 1; src_id = 4; op2_address = 0;
       
        #10 opcode = `V_RD; op1_address = 1; src_id = 5; op2_address = 0;
//input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};   
                                                                 
        #10 opcode = `V_RD; op1_address = 1; src_id = 6; op2_address = 0;
        // input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};   
                                                                         
        #10 opcode = `V_RD; op1_address = 2; src_id = 0; op2_address = 0;
        // input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};   
                                                                         
        #10 opcode = `V_RD; op1_address = 2; src_id = 1; op2_address = 0;
                                                                         
        #10 opcode = `V_RD; op1_address = 2; src_id = 2; op2_address = 0;
                                                                         
        #10 opcode = `V_RD; op1_address = 2; src_id = 3; op2_address = 0;
                                                                         
        #10 opcode = `V_RD; op1_address = 2; src_id = 4; op2_address = 0;
                                                                         
        #10 opcode = `V_RD; op1_address = 2; src_id = 5; op2_address = 0;
        
        #10 opcode = `V_RD; op1_address = 2; src_id = 6; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5,8'd5};
        
        //WRITE DATA TO DRAM FROM VRF 
        
       // #10 opcode = `V_WR; op1_address = 0; mem_id = 0; op2_address = 0;
        
        
        //READ DATA FROM DRAM TO MRF 
        #20 opcode = `M_RD; op1_address = 0; src_id = 0; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 0; src_id = 1; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 0; src_id = 2; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 0; src_id = 3; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 1; src_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 1; src_id = 1; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 1; src_id = 2; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 1; src_id = 3; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 2; src_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 2; src_id = 1; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 2; src_id = 2; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 2; src_id = 3; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 3; src_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 3; src_id = 1; op2_address = 0;
        
     //   input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};

        
        #10 opcode = `M_RD; op1_address = 3; src_id = 2; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 3; src_id = 3; op2_address = 0;
     //   input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 4; src_id = 0; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 4; src_id = 1; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 4; src_id = 2; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 4; src_id = 3; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
       #10 opcode = `M_RD; op1_address = 5; src_id = 0; op2_address = 0;
       
       #10 opcode = `M_RD; op1_address = 5; src_id = 1; op2_address = 0;
       
       #10 opcode = `M_RD; op1_address = 5; src_id = 2; op2_address = 0;
       
       #10 opcode = `M_RD; op1_address = 5; src_id = 3; op2_address = 0;
       
       #10 opcode = `M_RD; op1_address = 6; src_id = 0; op2_address = 0;
       
       #10 opcode = `M_RD; op1_address = 6; src_id = 1; op2_address = 0;       
       
        #10 opcode = `M_RD; op1_address = 6; src_id = 2; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 6; src_id = 3; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 7; src_id = 0; op2_address = 0;
      //  input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 7; src_id = 1; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 7; src_id = 2; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 7; src_id = 3; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `M_RD; op1_address = 8; src_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 8; src_id = 1; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 8; src_id = 2; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 8; src_id = 3; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 9; src_id = 0; op2_address = 0;
        
        #10 opcode = `M_RD; op1_address = 9; src_id = 1; op2_address = 0;
        
       // input_data_DRAM = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
        //WORKS-----------------------------------------------------
        
        //READ DATA FROM DRAM TO MFU VRFs
        #10 opcode = `V_RD; op1_address = 0; src_id = 1; op2_address = 0;
       // input_data_DRAM = {8'd1,8'd2,8'd3,8'd1,8'd1,8'd1,8'd1,8'd1};
        
        #10 opcode = `V_RD; op1_address = 0; src_id = 2; op2_address = 0;
       // input_data_DRAM = {8'd2,8'd3,8'd4,8'd1,8'd0,8'd0,8'd0,8'd1};
        //ADD READMEMH - TRY IT for VRF AND MRF
        //START MVM
        
        #10 opcode = `MV_MUL; op1_address = 2; dstn_id = `MFU_0_DSTN_ID; dstn_address = 0;
        
        #70 opcode = `VV_ADD; op1_address = 0; src_id = 2; dstn_id = `MFU_1_DSTN_ID; op2_address = 0;
        
        #40 opcode = `END_CHAIN;
        */