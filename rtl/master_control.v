`timescale 1ns / 1ps

//I2C Master Controller Module
module master_controller(
    input clk,
    output reg reset
    );
    
reg [19:0] clock_counter;

initial
begin
    clock_counter <= 0;
    reset <= 0;
end

// Raise Reset Signal after every 1 second to trigger I2C Start
// The clock provided to this module is a 400 kHz clock derived from the main 100 MHz clock
// Clock division is done in the top module
always @(posedge clk)
begin
    if((reset == 0) && (clock_counter == 20'd400000))   // For a 400 kHz clock, 400,000 cycles correspond to 1 second (400,000 cycles per second / 400,000 cycles = 1 second)
    begin
        reset <= 1;
        clock_counter <= 0;
    end
    else if((reset == 1) && (clock_counter == 20'd4))   // Keep the reset signal high for a few cycles (e.g., 4 cycles) to ensure that the I2C master module properly registers the reset condition before de-asserting it
    begin
        reset <= 0;
        clock_counter <= 0;
    end
    else
        clock_counter <= clock_counter + 1;
    
end
    

endmodule
