module top (
	input clk, reset,
	input [2:0] S,
	output pulse
);
	wire force_reset;
	switch_handler sh1 (clk, S, force_reset);
	beat_generator bg1 (clk, force_reset || reset, S, pulse);
endmodule

module counter (
	input clk,
	input reset,
	output reg [27:0] out
);
	always @(posedge clk) begin
		if (reset) begin
			out <= 0;
		end else begin
			out <= out + 1;
		end
	end
endmodule

module switch_handler (
	input clk,
	input [2:0] S,
	output reg force_reset
);
	reg [2:0] prev;
	always @(posedge clk) begin
		if (prev == S) begin
			force_reset <= 0;
		end else begin
			force_reset <= 1;
		end
		prev <= S;
	end
endmodule

module beat_generator (
	input clk, reset,
	input [2:0] S,
	output pulse
);
	wire [27:0] out;
	reg count_reset;

	counter count1 (clk, count_reset || reset, out);

	reg [2:0] prev_S;

	always @(posedge clk) begin
		if (S == 3'b000 && out == 100 - 2) begin
			count_reset <= 1;
		end
		else if (S == 3'b001 && out == 66 - 2)  begin
			count_reset <= 1;
		end
		else if (S == 3'b010 && out == 50 - 2)  begin
			count_reset <= 1;
		end
		else if (S == 3'b011 && out == 40 - 2)  begin
			count_reset <= 1;
		end
		else if (S == 3'b100 && out == 30 - 2)  begin
			count_reset <= 1;
		end
		else if (S == 3'b101 && out == 20 - 2)  begin
			count_reset <= 1;
		end
		else if (S == 3'b110 && out == 12 - 2)  begin
			count_reset <= 1;
		end
		else if (S == 3'b111 && out == 6 - 2)   begin
			count_reset <= 1;
		end else if (count_reset == 1) begin
			count_reset <= 0;
		end else begin
			count_reset <= 0;
		end
	end

	assign pulse = (out == 0) ? 1 : 0;

endmodule
