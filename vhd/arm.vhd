library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity arm is

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

end arm;


architecture rtl of arm is

  component fetch
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      enable        : in  std_logic;
      pc_data       : in  std_logic_vector(31 downto 0);
      pc_wr         : in  std_logic;
      cache_miss    : in  std_logic;
      instruct_addr : out std_logic_vector(31 downto 0);
      cache_rd      : out std_logic;
      pc_4          : out std_logic_vector(31 downto 0);
      fetch_ok      : out std_logic);
  end component;



  component registers
    port (
      clk         : in  std_logic;
      reset       : in  std_logic;
      rd_enable   : in  std_logic;
      wr_enable   : in  std_logic;
      rA_addr     : in  std_logic_vector(3 downto 0);
      rB_addr     : in  std_logic_vector(3 downto 0);
      rC_addr     : in  std_logic_vector(3 downto 0);
      rD_addr     : in  std_logic_vector(3 downto 0);
      rA_data_out : out std_logic_vector(31 downto 0);
      rB_data_out : out std_logic_vector(31 downto 0);
      rC_data_out : out std_logic_vector(31 downto 0);
      rD_data_in  : in  std_logic_vector(31 downto 0));
  end component;

  component decode is
    port (
      clk              : in  std_logic;
      enable           : in  std_logic;
      reset            : in  std_logic;
      instruction_in   : in  std_logic_vector(31 downto 0);
      pc_4             : in  std_logic_vector(31 downto 0);
      condition        : out std_logic_vector(3 downto 0);
      op_code          : out std_logic_vector(3 downto 0);
      rd_registers     : out std_logic;
      immediate        : out std_logic;
      rA_addr          : out std_logic_vector(3 downto 0);
      rB_addr          : out std_logic_vector(3 downto 0);
      rC_addr          : out std_logic_vector(3 downto 0);
      imm_value        : out std_logic_vector(31 downto 0);
      dest_rD          : out std_logic_vector(3 downto 0);
      shift_amt        : out std_logic_vector(4 downto 0);
      shift_type       : out std_logic_vector(1 downto 0);
      shift_reg        : out std_logic;
      exe_mul          : out std_logic;
      exe_BX           : out std_logic;
      exe_BBL          : out std_logic;
      bbl_offset       : out std_logic_vector(23 downto 0);
      decode_ok        : out std_logic;
      exe_ldr_str      : out std_logic;
      ldr_str_base_reg : out std_logic_vector(3 downto 0);
      ldr_str_logic    : out std_logic_vector(4 downto 0));
  end component decode;

  component execute is
    port (
      clk                  : in  std_logic;
      enable               : in  std_logic;
      reset                : in  std_logic;
      immediate            : in  std_logic;
      op_code              : in  std_logic_vector(3 downto 0);
      condition            : in  std_logic_vector(3 downto 0);
      rD_addr              : in  std_logic_vector(3 downto 0);
      imm_value            : in  std_logic_vector(31 downto 0);
      shift_amt            : in  std_logic_vector(4 downto 0);
      shift_type           : in  std_logic_vector(1 downto 0);
      shift_from_reg       : in  std_logic;
      rA_data              : in  std_logic_vector(31 downto 0);
      rB_data              : in  std_logic_vector(31 downto 0);
      rC_data              : in  std_logic_vector(31 downto 0);
      d_PC_4               : in  std_logic_vector(31 downto 0);
      exe_BX               : in  std_logic;
      exe_BBL              : in  std_logic;
      bbl_offset           : in  std_logic_vector(23 downto 0);
      exe_ldr_str          : in  std_logic;
      ldr_str_logic        : in  std_logic_vector(4 downto 0);
      exe_ldr_str_base_reg : in  std_logic_vector(3 downto 0);
      mul                  : in  std_logic;
      PC_8                 : out std_logic_vector(31 downto 0);
      dest_rD_addr         : out std_logic_vector(3 downto 0);
      exe_out              : out std_logic_vector(31 downto 0);
      exe_ok               : out std_logic;
      mem_ldr_str_logic    : out std_logic_vector(4 downto 0);
      mem_ldr_str          : out std_logic;
      mem_data_rC          : out std_logic_vector(31 downto 0);
      mem_ldr_str_base_reg : out std_logic_vector(3 downto 0));
  end component execute;

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

  component writeback is
    port (
      clk        : in  std_logic;
      enable     : in  std_logic;
      reset      : in  std_logic;
      data_in    : in  std_logic_vector(31 downto 0);
      reg_wr     : in  std_logic;
      rD_addr    : in  std_logic_vector(3 downto 0);
      reg_wr_out : out std_logic;
      dest_reg   : out std_logic_vector(3 downto 0);
      data_out   : out std_logic_vector(31 downto 0);
      PC_wr      : out std_logic);
  end component writeback;

  signal fetch_to_decode : std_logic;
  signal data_wb         : std_logic_vector(31 downto 0);
  signal pc_wr           : std_logic;

  signal reg_rd  : std_logic;
  signal reg_wr  : std_logic;
  signal rA_addr : std_logic_vector(3 downto 0);
  signal rB_addr : std_logic_vector(3 downto 0);
  signal rC_addr : std_logic_vector(3 downto 0);
  signal rD_addr : std_logic_vector(3 downto 0);

  signal rA_data : std_logic_vector(31 downto 0);
  signal rB_data : std_logic_vector(31 downto 0);
  signal rC_data : std_logic_vector(31 downto 0);
  signal rD_data : std_logic_vector(31 downto 0);

  signal pc_4             : std_logic_vector(31 downto 0);
  signal op_code          : std_logic_vector(3 downto 0);
  signal rd_registers     : std_logic;
  signal immediate        : std_logic;
  signal imm_value        : std_logic_vector(31 downto 0);
  signal dest_rD          : std_logic_vector(3 downto 0);
  signal shift_amt        : std_logic_vector(4 downto 0);
  signal shift_type       : std_logic_vector(1 downto 0);
  signal shift_reg        : std_logic;
  signal exe_mul          : std_logic;
  signal exe_BX           : std_logic;
  signal exe_BBL          : std_logic;
  signal bbl_offset       : std_logic_vector(23 downto 0);
  signal decode_ok        : std_logic;
  signal exe_ldr_str      : std_logic;
  signal ldr_str_base_reg : std_logic_vector(3 downto 0);
  signal ldr_str_logic    : std_logic_vector(4 downto 0);


  signal condition            : std_logic_vector(3 downto 0);
  signal d_PC_4               : std_logic_vector(31 downto 0);
  signal PC_8                 : std_logic_vector(31 downto 0);
  signal dest_rD_addr         : std_logic_vector(3 downto 0);
  signal exe_out              : std_logic_vector(31 downto 0);
  signal exe_ok               : std_logic;
  signal mem_ldr_str_logic    : std_logic_vector(4 downto 0);
  signal mem_ldr_str          : std_logic;
  signal mem_data_rC          : std_logic_vector(31 downto 0);
  signal mem_ldr_str_base_reg : std_logic_vector(3 downto 0);


  signal data_out_mem : std_logic_vector(31 downto 0);
  signal dest_reg     : std_logic_vector(3 downto 0);
  signal reg_wr_mem   : std_logic;
  signal mem_wr       : std_logic;
  signal mem_rd       : std_logic;
  signal mem_ok       : std_logic;

begin  -- rtl

  fetch_1 : fetch
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      pc_data       => data_wb,
      pc_wr         => pc_wr,
      cache_miss    => cache_miss,
      instruct_addr => instruction_addr,
      cache_rd      => cache_rd,
      pc_4          => pc_4,
      fetch_ok      => fetch_to_decode);

  registers_1 : registers
    port map (
      clk         => clk,
      reset       => reset,
      rd_enable   => reg_rd,
      wr_enable   => reg_wr,
      rA_addr     => rA_addr,
      rB_addr     => rB_addr,
      rC_addr     => rC_addr,
      rD_addr     => dest_reg,
      rA_data_out => rA_data,
      rB_data_out => rB_data,
      rC_data_out => rC_data,
      rD_data_in  => rD_data);

  decode_1 : decode
    port map (
      clk              => clk,
      enable           => fetch_to_decode,
      reset            => reset,
      instruction_in   => instruction_in,
      pc_4             => pc_4,
      condition        => condition,
      op_code          => op_code,
      rd_registers     => reg_rd,
      immediate        => immediate,
      rA_addr          => rA_addr,
      rB_addr          => rB_addr,
      rC_addr          => rC_addr,
      imm_value        => imm_value,
      dest_rD          => dest_rD,
      shift_amt        => shift_amt,
      shift_type       => shift_type,
      shift_reg        => shift_reg,
      exe_mul          => exe_mul,
      exe_BX           => exe_BX,
      exe_BBL          => exe_BBL,
      bbl_offset       => bbl_offset,
      decode_ok        => decode_ok,
      exe_ldr_str      => exe_ldr_str,
      ldr_str_base_reg => ldr_str_base_reg,
      ldr_str_logic    => ldr_str_logic);

  execute_1 : execute
    port map (
      clk                  => clk,
      enable               => decode_ok,
      reset                => reset,
      immediate            => immediate,
      op_code              => op_code,
      condition            => condition,
      rD_addr              => dest_rD,
      imm_value            => imm_value,
      shift_amt            => shift_amt,
      shift_type           => shift_type,
      shift_from_reg       => shift_reg,
      rA_data              => rA_data,
      rB_data              => rB_data,
      rC_data              => rC_data,
      d_PC_4               => d_PC_4,
      exe_BX               => exe_BX,
      exe_BBL              => exe_BBL,
      bbl_offset           => bbl_offset,
      exe_ldr_str          => exe_ldr_str,
      ldr_str_logic        => ldr_str_logic,
      exe_ldr_str_base_reg => ldr_str_base_reg,
      mul                  => exe_mul,
      PC_8                 => PC_8,
      dest_rD_addr         => dest_rD_addr,
      exe_out              => exe_out,
      exe_ok               => exe_ok,
      mem_ldr_str_logic    => mem_ldr_str_logic,
      mem_ldr_str          => mem_ldr_str,
      mem_data_rC          => mem_data_rC,
      mem_ldr_str_base_reg => mem_ldr_str_base_reg);

  memory_1 : memory
    port map (
      enable           => exe_ok,
      clk              => clk,
      reset            => reset,
      ldr_str          => mem_ldr_str,
      data_in          => exe_out,
      rD_addr          => dest_rD_addr,
      ldr_str_base_reg => mem_ldr_str_base_reg,
      rC_data          => rC_data,
      ldr_str_logic    => mem_ldr_str_logic,
      mem_addr_out     => mem_addr_out,
      data_out         => data_out_mem,
      dest_reg         => dest_reg,
      mem_wr           => mem_wr,
      mem_rd           => mem_rd,
      mem_data_in      => mem_data_in,
      mem_data_out     => mem_data_out,
      reg_wr           => reg_wr_mem,
      mem_ok           => mem_ok);

  writeback_1 : writeback
    port map (
      clk        => clk,
      enable     => mem_ok,
      reset      => reset,
      data_in    => data_out_mem,
      reg_wr     => reg_wr_mem,
      rD_addr    => dest_reg,
      reg_wr_out => reg_wr,
      dest_reg   => dest_reg,
      data_out   => rD_data,
      PC_wr      => PC_wr);

end rtl;
