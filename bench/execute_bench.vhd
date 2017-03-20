library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;

use work.instruction_field.all;

entity bench_execute is

end bench_execute;

architecture bench_arch of bench_execute is

  component execute
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
  end component;

  signal clk       : std_logic;
  signal enable    : std_logic;
  signal reset     : std_logic;
  signal immediate : std_logic;
  signal op_code   : std_logic_vector(3 downto 0);
  signal cond      : std_logic_vector(3 downto 0);
  signal operand2  : std_logic_vector(11 downto 0);
  signal rA_data   : std_logic_vector(31 downto 0);
  signal s_alu     : std_logic_vector(31 downto 0);

begin
    
  process
    constant delay : time := 10 ns;
  begin  -- process
    op_code   <= op_ADD;
    rA_data   <= X"00000001";
    data2_alu <= X"00000010";
    immediate <= '0';
    enable    <= '1';
    assert unsigned(s_alu) = 17 report "mauvais resultat de l'addition" severity note;
    wait for delay;
    enable    <= '0';
    wait for delay;
    op_code   <= op_AND;
    rA_data   <= X"10101001";
    data2_alu <= X"01001011";
    immediate <= '0';
    enable    <= '1';
    assert unsigned(s_alu) = 16#00001001# report "mauvais resultat du AND" severity note;
    wait for delay;
    enable    <= '0';
    wait for delay;
  end process;
  
end bench_arch;
