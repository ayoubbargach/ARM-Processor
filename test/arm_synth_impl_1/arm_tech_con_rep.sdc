###################################################################################
# Mentor Graphics Corporation
#
###################################################################################

#################
# Attributes
#################
set_attribute -name INFF -value "FALSE" -port -type string clk -design gatelevel 

##################
# Clocks
##################
create_clock { clk } -domain ClockDomain0 -name clk -period 10.000000 -waveform { 0.000000 5.000000 } -design gatelevel 
create_clock { ix60025z52936/combout } -domain ClockDomain1 -name decode_1/ix115/out -period 10.000000 -waveform { 0.000000 5.000000 } -design gatelevel 
create_clock { ix30383z52924/combout } -domain ClockDomain11 -name memory_1/ix3/out -period 10.000000 -waveform { 0.000000 5.000000 } -design gatelevel 
create_generated_clock { decode_1_lat_instruction(5)/q } -name decode_1_lat_instruction(5)/q -multiply_by 1  -divide_by 2 -source decode_1/ix115/out -duty_cycle 50.00 
create_generated_clock { decode_1_lat_instruction(4)/q } -name decode_1_lat_instruction(4)/q -multiply_by 1  -divide_by 2 -source decode_1/ix115/out -duty_cycle 50.00 
create_generated_clock { decode_1_lat_instruction(3)/q } -name decode_1_lat_instruction(3)/q -multiply_by 1  -divide_by 2 -source decode_1/ix115/out -duty_cycle 50.00 
create_generated_clock { ix60025z52935/combout } -name ix60025z52935/combout -multiply_by 1  -divide_by 1 -source decode_1/ix115/out -duty_cycle 50.00 
