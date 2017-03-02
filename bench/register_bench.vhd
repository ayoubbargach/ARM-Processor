library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;

use work.instruction_field.all;

entity bench_register is
  
end bench_register;

architecture bench_arch of bench_register is 

  component registers
    port (
      clk          : in  std_logic;
      reset        : in  std_logic;
      enable       : in  std_logic;
      write_enable : in  std_logic;
      rA_addr      : in  std_logic_vector(4 downto 0);
      rB_addr      : in  std_logic_vector(4 downto 0);
      rC_addr      : in  std_logic_vector(4 downto 0);
      rA_data_out  : out std_logic_vector(31 downto 0);
      rB_data_out  : out std_logic_vector(31 downto 0);
      rC_data_in   : in  std_logic_vector(31 downto 0));
  end component;

  signal clk          : std_logic;
  signal reset        : std_logic;
  signal enable       : std_logic;
  signal write_enable : std_logic;
  signal rA_addr      : std_logic_vector(4 downto 0);
  signal rB_addr      : std_logic_vector(4 downto 0);
  signal rC_addr      : std_logic_vector(4 downto 0);
  signal rA_data_out  : std_logic_vector(31 downto 0);
  signal rB_data_out  : std_logic_vector(31 downto 0);
  signal rC_data_in   : std_logic_vector(31 downto 0);

begin  -- bench_arch

  registers_1: registers
    port map (
      clk          => clk,
      reset        => reset,
      enable       => enable,
      write_enable => write_enable,
      rA_addr      => rA_addr,
      rB_addr      => rB_addr,
      rC_addr      => rC_addr,
      rA_data_out  => rA_data_out,
      rB_data_out  => rB_data_out,
      rC_data_in   => rC_data_in);

  reset <= '1', '0' after 10 ns;

  clock : process(clk)
    begin
      clk <= '0';
      wait for 5 ns;
      clk <= '1';
      wait for 5 ns;
    end process;

    process (enable, write_enable, rA_addr, rB_addr, rC_addr, rC_data_in)
      constant delay : time := 10 ns;
    begin  -- process
      rA_addr <= '0' & r1;
      rB_addr <= '0' & r2;
      rC_addr <= '0' & r3;
      enable <= '1';
      wait for delay;
      assert rA_data_out = 16#00000000# report "mauvaise lecture du 1er registre source" severity note;
      assert rB_data_out = 16#00000000# report "mauvaise lecture du 2e registre source" severity note;
      rC_data_in <= std_logic_vector(to_unsigned(1852, 32));
      write_enable <= '1';
      wait for delay;
      rA_addr <= '0' & r3;
      assert unsigned(rA_data_out) = 1852 report "mauvaise ecriture" severity note;
    end process;
  
end bench_arch;
