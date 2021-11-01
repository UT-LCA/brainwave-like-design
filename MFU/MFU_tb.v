`define DESIGN_SIZE 10
`define DWIDTH 16
`define MASK_WIDTH 8
`define VRF_AWIDTH 10

`define BRAMS_PER_VRF 10
`define VRF_DWIDTH 16*10
`define VEC_BRAM_AWIDTH 10
`define VEC_BRAM_DWIDTH 16

`define ACTIVATION 2'b00
`define ELT_WISE_MULTIPY 2'b10
`define ELT_WISE_ADD 2'b01
`define BYPASS 2'b11

`define ADD_LATENCY 1
`define LOG_ADD_LATENCY 1
`define MUL_LATENCY 1
`define LOG_MUL_LATENCY 1 

module tb_brainwave;

    reg clk;
    reg resetn;
    
    reg activation_type;
    reg[1:0] operation;
    reg in_data_available;
    reg [`VRF_AWIDTH-1:0] vrf_addr_read;
    reg [`VRF_AWIDTH-1:0] vrf_addr_write;
    reg vrf_read_enable;
    reg vrf_write_enable;
    reg [`DESIGN_SIZE*`DWIDTH-1:0] primary_inp;
    reg [`DESIGN_SIZE*`DWIDTH-1:0] secondary_inp;
    //OUTPUT
    wire [`DESIGN_SIZE*`DWIDTH-1:0] out_data;
    wire out_data_available;
  
    
    MFU mf0(.clk(clk),.resetn(resetn), .activation_type(activation_type),
    .operation(operation),.in_data_available(in_data_available),.vrf_addr_read(vrf_addr_read),
    .vrf_addr_write(vrf_addr_write),.vrf_read_enable(vrf_read_enable),.vrf_write_enable(vrf_write_enable),
    .primary_inp(primary_inp),.secondary_inp(secondary_inp),.out_data(out_data),.out_data_available(out_data_available));
    
    initial begin
        clk <= 0;
        resetn<=0;        
        activation_type<=0;
        operation<=2'b01;
        in_data_available<=0;
        vrf_addr_read<=0;
        vrf_addr_write<=0;
        vrf_read_enable<=0;
        vrf_write_enable<=0;
        primary_inp<={16'd20,16'd3,16'd370,16'd56,16'd3,16'd3234,16'd3,16'd3,16'd3,16'd3};
        secondary_inp<={16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd40,16'd1,16'd1};
        forever begin
            #1 clk = ~clk;
        end
    end
        
    
    initial begin
        #2
        resetn <= 1'b1;
        vrf_write_enable<=1;
        #2
        vrf_addr_write<=vrf_addr_write+1'b1;
        in_data_available<=1;
        #2
        vrf_read_enable<=1;
        #2 
        $display("Output data 1 %d",out_data[(1*`DWIDTH)-1:(0*`DWIDTH)]);
        $display("Output data 2 %d",out_data[(2*`DWIDTH)-1:(1*`DWIDTH)]);
        $display("Output data 3 %d",out_data[(3*`DWIDTH)-1:(2*`DWIDTH)]);
        $display("Output data 4 %d",out_data[(4*`DWIDTH)-1:(3*`DWIDTH)]);
        $display("Output data 5 %d",out_data[(5*`DWIDTH)-1:(4*`DWIDTH)]);
        $display("Output data 6 %d",out_data[(6*`DWIDTH)-1:(5*`DWIDTH)]);
        $display("Output data 7 %d",out_data[(7*`DWIDTH)-1:(6*`DWIDTH)]);
        $display("Output data 8 %d",out_data[(8*`DWIDTH)-1:(7*`DWIDTH)]);
        $display("Output data 9 %d",out_data[(9*`DWIDTH)-1:(8*`DWIDTH)]);
        $display("Output data 10 %d",out_data[(10*`DWIDTH)-1:(9*`DWIDTH)]);
        
    end

endmodule
