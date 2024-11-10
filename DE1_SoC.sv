// Lab 5 DE1_SoC module to be uploaded to FPGA.
// LEDs will flash in a set pattern corresponding to the input switches,
// of which different combinations represent different wind directions.

// CLOCK_50: 50 MHz clock signal of the DE1_SoC board.
// KEY: 4-bit value corresponding to states of 4 pushbuttons (active low input).
// SW: 10-bit value corresponding to states of 10 switches (active high input).
// SW[1:0]: switches used to control the state of the lights pattern.
// 00: calm wind; 01: right to left wind; 10: left to right wind; 11: invalid input.

// HEX0 through HEX5: 6 7-bit values corresponding to board 7-segment displays (active low).
// LEDR: 10-bit value corresponding to state of 10 board LEDs (active high).
// LEDR[2:0]: 3 LEDs that flash to display wind direction.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW); 
	input logic 			CLOCK_50; // 50MHz clock. 
	output logic [6:0]	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	output logic [9:0]	LEDR; 
	input logic [3:0] 	KEY; // True when not pressed, False when pressed 
	input logic [9:0] 	SW; 
	
	// Generate clk off of CLOCK_50, whichClock picks rate. 
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	
	assign LEDR[9:3] = '0;
	
	logic reset; 
	logic [31:0] div_clk; 
	assign reset = ~KEY[0]; 
	
	
	parameter whichClock = 22; // 6 Hz clock. whichClock determines clock speed. 
	clock_divider cdiv (.clock(CLOCK_50), 
								.reset(reset), 
								.divided_clocks(div_clk)); 
	// Clock selection; allows for easy switching between simulation and board clocks 
	logic clkSelect; 
	
	// Uncomment ONE of the following two lines depending on intention 
	
	//assign clkSelect = CLOCK_50; 				// for simulation 
	assign clkSelect = div_clk[whichClock];	// for board 
	
	// Assigns switches and lights as inputs and outputs of hazard lights FSM.
	hazard_lights h (.wind(SW[1:0]), .reset, .clk(clkSelect), .lights(LEDR[2:0])); 
	
	
endmodule

// Testbench to simulate DE1_SoC board. 
// Cycles through lights pattern corresponding to each possible input.
// Additionally tests transitions between each state to every other state.
module DE1_SoC_testbench();
	logic 		CLOCK_50;
	logic [6:0]	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0]	LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	// Set up a simulated clock. 
	parameter CLOCK_PERIOD=100; 
	initial begin 
		CLOCK_50 <= 0; 
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; 
	end 
	
	initial begin
												@(posedge CLOCK_50);
		KEY[0] <= 0; 						@(posedge CLOCK_50); // reset FSM
		KEY[0] <= 1;
						SW[1:0] <= 2'b00;	@(posedge CLOCK_50); // reset to calm transition
						repeat(3)			@(posedge CLOCK_50); // cycle through calm wind pattern
						
						SW[1:0] <= 2'b01;	@(posedge CLOCK_50); // calm to R-L transition
						repeat(5)			@(posedge CLOCK_50); // cycle through R-L pattern
						
						SW[1:0] <= 2'b10;	@(posedge CLOCK_50); // R-L to L-R transition
						repeat(5)			@(posedge CLOCK_50); // cycle through L-R pattern
						
						SW[1:0] <= 2'b00; @(posedge CLOCK_50); // L-R to calm transition
						repeat(3)			@(posedge CLOCK_50); // cycle through calm wind pattern
						
						SW[1:0] <= 2'b10; @(posedge CLOCK_50); // calm to L-R transition
						repeat(5)			@(posedge CLOCK_50); // cycle through L-R pattern
						
						SW[1:0] <= 2'b01; @(posedge CLOCK_50); // L-R to R-L transition
						repeat(5)			@(posedge CLOCK_50); // cycle through R-L
						
						SW[1:0] <= 2'b00; @(posedge CLOCK_50); // R-L to calm transition
						repeat(3)			@(posedge CLOCK_50); // cycle through calm
						
						SW[1:0] <= 2'b11; @(posedge CLOCK_50);
						repeat(3)			@(posedge CLOCK_50); // simulates case when both input switches 
																			// are pressed, an invalid input.
		$stop;
	end

endmodule
