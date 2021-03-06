library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;

use work.instruction_field.all;

entity barrel_bench is

end barrel_bench;

architecture barrel_arch of barrel_bench is
  
  component barrelshifter
    port (
      data_in             : in  std_logic_vector(31 downto 0);
      shift_amt           : in  std_logic_vector(4 downto 0);
      shift_type          : in  std_logic_vector(1 downto 0);
      shift_from_data_reg : in  std_logic;
      leastByte_rC_data   : in  std_logic_vector(7 downto 0);
      data_out            : out std_logic_vector(31 downto 0));
  end component;

  signal data_in             : std_logic_vector(31 downto 0);
  signal shift_amt           : std_logic_vector(4 downto 0);
  signal shift_type          : std_logic_vector(1 downto 0);
  signal shift_from_data_reg : std_logic;
  signal leastByte_rC_data   : std_logic_vector(7 downto 0);
  signal data_out            : std_logic_vector(31 downto 0);

  
begin

  barrelshifter_1 : barrelshifter
    port map (
      data_in             => data_in,
      shift_amt           => shift_amt,
      shift_type          => shift_type,
      shift_from_data_reg => shift_from_data_reg,
      leastByte_rC_data   => leastByte_rC_data,
      data_out            => data_out);


  process
    constant delay : time := 10 ns;
  begin  -- process;
    data_in             <= x"00000032";      -- 50
    shift_type          <= "10";        -- ASR
    shift_amt           <= (others => '0');  -- 0
    shift_from_data_reg <= '0';
    wait for delay;
    assert signed(data_out) = 50 report "bad result, expected 50" severity note;
    data_in             <= x"fffffff6";      -- -10
    shift_type          <= "10";        -- ASR
    shift_amt           <= "00010";          -- 2
    shift_from_data_reg <= '0';
    wait for delay;
    assert signed(data_out) = -3 report "bad result, expected -3" severity note;
    data_in             <= x"00000064";      -- 100
    shift_type          <= "00";        -- LSL
    shift_amt           <= "01001";          -- 9
    shift_from_data_reg <= '0';
    wait for delay;
    assert signed(data_out) = 51200 report "bad result, expected 51200" severity note;
    data_in             <= x"00000400";      -- 1024
    shift_type          <= "11";        -- ROR
    shift_amt           <= "01001";          -- 9
    shift_from_data_reg <= '0';
    wait for delay;
    assert signed(data_out) = 2 report "bad result, expected 2" severity note;
        data_in             <= x"00000400";      -- 1024
    shift_type          <= "11";        -- ROR
    shift_amt           <= "01011";          -- 11
    shift_from_data_reg <= '0';
    wait for delay;
    assert data_out = x"80000000" report "bad result, expected 2147483648" severity note; 
    
  end process;

  
  
end barrel_arch;
