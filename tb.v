`timescale 1ns/1ns
`include "main.v"

module tb;
	reg clk;
	reg reset;
	reg [2:0] S;
	wire pulse;

	top uut (clk, reset, S, pulse);

	initial begin
		clk = 0;
		forever begin
			#5 clk = ~clk;
		end
	end

	initial begin
		$dumpfile("output.vcd");
		$dumpvars(0, tb);
	end

	initial begin
		reset = 1;
		#23 reset = 0;
		S = 3'b111;
		#2000 S = 3'b110;
		#2000 S = 3'b101;
		#2000 S = 3'b100;
		#2000 S = 3'b011;
		#2000 S = 3'b010;
		#2000 S = 3'b001;
		#2000 S = 3'b000;
		#2000 S = 3'b1;
		$finish;
	end
endmodule
