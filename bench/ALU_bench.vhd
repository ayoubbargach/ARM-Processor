library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;

use work.instruction_field.all;

entity bench_ALU is
  
end bench_ALU;

architecture bench_arch of bench_ALU is 

  component ALU
    port (
      op_code   : in  std_logic_vector(3 downto 0);
      cond      : in  std_logic_vector(3 downto 0);
      data_in1  : in  std_logic_vector(31 downto 0);
      data_in2  : in  std_logic_vector(31 downto 0);
      cond_true : in  std_logic;
      result    : out std_logic_vector(31 downto 0));
  end component;

  signal op_code   : std_logic_vector(3 downto 0);
  signal cond      : std_logic_vector(3 downto 0);
  signal data_in1  : std_logic_vector(31 downto 0);
  signal data_in2  : std_logic_vector(31 downto 0);
  signal cond_true : std_logic;
  signal result    : std_logic_vector(31 downto 0);

begin  -- bench_arch

  ALU_1: ALU
    port map (
      op_code   => op_code,
      cond      => cond,
      data_in1  => data_in1,
      data_in2  => data_in2,
      cond_true => cond_true,
      result    => result);
  
    process
      constant delay : time := 10 ns;
    begin  -- process
      op_code <= op_ADD;
      data_in1 <= X"00000001";
      data_in2 <= X"00000010";
      wait for delay;
      assert unsigned(result) = 17 report "mauvais resultat de l'addition" severity note;
      op_code <= op_AND;
      data_in1 <= X"10101001";
      data_in2 <= X"01001011";
      wait for delay;
      assert unsigned(result) = 16#00001001# report "mauvais resultat du AND" severity note;
    end process;
  
end bench_arch;
