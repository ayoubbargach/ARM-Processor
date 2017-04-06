library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

use work.instruction_field.all;

entity memory is
  
  port (
    enable            : in  std_logic;
    clk               : in  std_logic;
    reset             : in  std_logic;
    data_in           : in  std_logic_vector(31 downto 0);
    mem_addr_data_out : out std_logic_vector(31 downto 0);
    mem_wr_data       : in  std_logic;
    mem_rd_data       : in  std_logic;
    mem_data_in       : in  std_logic_vector(31 downto 0));

end memory;

architecture rtl of memory is

begin  -- rtl

  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        
      end if;
    end if;
  end process;

end rtl;
