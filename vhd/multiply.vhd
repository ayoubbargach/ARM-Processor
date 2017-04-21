library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity multiply is

  port (
    mul      : in  std_logic;
    data_inA : in  std_logic_vector(31 downto 0);
    data_inB : in  std_logic_vector(31 downto 0);
    mul_out  : out std_logic_vector(31 downto 0));

end entity multiply;

architecture rtl of multiply is

  signal mul_out_i : std_logic_vector(63 downto 0);

begin  -- architecture rtl

  process (mul, data_inA, data_inB) is
  begin  -- process
    if mul = '1' then
      mul_out_i <= std_logic_vector((signed(data_inA)*signed(data_inB)));
    end if;
  end process;

  mul_out <= mul_out_i(31 downto 0);

end architecture rtl;



