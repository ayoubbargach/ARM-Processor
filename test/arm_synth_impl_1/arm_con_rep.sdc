###################################################################################
# Mentor Graphics Corporation
#
###################################################################################

#################
# Attributes
#################
set_attribute -name ram_processed -value "true" -instance registers_1/regs/regs -design rtl 


##################
# Clocks
##################
create_clock { clk } -domain ClockDomain0 -name clk -period 10.000000 -waveform { 0.000000 5.000000 } -design rtl 
