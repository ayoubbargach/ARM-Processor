library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity arm is
  
  port (
    clk   : in std_logic;
    reset : in std_logic);

end arm;


architecture rtl of arm is

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

  

  component registers
    port (
      clk          : in  std_logic;
      reset        : in  std_logic;
      enable       : in  std_logic;
      write_enable : in  std_logic;
      rA_addr      : in  std_logic_vector(3 downto 0);
      rB_addr      : in  std_logic_vector(3 downto 0);
      rC_addr      : in  std_logic_vector(3 downto 0);
      rA_data_out  : out std_logic_vector(31 downto 0);
      rB_data_out  : out std_logic_vector(31 downto 0);
      rC_data_in   : in  std_logic_vector(31 downto 0));
  end component;

  component decode
    port (
      clk            : in  std_logic;
      enable         : in  std_logic;
      reset          : in  std_logic;
      instruction_in : in  std_logic_vector(31 downto 0);
      op_code        : out std_logic_vector(3 downto 0);
      rd_registers   : out std_logic;
      immediate      : out std_logic;
      rA_addr        : out std_logic_vector(3 downto 0);
      rB_addr        : out std_logic_vector(3 downto 0);
      rC_addr        : out std_logic_vector(3 downto 0);
      imm_value      : out std_logic_vector(31 downto 0);
      dest_rD        : out std_logic_vector(3 downto 0);
      shift_amt      : out std_logic_vector(4 downto 0);
      shift_type     : out std_logic_vector(1 downto 0);
      shift_reg      : out std_logic);
  end component;

  component execute
    port (
      clk            : in  std_logic;
      enable         : in  std_logic;
      reset          : in  std_logic;
      immediate      : in  std_logic;
      op_code        : in  std_logic_vector(3 downto 0);
      cond           : in  std_logic_vector(3 downto 0);
      rD_addr        : in  std_logic_vector(3 downto 0);
      imm_value      : in  std_logic_vector(31 downto 0);
      shift_amt      : in  std_logic_vector(4 downto 0);
      shift_type     : in  std_logic_vector(1 downto 0);
      shift_from_reg : in  std_logic;
      rA_data        : in  std_logic_vector(31 downto 0);
      rB_data        : in  std_logic_vector(31 downto 0);
      rC_data        : in  std_logic_vector(31 downto 0);
      d_PC_4         : in  std_logic_vector(31 downto 0);
      PC_8           : out std_logic_vector(31 downto 0);
      dest_rD_addr   : out std_logic_vector(3 downto 0);
      exe_out        : out std_logic_vector(31 downto 0));
  end component;

  

begin  -- rtl

  fetch_1 : fetch
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      pc_data       => pc_data,
      pc_wr         => pc_wr,
      instruct_addr => instruct_addr,
      fetch_ok      => fetch_ok);

  registers_1 : registers
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

  decode_1 : decode
    port map (
      clk            => clk,
      enable         => enable,
      reset          => reset,
      instruction_in => instruction_in,
      op_code        => op_code,
      rd_registers   => rd_registers,
      immediate      => immediate,
      rA_addr        => rA_addr,
      rB_addr        => rB_addr,
      rC_addr        => rC_addr,
      imm_value      => imm_value,
      dest_rD        => dest_rD,
      shift_amt      => shift_amt,
      shift_type     => shift_type,
      shift_reg      => shift_reg);

  execute_1 : execute
    port map (
      clk            => clk,
      enable         => enable,
      reset          => reset,
      immediate      => immediate,
      op_code        => op_code,
      cond           => cond,
      rD_addr        => rD_addr,
      imm_value      => imm_value,
      shift_amt      => shift_amt,
      shift_type     => shift_type,
      shift_from_reg => shift_from_reg,
      rA_data        => rA_data,
      rB_data        => rB_data,
      rC_data        => rC_data,
      d_PC_4         => d_PC_4,
      PC_8           => PC_8,
      dest_rD_addr   => dest_rD_addr,
      exe_out        => exe_out);

end rtl;
