module FSM (input clk, button, reset,
				output led1, led2, 
				output reg bf
				);


reg [2:0] state;	
reg [2:0] next_state;

reg [32:0] cnt;
reg [32:0] cnt1;
reg [7:0] state_cnt;

reg tf;

//reg bf;

localparam IDLE 			= 3'd0;
localparam LED_1_ON 		= 3'd1;
localparam LED_2_ON		= 3'd2;
localparam ALL_LED_OFF 	= 3'd3;	
reg [32:0] setpoint;

reg tsfl;
initial tsfl <= 1'b1;

assign led1 = (state == LED_1_ON) ? 1'b1 : 1'b0;
assign led2 = (state == LED_2_ON) ? 1'b1 : 1'b0;

always @* 	
		
		case (state)
			
			IDLE:
					
					if (bf == 1'b1) begin
						next_state <= LED_1_ON;
						setpoint <= 32'd100000000;
					end
					else begin
						next_state <= IDLE;
					end
					
			LED_1_ON:
			
					if (tf == 1'b1) begin
						next_state <= LED_2_ON;
						setpoint <= 32'd500000000;
					end
					else begin
						next_state <= LED_1_ON;
					end
			LED_2_ON:
			
					if (tf == 1'b1) begin
						next_state <= ALL_LED_OFF;
					end
					else if (!reset) begin
						next_state <= ALL_LED_OFF;
						setpoint <= 1'b0;
					end
					else begin
						next_state <= LED_2_ON;						
					end
					
			ALL_LED_OFF:
			
					if (tf == 1'b1) begin 
						next_state <= IDLE;
					end
					else begin
						next_state <= ALL_LED_OFF;
					end
			default:
					
						next_state <= IDLE;
		
		endcase
	


always @(posedge clk or negedge reset) begin //

	if(!reset) begin
		state <= IDLE;
	end
	
	else begin
		state <= next_state;
	end
end



always @(posedge clk) begin
	
	if (button == 1'b0) begin
		bf <= 1'b1;
		cnt <= 1'b0;
	end
	
	if (state == LED_1_ON || state == LED_2_ON || state == ALL_LED_OFF) begin
		tf <= 1'b0;
		cnt <= cnt + 1'b1;
	end
	
	if (cnt == setpoint) begin
		cnt <= 1'b0;
		tf <= 1'b1;
	end
	
			
	if (state == ALL_LED_OFF) begin
		bf <= 1'b0;
	end

	
	
end

				
				
endmodule
