library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;

use work.instruction_field.all;

entity bench_decode_execute is

end entity bench_decode_execute;

architecture bench_dec_exe of bench_decode_execute is

  component registers is
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
  end component registers;

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

  signal clk              : std_logic;
  signal enable           : std_logic;
  signal reset            : std_logic;
  signal instruction_in   : std_logic_vector(31 downto 0);
  signal op_code          : std_logic_vector(3 downto 0);
  signal immediate        : std_logic;
  signal imm_value        : std_logic_vector(31 downto 0);
  signal dest_rD          : std_logic_vector(3 downto 0);
  signal shift_amt        : std_logic_vector(4 downto 0);
  signal shift_type       : std_logic_vector(1 downto 0);
  signal shift_reg        : std_logic;
  signal BX               : std_logic;
  signal BBL              : std_logic;
  signal bbl_offset       : std_logic_vector(23 downto 0);
  signal decode_ok        : std_logic;
  signal exe_ldr_str      : std_logic;
  signal ldr_str_base_reg : std_logic_vector(3 downto 0);
  signal ldr_str_logic    : std_logic_vector(4 downto 0);
  signal pc_4             : std_logic_vector(31 downto 0);
  signal mul              : std_logic;


  signal rd_enable : std_logic;
  signal wr_enable : std_logic;
  signal rA_addr   : std_logic_vector(3 downto 0);
  signal rB_addr   : std_logic_vector(3 downto 0);
  signal rC_addr   : std_logic_vector(3 downto 0);
  signal rD_addr   : std_logic_vector(3 downto 0);
  signal rA_data   : std_logic_vector(31 downto 0);
  signal rB_data   : std_logic_vector(31 downto 0);
  signal rC_data   : std_logic_vector(31 downto 0);
  signal rD_data   : std_logic_vector(31 downto 0);

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

  signal i : integer range 0 to 15 := 0;

begin  -- architecture bench_dec_exe

  registers_1 : registers
    port map (
      clk         => clk,
      reset       => reset,
      rd_enable   => rd_enable,
      wr_enable   => wr_enable,
      rA_addr     => rA_addr,
      rB_addr     => rB_addr,
      rC_addr     => rC_addr,
      rD_addr     => rD_addr,
      rA_data_out => rA_data,
      rB_data_out => rB_data,
      rC_data_out => rC_data,
      rD_data_in  => rD_data);

  decode_1 : decode
    port map (
      clk              => clk,
      enable           => enable,
      reset            => reset,
      instruction_in   => instruction_in,
      pc_4             => pc_4,
      condition        => condition,
      op_code          => op_code,
      rd_registers     => rd_enable,
      immediate        => immediate,
      rA_addr          => rA_addr,
      rB_addr          => rB_addr,
      rC_addr          => rC_addr,
      imm_value        => imm_value,
      dest_rD          => dest_rD,
      shift_amt        => shift_amt,
      shift_type       => shift_type,
      shift_reg        => shift_reg,
      exe_mul          => mul,
      exe_BX           => BX,
      exe_BBL          => BBL,
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
      exe_BX               => BX,
      exe_BBL              => BBL,
      bbl_offset           => bbl_offset,
      exe_ldr_str          => exe_ldr_str,
      ldr_str_logic        => ldr_str_logic,
      exe_ldr_str_base_reg => ldr_str_base_reg,
      mul                  => mul,
      PC_8                 => PC_8,
      dest_rD_addr         => dest_rD_addr,
      exe_out              => exe_out,
      exe_ok               => exe_ok,
      mem_ldr_str_logic    => mem_ldr_str_logic,
      mem_ldr_str          => mem_ldr_str,
      mem_data_rC          => mem_data_rC,
      mem_ldr_str_base_reg => mem_ldr_str_base_reg);

  reset <= '1', '0' after 10 ns;

  clock : process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end process;

  process
  begin
    loop1 : for i in 0 to 15 loop
      rD_data   <= std_logic_vector(to_unsigned(i, 32));
      rD_addr   <= std_logic_vector(to_unsigned(i, 4));
      wr_enable <= '1';
      wait for 10 ns;
    end loop;
    wr_enable <= '0';
  end process;

  process
  begin
    wait for 200 ns;
    instruction_in <= x"E" & "001" & "01000" & r0 & r14 & x"001";
    enable         <= '1';
    wait for 10 ns;
    instruction_in <= x"E" & "001" & "01000" & r1 & r14 & x"001";
    enable         <= '1';
    wait for 10 ns;
    instruction_in <= x"E" & "001" & "01000" & r2 & r14 & x"001";
    enable         <= '1';
    wait for 10 ns;
    instruction_in <= x"E" & "001" & "01000" & r3 & r14 & x"001";
    enable         <= '1';
    wait for 10 ns;
    instruction_in <= x"E" & "000" & "01000" & r4 & r14 & "00010" & "000" & r5;
    enable         <= '1';
    wait for 10 ns;
    instruction_in <= x"E" & "000" & "01000" & r5 & r14 & "00000" & "000" & r6;
    enable         <= '1';
    wait for 20 ns;

    enable <= '0';
  end process;


end architecture bench_dec_exe;
