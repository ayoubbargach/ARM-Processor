library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;

use work.instruction_field.all;

entity arm_bench is

end entity arm_bench;

architecture behavioral of arm_bench is

  component instr_cache is
    port (
      clk            : in  std_logic;
      reset          : in  std_logic;
      cache_rd       : in  std_logic;
      cache_wr       : in  std_logic;
      instr_addr_rd  : in  std_logic_vector(31 downto 0);
      instr_data_in  : in  std_logic_vector(31 downto 0);
      instr_addr_wr  : in  std_logic_vector(31 downto 0);
      instr_data_out : out std_logic_vector(31 downto 0);
      cache_miss     : out std_logic);
  end component instr_cache;

  component arm is
    port (
      clk              : in  std_logic;
      enable           : in  std_logic;
      reset            : in  std_logic;
      instruction_in   : in  std_logic_vector(31 downto 0);
      mem_data_in      : in  std_logic_vector(31 downto 0);
      cache_miss       : in  std_logic;
      cache_rd         : out std_logic;
      instruction_addr : out std_logic_vector(31 downto 0);
      mem_addr_out     : out std_logic_vector(31 downto 0);
      mem_data_out     : out std_logic_vector(31 downto 0));
  end component arm;

  signal clk        : std_logic;
  signal reset      : std_logic;
  signal enable     : std_logic;
  signal cache_rd   : std_logic;
  signal cache_miss : std_logic;


  signal cache_wr       : std_logic;
  signal instr_addr_rd  : std_logic_vector(31 downto 0);
  signal instr_data_in  : std_logic_vector(31 downto 0);
  signal instr_addr_wr  : std_logic_vector(31 downto 0);
  signal instr_data_out : std_logic_vector(31 downto 0);

  signal mem_data_in  : std_logic_vector(31 downto 0);
  signal mem_addr_out : std_logic_vector(31 downto 0);
  signal mem_data_out : std_logic_vector(31 downto 0);


begin  -- architecture behavioral

  instr_cache_1 : instr_cache
    port map (
      clk            => clk,
      reset          => reset,
      cache_rd       => cache_rd,
      cache_wr       => cache_wr,
      instr_addr_rd  => instr_addr_rd,
      instr_data_in  => instr_data_in,
      instr_addr_wr  => instr_addr_wr,
      instr_data_out => instr_data_out,
      cache_miss     => cache_miss);

  arm_1 : arm
    port map (
      clk              => clk,
      enable           => enable,
      reset            => reset,
      instruction_in   => instr_data_out,
      cache_rd         => cache_rd,
      cache_miss       => cache_miss,
      mem_data_in      => mem_data_in,
      instruction_addr => instr_addr_rd,
      mem_addr_out     => mem_addr_out,
      mem_data_out     => mem_data_out);

  clock : process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end process;

  enable <= '0', '1' after 100 ns;
  reset  <= '1', '0' after 10 ns;

  -- ecriture du cache instruction
  process
  begin
    wait for 10 ns;
    cache_wr      <= '1';
    instr_data_in <= x"E" & "001" & "01000" & r0 & r8 & x"001";
    instr_addr_wr <= (others => '0');
    wait for 10 ns;
    instr_data_in <= x"E" & "001" & "01000" & r1 & r9 & x"001";
    instr_addr_wr <= x"00000004";
    wait for 10 ns;
    instr_data_in <= x"E" & "001" & op_SUB & '0' & r1 & r10 & x"001";
    instr_addr_wr <= x"00000008";
    wait for 10 ns;
    instr_data_in <= x"E" & "001" & op_SUB & '0' & r1 & r11 & x"001";
    instr_addr_wr <= x"0000000C";
    wait for 10 ns;
    instr_data_in <= x"E" & "001" & op_SUB & '0' & r1 & r12 & x"001";
    instr_addr_wr <= x"00000010";
    wait for 10 ns;
    instr_data_in <= x"E" & "000000" & "00" & r14 & r7 & r14 & "1001" & r8;
    instr_addr_wr <= x"00000014";
    wait for 10 ns;
    instr_data_in <= x"E" & "000000" & "10" & r6 & r8 & r8 & "1001" & r8;
    instr_addr_wr <= x"00000018";
    wait for 10 ns;
    cache_wr      <= '0';
    wait until reset = '1';
  end process;

  -- lecture de la sortie du writeback


end architecture behavioral;
