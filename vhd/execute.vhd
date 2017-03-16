library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity execute is
  
  port (
    clk      : in std_logic;
    enable   : in std_logic;
    reset    : in std_logic;
    op_code  : in std_logic_vector(3 downto 0);
    operand2 : in std_logic_vector(11 downto 0);
    rA_data  : in std_logic_vector(31 downto 0);
    op2_data : in std_logic_vector(31 downto 0);
    imm_data : in std_logic_vector(31 downto 0);
    s_alu    : out std_logic_vector(31 downto 0));

end execute;

architecture behavioral of execute is

signal result : unsigned(31 downto 0);
signal rA_data_u : unsigned(31 downto 0);
signal op2_data_u : unsigned(31 downto 0);
  
begin  -- behavioral

rA_data_u <= unsigned(rA_data);
op2_data_u <= unsigned(op2_data);

  with op_code select
    result <=
    rA_data_u and op2_data_u when op_AND,
    rA_data_u xor op2_data_u when op_EOR,
    rA_data_u - op2_data_u   when op_SUB,
    op2_data_u - rA_data_u   when op_RSB,
    rA_data_u + op2_data_u   when op_ADD,
    (others => 'X') when others;


  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      s_alu <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        s_alu <= std_logic_vector(result);
      end if;
    end if;
  end process;
  
end behavioral;
