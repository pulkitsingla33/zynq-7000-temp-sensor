`timescale 1ns / 1ps

//I2C Testbench
module i2c_master_tb;

reg clk;

top dut(.clk(clk));

initial
    clk = 0;

always   
    #5 clk = ~clk;
    
endmodule