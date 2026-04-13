`timescale 1ns / 1ps

module ssd1(
    input clk,
    input [11:0] display_value,  // Input value to display (instead of VIO)
    output reg [6:0] ssd,
    output reg ssdcat
);

    wire [3:0] digit;
    integer count = 0;
    reg ms_pulse = 0;
    wire [3:0] tens;
      wire [3:0] ones;
    `
    assign tens = display_value / 10;
    assign ones = display_value % 10;
    
    // Select which nibble to display based on ssdcat
    assign digit = ssdcat ? display_value[7:4] : display_value[3:0];

    // Seven-segment decoder
    always @(posedge clk)
        case (digit)
            0: ssd <= 7'b1111110;
            1: ssd <= 7'b0110000;
            2: ssd <= 7'b1101101;
            3: ssd <= 7'b1111001;
            4: ssd <= 7'b0110011;
            5: ssd <= 7'b1011011;
            6: ssd <= 7'b1011111;
            7: ssd <= 7'b1110000;
            8: ssd <= 7'b1111111;
            9: ssd <= 7'b1110011;
            10: ssd <= 7'b1110111;
            11: ssd <= 7'b0011111;
            12: ssd <= 7'b1001110;
            13: ssd <= 7'b0111101;
            14: ssd <= 7'b1001111;
            15: ssd <= 7'b1000111;
        endcase

    // Generate 1ms pulse for display multiplexing
    always @(posedge clk)
        if (count == 399) begin
            count <= 0;
            ms_pulse <= 1;
        end else begin
            count <= count + 1;
            ms_pulse <= 0;
        end

    // Toggle between displays every 1ms
    always @(posedge clk)
        if (ms_pulse) ssdcat <= ~ssdcat;

endmodule