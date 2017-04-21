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
