`timescale 1ns / 1ps

module i2c_master(
input clk, reset,
output reg scl,
output reg current_bit,
output reg [7:0] msb_bits, lsb_bits,    // Registers to hold the received bits
output reg [5:0] current_state, // State variable to track the current state of the I2C communication
output reg [1:0] cycle_count,   // Counter to track the cycles within each state
inout sda
);

parameter [7:0] bus_address = 8'h96;    // I2C address of the slave device (7-bit address + R/W bit)
reg [7:0] register_pointer = 8'h00;

reg bit_direction;
reg scl_counter;
wire input_bit;


// Initialize the I2C master state and variables
initial
begin
    current_bit <= 1;    
    current_state <= 5'd0;
    bit_direction <= 0;
    scl <= 0;
    cycle_count <= 0;
    scl_counter <= 0;
    msb_bits <= 0;
    lsb_bits <= 0;
end

// Current State variable is used to track the current state of the I2C communication
// Cycle count variable is used to track the number of clock cycles within each state, which helps in timing the transitions and data sampling correctly

always @(posedge clk or posedge reset)
begin
    //Reset state of the I2C master
    if(reset == 1)
    begin
        current_bit <= 1;    
        current_state <= 5'd0;
        bit_direction <= 0;
        cycle_count <= 0;
        msb_bits <= 0;
        lsb_bits <= 0;
    end
    else
    begin
        if(current_state == 0)  // Start condition
        begin
            if(cycle_count == 2)    
                current_bit <= 0;
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if(current_state >= 1 && current_state <= 8)   // Sending the 7-bit address and R/W bit (Write operation)
        begin
            if(cycle_count == 0)           
                current_bit <= bus_address[8 - current_state];
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end

        else if(current_state == 9) // ACK bit from slave
        begin
            if(cycle_count == 0)
            begin
                bit_direction <= 1;
                current_bit <= input_bit;
            end
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end

        else if(current_state >= 10 && current_state <= 17) // Sending the 8-bit register pointer
        begin
            if(cycle_count == 0)
            begin
                current_bit <= register_pointer[17 - current_state];
                bit_direction <= 0;
            end
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if(current_state == 18)    // ACK bit from slave after sending register pointer
        begin
            if(cycle_count == 0)
            begin
                bit_direction <= 1;
                
            end
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if(current_state == 19) // Repeated Start or Stop condition
        begin
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
        
        else if ((current_state >= 20) && (current_state <= 27)) // Sending the 7-bit address and R/W bit (Read operation)
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
        
        else if(current_state == 28)    // ACK bit from slave after sending address for read operation
        begin
            if(cycle_count == 0)
                bit_direction <= 1;
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if((current_state>=29) && (current_state <=36))    // Reading the 8 bits of data from the slave device (MSB)
        begin
            if(cycle_count == 2)
                msb_bits[36-current_state] <= sda;
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if(current_state == 37)    // Sending ACK bit to slave after reading the first byte
        begin
            if(cycle_count == 0)
            begin
                bit_direction <= 0;
                current_bit <= 0;
            end
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end
        
        else if((current_state>=38) && (current_state <=45)) // Reading the 8 bits of data from the slave device (LSB)
        begin
            if(cycle_count == 0)
                bit_direction <= 1;
            else if(cycle_count == 2)
                lsb_bits[45 - current_state] <= sda;
           
            else if(cycle_count == 3)
                current_state <= current_state + 1;
        end

      else if(current_state == 46)  // Sending NACK bit to slave after reading the second byte and preparing for stop condition
      begin
        if(cycle_count == 0)
        begin
            bit_direction <= 0;
            current_bit <= 1;
        end
        if(cycle_count == 3) 
            current_state <= current_state + 1;     
      end

      else if(current_state == 47)  // Stop condition
      begin
        bit_direction <= 1;
      end

      cycle_count <= cycle_count + 1;
    end
end          

always @(posedge clk or posedge reset)
begin
    if(reset == 1)
    begin
        scl_counter = 0;
        scl = 0;
    end
    else
    begin
        scl_counter <= scl_counter + 1;
        if(scl_counter == 1)    // Toggle SCL every 2 clock cycles to create the I2C clock signal
            scl <= ~scl;        // SCL frequency = clk frequency / 4
    end   
end

assign sda = bit_direction ? 1'bz : current_bit;  // Tri-state control for SDA line: If bit_direction is 1, SDA is high-impedance (input mode), otherwise it drives the current_bit value (output mode)
assign input_bit = sda;
 
endmodule
