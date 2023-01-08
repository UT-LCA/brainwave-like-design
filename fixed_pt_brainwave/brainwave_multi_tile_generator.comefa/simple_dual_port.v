module simple_dual_port(
	clk,
	wr_en,
	read_address,
	write_address,
	read_data,
	write_data
);
parameter address_width = 9; //9 bits long address bus
parameter word_length = 40; //40 bits long word
input clk; //clock
input wr_en; //write enable
input [(address_width - 1):0] read_address; //read_address
input [(address_width - 1):0] write_address; //write_address
input [(word_length - 1):0] write_data; //input_data
output [(word_length - 1):0] read_data; //output_data

`ifndef hard_mem
reg [(word_length - 1):0] simple_dual_port [((1<<address_width) - 1):0]; //memory
reg [(word_length - 1):0] read_data; //output_data


always @(posedge clk)begin 
	if (wr_en == 1) begin //write operation
		simple_dual_port[write_address] <= write_data; 			
	end
	//else if (wr_en == 0)begin //read operation
		read_data <= simple_dual_port[read_address];
	//end
end

`else

simple_dual_port_ram u_simple_dual_port_ram(
.addr1(write_address),
.we1(wr_en),
.data1(write_data),
.addr2(read_address),
.out2(read_data),
.clk(clk)
);


`endif

endmodule

