
`timescale 1ns / 1ps

module msfp8_to_fp16 (input [7:0] a , output [15:0] b);

reg [15:0]b_temp;
reg [1:0] j;
reg [1:0] k;
reg [1:0] k_temp;

always @ (*) begin

if ( a [6: 0] == 7'b0 ) begin //signed zero
	b_temp [15] = a[7]; //sign bit
	b_temp[14:0] = 15'b0;
end

else begin

	if ( a[6:2] == 5'b0 ) begin //denormalized (covert to normalized)
		
		for (j=0; j<=1; j=j+1) begin
			if (a[j] == 1'b1) begin 
			    k_temp = j;	
			end
		end
	k = 1 - k_temp;

	b_temp [9:0] = ( (a [1:0] << (k+1'b1)) & 2'b11 ) << 8; 
	//b_temp [14:10] =  5'd31 - 5'd31 - k; //PROBLEM - DISCUSS THIS ************ SHOULD BE +k
    b_temp [14:10] =  5'd31 - 5'd31 + k;
	b_temp [15] = a[7];
	end

	else if ( a[14:10] == 5'b11111 ) begin //Infinity/ NAN
	b_temp [9:0] = a [1:0] << 8;
	b_temp [14:10] = 5'b11111;
	b_temp [15] = a[7];
	end

	else begin //Normalized Number
	b_temp [9:0] = a [1:0] << 8;
	b_temp [14:10] =  5'd31 - 5'd31 + a[6:2];
	b_temp [15] = a[7];
	end
end
end

assign b = b_temp;


endmodule
