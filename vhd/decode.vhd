library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity decode is
  
  port (
    clk            : in  std_logic;
    enable         : in  std_logic;
    reset          : in  std_logic;
    instruction_in : in  std_logic_vector(31 downto 0);
    alu_op         : out std_logic_vector(3 downto 0);
    exe_enable     : out std_logic;
    rd_registers   : out std_logic;
    rA_select      : out std_logic_vector(3 downto 0);
    rB_select      : out std_logic_vector(3 downto 0);
    rC_select      : out std_logic_vector(3 downto 0);
    operand2       : out std_logic_vector(11 downto 0);
    imm_data       : out std_logic_vector(31 downto 0));

end decode;

-- see https://cs107e.github.io/readings/armisa.pdf for data processing instructions

architecture behavioral of decode is

begin  -- behavioral

  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      exe_enable <= '0';
      rd_registers <= '0';
      rA_select <= (others => 'X');
      rC_select <= (others => 'X');
      alu_op <= (others => 'X');
      operand2 <= (others => 'X');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        alu_op <= instruction_in(24 downto 21);  -- OpCode
        rA_select <= instruction_in(19 downto 16);  -- 1st operand register
        rC_select <= instruction_in(15 downto 12);  -- Destination register
        operand2 <= instruction_in(11 downto 0);
        exe_enable <= '1';
        rd_registers <= '1';
      end if;
    end if;
  end process;


end behavioral;
