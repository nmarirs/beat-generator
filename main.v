module top (
	input clk, reset,
	input [2:0] S,
	output pulse,
	output led
);
	wire force_reset;
	switch_handler 	sh1 (clk, S, force_reset);
	beat_generator 	bg1 (clk, force_reset || reset, S, pulse);
	led_driver		ld1 (pulse, reset, led);
endmodule

module led_driver (
	input clk,
	input reset,
	output reg led
);

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			led <= 0;
		end else begin
			led <= ~led;
		end
	end
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

// detects if the switches have changed
// if yes, force the beat generator to reset
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
	input  wire clk,
	input  wire reset,
	input  wire [2:0] S,
	output reg  pulse
);
	reg count_reset;
	wire [27:0] out;
	reg [9:0] threshold;

	counter count1 (clk, count_reset || reset, out);

	always @(*) begin
		case (S)
			3'b000: threshold = 100;
			3'b001: threshold = 66;
			3'b010: threshold = 50;
			3'b011: threshold = 40;
			3'b100: threshold = 30;
			3'b101: threshold = 20;
			3'b110: threshold = 12;
			3'b111: threshold = 6;
			default: threshold = 100;
		endcase
	end

	always @(posedge clk) begin
		if (reset) begin
			count_reset <= 1'b0;
			pulse <= 1'b0;
		end else begin
			if (out == threshold - 2) begin
				count_reset <= 1'b1;
				pulse <= 1'b1;
			end else begin
				count_reset <= 1'b0;
				pulse <= 1'b0;
			end
		end
	end
endmodule

module beat_generator2 (
	input clk, reset,
	input [2:0] S,
	output pulse
);
	wire [27:0] out;
	reg count_reset;

	counter count1 (clk, count_reset || reset, out);

	reg [2:0] prev_S;

	always @(posedge clk) begin
		// count_reset is high for one cycle before the beat
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
		end
	   else begin
			count_reset <= 0;
		end
	end

	// beat is generated for one pulse
	assign pulse = (out == 0) ? 1 : 0;

endmodule
