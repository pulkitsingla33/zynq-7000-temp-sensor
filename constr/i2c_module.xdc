#Clock coonstraints for the I2C master module
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN Y9 [get_ports clk]
create_clock -period 10.000 [get_ports clk]

#Optional reset pin constraints (not used in the current design, but can be enabled if needed)
#set_property IOSTANDARD LVCMOS33 [get_ports reset]
#set_property PACKAGE_PIN R18 [get_ports reset]

#Constraints for the 7-segment display
set_property IOSTANDARD LVCMOS33 [get_ports {ssd[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ssd[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ssd[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ssd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ssd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ssd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ssd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports ssdcat]
set_property PACKAGE_PIN AB7 [get_ports {ssd[6]}]
set_property PACKAGE_PIN AB6 [get_ports {ssd[5]}]
set_property PACKAGE_PIN Y4 [get_ports {ssd[4]}]
set_property PACKAGE_PIN AA4 [get_ports {ssd[3]}]
set_property PACKAGE_PIN V7 [get_ports {ssd[2]}]
set_property PACKAGE_PIN W7 [get_ports {ssd[1]}]
set_property PACKAGE_PIN V5 [get_ports {ssd[0]}]
set_property PACKAGE_PIN V4 [get_ports ssdcat]

#Constraints for the I2C pins for PMOS TMP2 sensor
# Important to enable pull-up resistors on the SDA and SCL lines for proper I2C communication, as these lines are open-drain and require pull-ups to function correctly
set_property IOSTANDARD LVCMOS33 [get_ports pmod_tmp2_sda]
set_property IOSTANDARD LVCMOS33 [get_ports pmod_tmp2_scl]
set_property PACKAGE_PIN AA9 [get_ports pmod_tmp2_sda]
set_property PACKAGE_PIN Y10 [get_ports pmod_tmp2_scl]
set_property PULLUP true [get_ports pmod_tmp2_sda]  
set_property PULLUP true [get_ports pmod_tmp2_scl]
set_property SLEW SLOW [get_ports pmod_tmp2_sda]
set_property SLEW SLOW [get_ports pmod_tmp2_scl]
set_property DRIVE 8[get_ports pmod_tmp2_sda]
set_property DRIVE 8[get_ports pmod_tmp2_scl]

#Constraints for the LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN T22 [get_ports {led[7]}] 
set_property PACKAGE_PIN T21 [get_ports {led[6]}]
set_property PACKAGE_PIN U22 [get_ports {led[5]}]
set_property PACKAGE_PIN U21 [get_ports {led[4]}]
set_property PACKAGE_PIN V22 [get_ports {led[3]}]
set_property PACKAGE_PIN W22 [get_ports {led[2]}]
set_property PACKAGE_PIN U19 [get_ports {led[1]}]
set_property PACKAGE_PIN U14 [get_ports {led[0]}]

set_false_path -to [get_ports pmod_tmp2_sda]
set_false_path -to [get_ports pmod_tmp2_scl]
set_false_path -from [get_ports pmod_tmp2_sda]

#Constraints for the conversion mode switch (if used in the design to toggle between different display modes or functionalities)
set_property IOSTANDARD LVCMOS33 [get_ports conv_mode_switch]
set_property PACKAGE_PIN F22 [get_ports conv_mode_switch]
