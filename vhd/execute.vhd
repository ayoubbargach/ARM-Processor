library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity execute is
  
  port (
    clk       : in  std_logic;
    enable    : in  std_logic;
    reset     : in  std_logic;
    immediate : in  std_logic;
    op_code   : in  std_logic_vector(3 downto 0);
    cond      : in  std_logic_vector(3 downto 0);
    operand2  : in  std_logic_vector(11 downto 0);
    rA_data   : in  std_logic_vector(31 downto 0);
    s_alu     : out std_logic_vector(31 downto 0));

end execute;

architecture behavioral of execute is

  component ALU
    port (
      op_code   : in  std_logic_vector(3 downto 0);
      cond      : in  std_logic_vector(3 downto 0);
      data_in1  : in  std_logic_vector(31 downto 0);
      data_in2  : in  std_logic_vector(31 downto 0);
      cond_true : in  std_logic;
      result    : out std_logic_vector(31 downto 0));
  end component;

  signal cond_true : std_logic;
  signal result    : std_logic_vector(31 downto 0);
  signal data2_alu : std_logic_vector(31 downto 0);
  
begin  -- behavioral

  ALU_1 : ALU
    port map (
      op_code   => op_code,
      cond      => cond,
      data_in1  => rA_data,
      data_in2  => data2_alu,
      cond_true => cond_true,
      result    => result);



  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      s_alu <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        s_alu <= result;
      end if;
    end if;
  end process;
  
end behavioral;
