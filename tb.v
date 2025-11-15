`timescale 1ns/1ns
`include "main.v"

module tb;
	reg clk;
	reg reset;
	reg [2:0] S;
	wire pulse;
	wire led;

	top uut (clk, reset, S, pulse, led);

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
		#20000 S = 3'b110;
		#20000 S = 3'b101;
		#20000 S = 3'b100;
		#20000 S = 3'b011;
		#20000 S = 3'b010;
		#20000 S = 3'b001;
		#20000 S = 3'b000;
		#20000 S = 3'b1;
		$finish;
	end
endmodule
