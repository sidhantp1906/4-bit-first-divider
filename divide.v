`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:38:04 08/17/2021 
// Design Name: 
// Module Name:    divide 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module divide(
    input [7:0]dividend,
    input [3:0]divisor,
	 input clk,reset,
    output reg [7:0]remainder,
    output reg [3:0]quoteint
    );

reg [7:0]dvsr;
reg [2:0]cur_s,nex_s;
parameter s0 = 3'b000,s1 = 3'b001, s2 = 3'b010,s3 = 3'b011,done = 3'b100;

reg [3:0]N;

always @(posedge clk)
begin
if(!reset)
cur_s <= s0;
else
cur_s <= nex_s;
end

always @(cur_s or dvsr or dividend or divisor or N)
begin
case(cur_s)
s0:begin
	remainder = remainder-dvsr;
	nex_s = s1;
	end
s1:begin
	if(remainder[7] == 1)
	begin
	quoteint = {quoteint[2:0],1'b1};
	nex_s = s2;
	end
	else
	begin
	remainder = remainder + dvsr;
	quoteint = {quoteint[2:0],1'b0};
	nex_s = s2;
	end
	end
s2:begin
	dvsr = dvsr>>1;
	nex_s = s3;
	end
s3:begin
	if(N == 4'b0101)
	nex_s = done;
	else
	begin
	N = N + 4'b0001;
	nex_s = s0;
	end
	end
done:begin end
default:begin
			N = 4'b0000; 
			remainder = dividend;
			dvsr = {divisor,4'b0000};
			quoteint = 4'b0000;
			nex_s = s0;
			end
endcase
end

endmodule
