<%!
    import math

    num_tiles = 1 #CHANGE THIS
    num_ldpes = 32 #
    assert(num_ldpes%4==0), "Currently only supporting multiples of 4 here"
    num_dsp_per_ldpe = 16 #CHANGE THIS
    num_reduction_stages = int(math.log2(num_tiles))
    num_inputs = num_ldpes #every cycle we generate `num_ldpes` worth of items from the MVU
    assert(num_inputs%2==0),"Currently only supporting even number of outputs from the MVU"
    num_outputs = int(num_ldpes/2) #we are saying half will be processed in the MFU. we will use 2:1 muxes
    precision = 8
    bram_data_width = 32 #Forcefully using 32 here for easy data layout
    elems_in_each_ram = int(bram_data_width / precision)
    num_inp_rams = int(num_inputs / elems_in_each_ram)
    num_ram_outs = int(num_outputs / elems_in_each_ram)
%>

//This is a poor man's assymetric FIFO.
//We don't handle read and write pointers.
//Address is incremented for every write and every read
module asymmetric_fifo(
  input clk,
  input reset,
  input [`OUT_DWIDTH*${num_inputs}-1:0] in,
  input [`OUT_DWIDTH*${num_outputs}-1:0] out,
  input write_en,
  input read_en
);


% for iter in range(num_inputs):
  wire [`OUT_DWIDTH-1:0] in${iter};
  assign in${iter} = in[`OUT_DWIDTH*${iter+1}-1 : `OUT_DWIDTH*${iter}];
% endfor

reg select;

//Read address increments every alternate cycle.
//This is because we read one element from one RAM and then another element
//of the second RAM at the same address in the next cycle.
//The select signal toggles every cycle.
reg [`OUT_BRAM_AWIDTH-1:0] read_addr;
always @(posedge clk) begin
  if (reset) begin
    read_addr <= 0;
  end
  else if (select & read_en) begin
    read_addr <= read_addr + 1;
  end
end


//Write address increments each cycle.
//Each cycle we get data for all RAms from the MVU.
reg [`OUT_BRAM_AWIDTH-1:0] write_addr;
always @(posedge clk) begin
  if (reset) begin
    write_addr <= 0;
  end
  else if (write_en) begin
    write_addr <= write_addr + 1;
  end
end

% for iter in range(num_inp_rams):

wire [`OUT_BRAM_DWIDTH-1:0] in_ram${iter};
wire [`OUT_BRAM_DWIDTH-1:0] out_ram${iter};

//Instantiate simple dual port RAMs
simple_dual_port #(.address_width(`OUT_BRAM_AWIDTH), .word_length(`OUT_BRAM_DWIDTH)) u_sdp_${iter}(
  .write_address(write_addr),
  .read_address(read_addr),
  .write_data(in_ram${iter}),
  .wr_en(write_en),
  .read_data(out_ram${iter}),
  .clk(clk)
);

% endfor

//Multiple inputs go into 1 RAM
% for iter_ram in range(num_inp_rams):
  assign in_ram${iter_ram} = {
% for iter in range(elems_in_each_ram):
  % if (iter==(elems_in_each_ram-1)):
  in${iter+iter_ram*elems_in_each_ram} };
  % else:
  in${iter+iter_ram*elems_in_each_ram},
  % endif
% endfor
% endfor


//Add muxing structure


//just toggle select every cycle
always @(posedge clk) begin
  if (reset) begin
    select <= 0;
  end
  else begin
    if (read_en) begin
      select <= ~select;
    end
  end
end

wire [${num_outputs}*`OUT_BRAM_DWIDTH-1:0] muxed_out_ram;

% for iter in range(num_ram_outs):

wire [`OUT_DWIDTH-1:0] muxed_out_ram${iter};
assign muxed_out_ram${iter} = select ? out_ram${2*iter} : out_ram${2*iter+1};
% endfor

assign muxed_out_ram = {
% for iter in reversed(range(num_ram_outs)):
  % if iter==0:
muxed_out_ram${iter}
  % else:
muxed_out_ram${iter},
  % endif
% endfor
};

assign out = muxed_out_ram;


endmodule

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
output reg [(word_length - 1):0] read_data; //output_data

`ifndef hard_mem
reg [(word_length - 1):0] simple_dual_port [((1<<address_width) - 1):0]; //memory


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
