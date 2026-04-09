`timescale 1ns / 1ps

module i2c_master(
input clk, reset,
output reg scl,
output reg current_bit,
output reg [7:0] msb_bits, lsb_bits,
output reg [5:0] current_state,
output reg [1:0] cycle_count,
inout sda
);

parameter [7:0] bus_address = 8'h96;
reg [7:0] register_pointer = 8'h00;

reg bit_direction;
reg scl_counter;
wire input_bit;

initial begin
    current_bit <= 1;    
    current_state <= 5'd0;
    bit_direction <= 0;
    scl <= 0;
    cycle_count <= 0;
    scl_counter <= 0;
    msb_bits <= 0;
    lsb_bits <= 0;
end

always @(posedge clk or posedge reset) begin
    if(reset == 1) begin
        current_bit <= 1;    
        current_state <= 5'd0;
        bit_direction <= 0;
        cycle_count <= 0;
        msb_bits <= 0;
        lsb_bits <= 0;
    end
    else begin

        if(current_state == 0) begin
            if(cycle_count == 2)    
                current_bit <= 0;
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if(current_state >= 1 && current_state <= 8)
        begin
            if(cycle_count == 0)           
                current_bit <= bus_address[8 - current_state];
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end

        else if(current_state == 9) begin
            if(cycle_count == 0) begin
                bit_direction <= 1;
                current_bit <= input_bit;
            end
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end

        else if(current_state >= 10 && current_state <= 17) begin
            if(cycle_count == 0)
            begin
                current_bit <= register_pointer[17 - current_state];
                bit_direction <= 0;
            end
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if(current_state == 18) begin
            if(cycle_count == 0) begin
                bit_direction <= 1;
                
            end
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if(current_state == 19) begin
            if(cycle_count == 0)
            begin
                bit_direction <= 0;
                current_bit <= 1'b1;
            end
            else if(cycle_count == 2)
                current_bit <= 0;
            else if(cycle_count == 3)
            begin
                current_state <= current_state + 1;
            end
        end
        
        else if ((current_state >= 20) && (current_state <= 27))
        begin
            if(cycle_count == 0)
            begin
                if(current_state == 27)
                    current_bit <= 1;
                else
                    current_bit <= bus_address[27 - current_state];
            end
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if(current_state == 28)
        begin
            if(cycle_count == 0)
                bit_direction <= 1;
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if((current_state>=29) && (current_state <=36))
        begin
            if(cycle_count == 2)
                msb_bits[36-current_state] <= sda;
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if(current_state == 37)
        begin
            if(cycle_count == 0)
            begin
                bit_direction <= 0;
                current_bit <= 0;
            end
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if((current_state>=38) && (current_state <=45))
        begin
            if(cycle_count == 0)
                bit_direction <= 1;
            else if(cycle_count == 2)
                lsb_bits[45 - current_state] <= sda;
           
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end

      else if(current_state == 46)
      begin
        if(cycle_count == 0)
        begin
            bit_direction <= 0;
            current_bit <= 1;
        end
        if(cycle_count == 3) 
            current_state <= current_state + 1;     
      end
      else if(current_state == 47)
      begin
        bit_direction <= 1;
      end
      cycle_count <= cycle_count + 1;
        
    end
end          

always @(posedge clk or posedge reset) begin
    if(reset == 1) begin
        scl_counter = 0;
        scl = 0;
    end
    else begin
        scl_counter <= scl_counter + 1;
        if(scl_counter == 1)
            scl <= ~scl;
     end   
end

assign sda = bit_direction ? 1'bz : current_bit;
assign input_bit = sda;
 
endmodule
