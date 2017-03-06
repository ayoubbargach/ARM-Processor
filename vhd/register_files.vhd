library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is
  
  port (
    clk          : in  std_logic;       -- clock
    reset        : in  std_logic;
    enable       : in  std_logic;
    write_enable : in  std_logic;
    rA_addr      : in  std_logic_vector(3 downto 0);
    rB_addr      : in  std_logic_vector(3 downto 0);
    rC_addr      : in  std_logic_vector(3 downto 0);
    rA_data_out  : out std_logic_vector(31 downto 0);
    rB_data_out  : out std_logic_vector(31 downto 0);
    rC_data_in   : in  std_logic_vector(31 downto 0));

end registers;

architecture behavioral of registers is
  type tab_register is array (0 to 15) of std_logic_vector(31 downto 0);
  signal regs : tab_register;

begin  -- behavioral

  
  -- purpose: ecriture/lecture des registres
  -- type   : sequential
  -- inputs : clk, reset
  -- outputs:
  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      regs <= (others => (others => '0'));
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        rA_data_out <= regs(to_integer(unsigned(rA_addr)));
        rB_data_out <= regs(to_integer(unsigned(rB_addr)));
      end if;
      if write_enable = '1' then
        regs(to_integer(unsigned(rC_addr))) <= rC_data_in;
      end if;
    end if;
  end process;

end behavioral;
