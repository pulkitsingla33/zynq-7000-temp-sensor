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

//Raise Reset Signal after every 1 second to trigger I2C Start
always @(posedge clk)
begin
    if((reset == 0) && (clock_counter == 20'd400000))
    begin
        reset <= 1;
        clock_counter <= 0;
    end
    else if((reset == 1) && (clock_counter == 20'd4))
    begin
        reset <= 0;
        clock_counter <= 0;
    end
    else
        clock_counter <= clock_counter + 1;
    
end
    

endmodule
