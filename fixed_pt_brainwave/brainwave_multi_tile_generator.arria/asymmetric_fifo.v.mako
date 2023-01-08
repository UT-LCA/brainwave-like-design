<%!
    import math

    num_tiles = 1 #CHANGE THIS
    num_ldpes = 8 #
    assert(num_ldpes%4==0), "Currently only supporting multiples of 4 here"
    num_dsp_per_ldpe = 8 #CHANGE THIS
    num_reduction_stages = int(math.log2(num_tiles))
    num_inputs = num_ldpes #every cycle we generate `num_ldpes` worth of items from the MVU
    assert(num_inputs%2==0),"Currently only supporting even number of outputs from the MVU"
    num_outputs = int(num_ldpes/2) #we are saying half will be processed in the MFU. we will use 2:1 muxes
    precision = 8
    bram_data_width_used = 32 #Forcefully using 32 here for easy data layout
    elems_in_each_ram = int(bram_data_width_used / precision)
    num_inp_rams = int(num_inputs / elems_in_each_ram)
    num_ram_outs = int(num_outputs / elems_in_each_ram)
    fifo_ram_addr_width = 9
    fifo_ram_data_width = 40
%>

//This is a poor man's assymetric FIFO.
//We don't handle read and write pointers.
//Address is incremented for every write and every read
module asymmetric_fifo(
  input clk,
  input reset,
  input [`OUT_DWIDTH*${num_inputs}-1:0] in,
  output [`OUT_DWIDTH*${num_outputs}-1:0] out,
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
reg [${fifo_ram_addr_width}-1:0] read_addr;
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
reg [${fifo_ram_addr_width}-1:0] write_addr;
always @(posedge clk) begin
  if (reset) begin
    write_addr <= 0;
  end
  else if (write_en) begin
    write_addr <= write_addr + 1;
  end
end

% for iter in range(num_inp_rams):

wire [${fifo_ram_data_width}-1:0] in_ram${iter};
wire [${fifo_ram_data_width}-1:0] out_ram${iter};

//Instantiate simple dual port RAMs
simple_dual_port #(.address_width(${fifo_ram_addr_width}), .word_length(${fifo_ram_data_width})) u_sdp_${iter}(
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

wire [${num_outputs}*`OUT_DWIDTH-1:0] muxed_out_ram;

% for iter in range(num_ram_outs):

wire [${fifo_ram_data_width}-1:0] muxed_out_ram${iter};
assign muxed_out_ram${iter} = select ? out_ram${2*iter} : out_ram${2*iter+1};
% endfor

assign muxed_out_ram = {
% for iter in reversed(range(num_ram_outs)):
  % if iter==0:
muxed_out_ram${iter}[${bram_data_width_used}-1:0]
  % else:
muxed_out_ram${iter}[${bram_data_width_used}-1:0],
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
