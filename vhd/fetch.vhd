library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity fetch is
  
  port (
    clk     : in std_logic;
    reset   : in std_logic;
    enable  : in std_logic;
    pc_data : in std_logic_vector(31 downto 0);
    pc_wr   : in std_logic;
    instruct_addr : out  std_logic_vector(31 downto 0);
    fetch_ok : out std_logic);

end fetch;

architecture behavioral of fetch is

  signal current_pc : unsigned(31 downto 0);
  signal pc : unsigned(31 downto 0);

begin  -- behavioral

  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      current_pc <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        current_pc <= pc;
        fetch_ok <= '1';
      else
        fetch_ok <= '0';
      end if;
    end if;
  end process;

  process (current_pc)
  begin  -- process
      pc <= current_pc + 4;
  end process;

  instruct_addr <= std_logic_vector(current_pc) when pc_wr = '0' else pc_data;

end behavioral;
