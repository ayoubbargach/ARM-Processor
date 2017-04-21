###################################################################################
# Mentor Graphics Corporation
#
###################################################################################


##################
# Clocks
##################
create_clock { clk } -name clk -period 10.000000
create_clock { ix60025z52936|combout } -name decode_1/ix115/out -period 10.000000
create_clock { ix30383z52924|combout } -name memory_1/ix3/out -period 10.000000
create_generated_clock { decode_1_lat_instruction_5_|q } -name {decode_1_lat_instruction[5]/q} -multiply_by 1  -divide_by 2 -source decode_1/ix115/out -duty_cycle 50.00 
create_generated_clock { decode_1_lat_instruction_4_|q } -name {decode_1_lat_instruction[4]/q} -multiply_by 1  -divide_by 2 -source decode_1/ix115/out -duty_cycle 50.00 
create_generated_clock { decode_1_lat_instruction_3_|q } -name {decode_1_lat_instruction[3]/q} -multiply_by 1  -divide_by 2 -source decode_1/ix115/out -duty_cycle 50.00 
create_generated_clock { ix60025z52935|combout } -name ix60025z52935/combout -multiply_by 1  -divide_by 1 -source decode_1/ix115/out -duty_cycle 50.00 
set_false_path -from [get_clocks decode_1/ix115/out] -to [get_clocks decode_1_lat_instruction[5]/q]
set_false_path -from [get_clocks decode_1/ix115/out] -to [get_clocks decode_1_lat_instruction[4]/q]
set_false_path -from [get_clocks decode_1/ix115/out] -to [get_clocks decode_1_lat_instruction(3)|q]
set_false_path -from [get_clocks decode_1/ix115/out] -to [get_clocks memory_1/ix3/out]
set_false_path -from [get_clocks decode_1/ix115/out] -to [get_clocks clk]
set_false_path -from [get_clocks decode_1_lat_instruction[5]/q] -to [get_clocks decode_1/ix115/out]
set_false_path -from [get_clocks decode_1_lat_instruction[5]/q] -to [get_clocks decode_1_lat_instruction[4]/q]
set_false_path -from [get_clocks decode_1_lat_instruction[5]/q] -to [get_clocks decode_1_lat_instruction(3)|q]
set_false_path -from [get_clocks decode_1_lat_instruction[5]/q] -to [get_clocks memory_1/ix3/out]
set_false_path -from [get_clocks decode_1_lat_instruction[5]/q] -to [get_clocks ix60025z52935/combout]
set_false_path -from [get_clocks decode_1_lat_instruction[5]/q] -to [get_clocks clk]
set_false_path -from [get_clocks decode_1_lat_instruction[4]/q] -to [get_clocks decode_1/ix115/out]
set_false_path -from [get_clocks decode_1_lat_instruction[4]/q] -to [get_clocks decode_1_lat_instruction[5]/q]
set_false_path -from [get_clocks decode_1_lat_instruction[4]/q] -to [get_clocks decode_1_lat_instruction(3)|q]
set_false_path -from [get_clocks decode_1_lat_instruction[4]/q] -to [get_clocks memory_1/ix3/out]
set_false_path -from [get_clocks decode_1_lat_instruction[4]/q] -to [get_clocks ix60025z52935/combout]
set_false_path -from [get_clocks decode_1_lat_instruction[4]/q] -to [get_clocks clk]
set_false_path -from [get_clocks decode_1_lat_instruction(3)|q] -to [get_clocks decode_1/ix115/out]
set_false_path -from [get_clocks decode_1_lat_instruction(3)|q] -to [get_clocks decode_1_lat_instruction[5]/q]
set_false_path -from [get_clocks decode_1_lat_instruction(3)|q] -to [get_clocks decode_1_lat_instruction[4]/q]
set_false_path -from [get_clocks decode_1_lat_instruction(3)|q] -to [get_clocks memory_1/ix3/out]
set_false_path -from [get_clocks decode_1_lat_instruction(3)|q] -to [get_clocks ix60025z52935/combout]
set_false_path -from [get_clocks decode_1_lat_instruction(3)|q] -to [get_clocks clk]
set_false_path -from [get_clocks memory_1/ix3/out] -to [get_clocks decode_1/ix115/out]
set_false_path -from [get_clocks memory_1/ix3/out] -to [get_clocks decode_1_lat_instruction[5]/q]
set_false_path -from [get_clocks memory_1/ix3/out] -to [get_clocks decode_1_lat_instruction[4]/q]
set_false_path -from [get_clocks memory_1/ix3/out] -to [get_clocks decode_1_lat_instruction(3)|q]
set_false_path -from [get_clocks memory_1/ix3/out] -to [get_clocks ix60025z52935/combout]
set_false_path -from [get_clocks memory_1/ix3/out] -to [get_clocks clk]
set_false_path -from [get_clocks ix60025z52935/combout] -to [get_clocks decode_1_lat_instruction[5]/q]
set_false_path -from [get_clocks ix60025z52935/combout] -to [get_clocks decode_1_lat_instruction[4]/q]
set_false_path -from [get_clocks ix60025z52935/combout] -to [get_clocks decode_1_lat_instruction(3)|q]
set_false_path -from [get_clocks ix60025z52935/combout] -to [get_clocks memory_1/ix3/out]
set_false_path -from [get_clocks ix60025z52935/combout] -to [get_clocks clk]
set_false_path -from [get_clocks clk] -to [get_clocks decode_1/ix115/out]
set_false_path -from [get_clocks clk] -to [get_clocks decode_1_lat_instruction[5]/q]
set_false_path -from [get_clocks clk] -to [get_clocks decode_1_lat_instruction[4]/q]
set_false_path -from [get_clocks clk] -to [get_clocks decode_1_lat_instruction(3)|q]
set_false_path -from [get_clocks clk] -to [get_clocks memory_1/ix3/out]
set_false_path -from [get_clocks clk] -to [get_clocks ix60025z52935/combout]
