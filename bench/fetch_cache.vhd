library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;

use work.instruction_field.all;

entity fetch_cache is

end entity fetch_cache;

architecture behavioral of fetch_cache is

  component fetch is
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      enable        : in  std_logic;
      pc_data       : in  std_logic_vector(31 downto 0);
      pc_wr         : in  std_logic;
      instruct_addr : out std_logic_vector(31 downto 0);
      cache_rd      : out std_logic;
      fetch_ok      : out std_logic);
  end component fetch;

  component instr_cache is
    port (
      clk            : in  std_logic;
      reset          : in  std_logic;
      cache_rd       : in  std_logic;
      cache_wr       : in  std_logic;
      instr_addr_rd  : in  std_logic_vector(31 downto 0);
      instr_data_in  : in  std_logic_vector(31 downto 0);
      instr_addr_wr  : in  std_logic_vector(31 downto 0);
      instr_data_out : out std_logic_vector(31 downto 0));
  end component instr_cache;

  signal clk      : std_logic;
  signal reset    : std_logic;
  signal enable   : std_logic;
  signal pc_data  : std_logic_vector(31 downto 0);
  signal pc_wr    : std_logic;
  signal cache_rd : std_logic;
  signal fetch_ok : std_logic;


  signal cache_wr       : std_logic;
  signal instr_addr_rd  : std_logic_vector(31 downto 0);
  signal instr_data_in  : std_logic_vector(31 downto 0);
  signal instr_addr_wr  : std_logic_vector(31 downto 0);
  signal instr_data_out : std_logic_vector(31 downto 0);


begin  -- architecture behavioral

  fetch_1 : fetch
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      pc_data       => pc_data,
      pc_wr         => pc_wr,
      instruct_addr => instr_addr_rd,
      cache_rd      => cache_rd,
      fetch_ok      => fetch_ok);

  instr_cache_1 : instr_cache
    port map (
      clk            => clk,
      reset          => reset,
      cache_rd       => cache_rd,
      cache_wr       => cache_wr,
      instr_addr_rd  => instr_addr_rd,
      instr_data_in  => instr_data_in,
      instr_addr_wr  => instr_addr_wr,
      instr_data_out => instr_data_out);

  clock : process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end process;

  reset <= '1', '0' after 10 ns;

  -- ecriture du cache instruction
  process
  begin
    wait for 10 ns;
    cache_wr      <= '1';
    instr_data_in <= x"E" & "001" & "01000" & r0 & r14 & x"001";
    instr_addr_wr <= (others => '0');
    wait for 10 ns;
    instr_data_in <= x"E" & "001" & "01000" & r1 & r14 & x"001";
    instr_addr_wr <= x"00000004";
    wait for 10 ns;
    instr_data_in <= x"E" & "001" & op_SUB & '0' & r1 & r14 & x"001";
    instr_addr_wr <= x"00000008";
    wait for 10 ns;
    cache_wr      <= '0';
    wait until reset = '1';
  end process;

  -- lecture du cache
  process
  begin
    wait for 40 ns;
    enable <= '1';
    assert instr_data_out = x"E" & "001" & "01000" & r0 & r14 & x"001" report "mauvaise instruction" severity warning;
    wait for 10 ns;
    assert instr_data_out = x"E" & "001" & "01000" & r1 & r14 & x"001" report "mauvaise instruction" severity warning;
    wait for 10 ns;
    assert instr_data_out = x"E" & "001" & op_SUB & '0' & r1 & r14 & x"001" report "mauvaise instruction" severity warning;
    wait for 10 ns;
    enable <= '0';
    wait until reset = '1';
  end process;


end architecture behavioral;
