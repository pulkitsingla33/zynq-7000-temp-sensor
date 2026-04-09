`timescale 1ns / 1ps

//Top Module
module top(
    input  wire clk,                       
    inout  wire pmod_tmp2_sda,   
    output wire pmod_tmp2_scl,               
    output wire [6:0]ssd,  
    output wire ssdcat,
    output wire [7:0] led ,
    input conv_mode_switch  
);

    wire [7:0] msb_bits;
    wire [7:0] lsb_bits;
    wire scl_internal;
    wire [4:0] i2c_state;
    wire [1:0] cycle_count;
    reg div_clk;
    reg [9:0] delay_counter;
    wire reset;
        
    initial
    begin
        delay_counter = 0;
        div_clk = 0;
    end    
    
    //Divide Clock from 100 MHz to 400 kHz
    always @(posedge clk)
    begin
        if(delay_counter == 10'd124)
     begin
        delay_counter <= 0;
        div_clk <= ~div_clk;
     end
    else
        delay_counter<=delay_counter +1;
    end
   
   wire [7:0] raw_data = {msb_bits, lsb_bits[7]};
   
   //Temperature to Celsius Conversion
   wire [7:0] temp_data = conv_mode_switch?(raw_data):((raw_data * 9/5) + 32);
   
   //I2C Master Instance
    i2c_master i2c_inst (
        .clk(div_clk),
        .reset(reset),
        .scl(scl_internal),
        .current_bit(),           
        .msb_bits(msb_bits),
        .lsb_bits(lsb_bits),
        .current_state(i2c_state),
        .cycle_count(cycle_count),
        .sda(pmod_tmp2_sda)
    );

    assign pmod_tmp2_scl = scl_internal;    //SCL signal to I2C Slave
    
    //SSD Instance
    ssd1 ssd_inst (
        .clk(div_clk),
        .display_value(temp_data),
        .ssd(ssd),
        .ssdcat(ssdcat)
    );
    
    //Led Controller Instance
    led_controller led_control (.clk(div_clk), .led_bits(led), .temp_val(temp_data), .reset(reset));
    
    //I2C Master Controller instance
    master_controller control(.clk(div_clk), .reset(reset));

endmodule
