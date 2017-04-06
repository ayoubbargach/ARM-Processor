###################################################################################
# Mentor Graphics Corporation
#
###################################################################################

#################
# Attributes
#################
set_attribute -name PART -value "3S50ATQ144-5" -type string /work/fetch/behavioral -design gatelevel 


##################
# Clocks
##################
create_clock { clk } -domain ClockDomain0 -name clk -period 10.000000 -waveform { 0.000000 5.000000 } -design gatelevel 
