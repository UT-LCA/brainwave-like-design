`timescale 1ns / 1ps

module fp16_to_msfp8 (input [15:0] a , output [7:0] b);

reg [7:0]b_temp;

always @ (*) begin

if ( a [14: 0] == 15'b0 ) begin //signed zero
	b_temp [7] = a[15]; //sign bit
	b_temp [6:0] = 7'b0000000; //EXPONENT AND MANTISSA
end

else begin
 	
	b_temp [1:0] = a[9:8]; //MANTISSA
	b_temp [6:2] = a[14:10]; //EXPONENT NOTE- EXPONENT SIZE IS SAME IN BOTH
	b_temp [7] = a[15]; //SIGN
	end
end

assign b = b_temp;


endmodule