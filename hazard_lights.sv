// Finite state machine module that determines LED display pattern.
// wind: 2-bit value that encodes wind direction.
// 00: calm wind; 01: right to left wind; 10: left to right wind; 11: invalid input.
// reset: 1-bit value that resets the FSM back to its default state.
// clk: clock signal off which to run the FSM.
// lights: 3-bit signal that cycles through a set pattern based on the FSM state.
module hazard_lights (wind, reset, clk, lights);
	input logic [1:0]		wind;
	input logic 			reset, clk;
	output logic [2:0]	lights;
	
	// Defines the four states corresponding to four possible light configurations.
	enum {outer, center, left, right} ps, ns;
	
	// Defines the transitions to next states depending on the current input values.
	always_comb begin
		case (ps)
			outer:	ns = center;
			
			center:	if (wind == 0) 		ns = outer;
						else if (wind == 1)	ns = left;
						else						ns = right;
					
			left:		if ((wind == 0) | (wind == 2)) 
							ns = center;
						else
							ns = right;
					
			right:	if ((wind == 0) | (wind == 1))
							ns = center;
						else
							ns = left;
		endcase
	end
	
	// Sets the output logic to a value based on the present FSM state.
	always_comb begin
		case (ps)
			outer:	lights = 3'b101;
			center:	lights = 3'b010;
			left:		lights = 3'b100;
			right:	lights = 3'b001;
			default: lights = '0;
		endcase
	end
	
	// Sets up the flip-flops to allow the FSM to progress to the next state.
	always_ff @(posedge clk) begin
		if (reset)
			ps <= center; // defaults to 010 state when reset
		else
			ps <= ns;
	end

endmodule

// Testbench to simulate hazard lights output patterns. Cycles through all 3 patterns.
module hazard_lights_testbench();
	logic reset, clk;
	logic [1:0] wind;
	logic [2:0] lights;
	
	hazard_lights dut (.*);
	
	// Sets up simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
										@(posedge clk);
		reset <= 1; 				@(posedge clk); // reset FSM
		reset <= 0; wind <= 0;	@(posedge clk);
						repeat(3)	@(posedge clk); // cycle through calm wind pattern
						wind <= 1;	@(posedge clk);
						repeat(5)	@(posedge clk); // cycle through right to left pattern
						wind <= 2;	@(posedge clk);
						repeat(5)	@(posedge clk); // cycle through left to right pattern
		$stop;
	end

endmodule
