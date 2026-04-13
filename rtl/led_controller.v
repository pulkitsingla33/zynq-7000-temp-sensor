`timescale 1ns / 1ps

/*
LED Controller Module
This module controls the state of the LEDs based on the changes in the temperature value read from the sensor.
When the temperature increases, one more LED glows, and when the temperature decreases, one more LED dims.
*/

module led_controller(
    input clk,
    output reg [7:0] led_bits,
    input [7:0] temp_val,
    input reset
);

reg [7:0] old_temp_val;

initial
begin
old_temp_val = temp_val;
led_bits = 0;
end

always @(posedge reset)
begin
    //If Temperature increases, glow one more LED
    if(temp_val > old_temp_val)
        led_bits = (led_bits << 1) | 1;
    //If Temperature decreases, dim one more LED
    else if (temp_val < old_temp_val)
        led_bits = (led_bits >> 1)&(8'h7F);
        
    old_temp_val = temp_val;
end

endmodule
