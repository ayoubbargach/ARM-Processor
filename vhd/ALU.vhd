library IEEE ;
use IEEE.std_logic_1164.ALL ;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity ALU is
  port (
    op_code   : in  std_logic_vector(3 downto 0);
    cond      : in  std_logic_vector(3 downto 0);
    data_inA  : in  std_logic_vector(31 downto 0);
    data_inB  : in  std_logic_vector(31 downto 0);
    cond_true : in  std_logic;
    result    : out std_logic_vector(31 downto 0));
		
end ALU;

architecture rtl of ALU is

signal data_in1_u : unsigned(31 downto 0);
signal data_in2_u : unsigned(31 downto 0);
signal result_u : unsigned(31 downto 0);
  
begin  -- rtl

data_in1_u <= unsigned(data_inA);
data_in2_u <= unsigned(data_inB);
  
  with op_code select
    result_u <=
    data_in1_u and data_in2_u when op_AND,
    data_in1_u xor data_in2_u when op_EOR,
    data_in1_u - data_in2_u   when op_SUB,
    data_in2_u - data_in1_u   when op_RSB,
    data_in1_u + data_in2_u   when op_ADD,
    (others => '-')       when others;

result <= std_logic_vector(result_u);

end rtl;

