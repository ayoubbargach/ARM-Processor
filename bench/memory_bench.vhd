library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;

use work.instruction_field.all;

entity mem_bench is

end entity mem_bench;

architecture behavioral of mem_bench is

  component memory is
    port (
      enable           : in  std_logic;
      clk              : in  std_logic;
      reset            : in  std_logic;
      ldr_str          : in  std_logic;
      data_in          : in  std_logic_vector(31 downto 0);
      rD_addr          : in  std_logic_vector(3 downto 0);
      ldr_str_base_reg : in  std_logic_vector(3 downto 0);
      rC_data          : in  std_logic_vector(31 downto 0);
      ldr_str_logic    : in  std_logic_vector(4 downto 0);
      mem_addr_out     : out std_logic_vector(31 downto 0);
      data_out         : out std_logic_vector(31 downto 0);
      dest_reg         : out std_logic_vector(3 downto 0);
      mem_wr           : out std_logic;
      mem_rd           : out std_logic;
      mem_data_in      : in  std_logic_vector(31 downto 0);
      mem_data_out     : out std_logic_vector(31 downto 0);
      reg_wr           : out std_logic;
      mem_ok           : out std_logic);
  end component memory;

  signal enable           : std_logic;
  signal clk              : std_logic;
  signal reset            : std_logic;
  signal ldr_str          : std_logic;
  signal data_in          : std_logic_vector(31 downto 0);
  signal rD_addr          : std_logic_vector(3 downto 0);
  signal ldr_str_base_reg : std_logic_vector(3 downto 0);
  signal rC_data          : std_logic_vector(31 downto 0);
  signal ldr_str_logic    : std_logic_vector(4 downto 0);
  signal mem_addr_out     : std_logic_vector(31 downto 0);
  signal data_out         : std_logic_vector(31 downto 0);
  signal dest_reg         : std_logic_vector(3 downto 0);
  signal mem_wr           : std_logic;
  signal mem_rd           : std_logic;
  signal mem_data_in      : std_logic_vector(31 downto 0);
  signal mem_data_out     : std_logic_vector(31 downto 0);
  signal reg_wr           : std_logic;
  signal mem_ok           : std_logic;

begin  -- architecture behavioral

  memory_1 : memory
    port map (
      enable           => enable,
      clk              => clk,
      reset            => reset,
      ldr_str          => ldr_str,
      data_in          => data_in,
      rD_addr          => rD_addr,
      ldr_str_base_reg => ldr_str_base_reg,
      rC_data          => rC_data,
      ldr_str_logic    => ldr_str_logic,
      mem_addr_out     => mem_addr_out,
      data_out         => data_out,
      dest_reg         => dest_reg,
      mem_wr           => mem_wr,
      mem_rd           => mem_rd,
      mem_data_in      => mem_data_in,
      mem_data_out     => mem_data_out,
      reg_wr           => reg_wr,
      mem_ok           => mem_ok);

  clock : process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end process;

  enable <= '0', '1' after 40 ns;
  reset  <= '1', '0' after 10 ns;

  rD_addr  <= "1110";
  ldr_str  <= '0';
  data_in  <= x"00000010";

end architecture behavioral;
