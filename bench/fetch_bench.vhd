library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;

use work.instruction_field.all;

entity bench_fetch is
  
end bench_fetch;

architecture bench_arch of bench_fetch is

  component fetch
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      enable        : in  std_logic;
      pc_data       : in  std_logic_vector(31 downto 0);
      pc_wr         : in  std_logic;
      instruct_addr : out std_logic_vector(31 downto 0);
      fetch_ok      : out std_logic);
  end component;

  signal clk                : std_logic;
  signal reset              : std_logic;
  signal enable             : std_logic;
  signal pc_data            : std_logic_vector(31 downto 0);
  signal pc_wr              : std_logic := '0';
  signal instruct_addr      : std_logic_vector(31 downto 0);
  signal fetch_ok           : std_logic;

begin  -- bench_arch

  fetch_1: fetch
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      pc_data       => pc_data,
      pc_wr         => pc_wr,
      instruct_addr => instruct_addr,
      fetch_ok      => fetch_ok);

  reset <= '1', '0' after 10 ns;

  clock : process
    begin
      clk <= '0';
      wait for 5 ns;
      clk <= '1';
      wait for 5 ns;
    end process;

    process
      constant delay : time := 10 ns;
    begin  -- process
      wait for delay;
      wait for delay;
      wait for delay;
      enable <= '1';
      wait for delay;
      enable <= '0';
      wait for delay;
      pc_wr <= '1';
      pc_data <= X"00000040";
      wait for delay;
      pc_wr <= '0';
    end process;

end bench_arch;
