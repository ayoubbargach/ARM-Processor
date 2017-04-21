library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity execute is

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

end execute;

architecture behavioral of execute is

  component ALU
    port (
      op_code   : in  std_logic_vector(3 downto 0);
      cond      : in  std_logic_vector(3 downto 0);
      data_inA  : in  std_logic_vector(31 downto 0);
      data_inB  : in  std_logic_vector(31 downto 0);
      cond_true : in  std_logic;
      result    : out std_logic_vector(31 downto 0));
  end component;

  component barrelshifter
    port (
      data_in             : in  std_logic_vector(31 downto 0);
      shift_amt           : in  std_logic_vector(4 downto 0);
      shift_type          : in  std_logic_vector(1 downto 0);
      shift_from_data_reg : in  std_logic;
      leastByte_rC_data   : in  std_logic_vector(7 downto 0);
      data_out            : out std_logic_vector(31 downto 0));
  end component;

  component multiply is
    port (
      mul      : in  std_logic;
      data_inA : in  std_logic_vector(31 downto 0);
      data_inB : in  std_logic_vector(31 downto 0);
      mul_out  : out std_logic_vector(31 downto 0));
  end component multiply;

  signal cond_true : std_logic;
  signal s_alu     : std_logic_vector(31 downto 0);

  signal data_inA_ALU : std_logic_vector(31 downto 0);
  signal data_inB_ALU : std_logic_vector(31 downto 0);

  signal barrel_in  : std_logic_vector(31 downto 0);
  signal barrel_out : std_logic_vector(31 downto 0);

  signal mul_out : std_logic_vector(31 downto 0);

  signal branch            : std_logic_vector(1 downto 0);
  signal extend_bbl_offset : std_logic_vector(31 downto 0);

  signal exe_out_i : std_logic_vector(31 downto 0);

begin  -- behavioral

  branch <= exe_BX & exe_BBL;

  with bbl_offset(23) select
    extend_bbl_offset <=
    x"00" & bbl_offset when '0',
    x"11" & bbl_offset when '1',
    x"00" & bbl_offset when others;

  data_inA_ALU <= mul_out         when mul = '1'                       else rA_data;
  data_inB_ALU <= (others => '0') when (mul = '1' and immediate = '0') else rC_data when (mul = '1' and immediate = '1') else barrel_out;

  ALU_1 : ALU
    port map (
      op_code   => op_code,
      cond      => condition,
      data_inA  => data_inA_ALU,
      data_inB  => data_inB_ALU,
      cond_true => cond_true,
      result    => s_alu);

  barrelshifter_1 : barrelshifter
    port map (
      data_in             => barrel_in,
      shift_amt           => shift_amt,
      shift_type          => shift_type,
      shift_from_data_reg => shift_from_reg,
      leastByte_rC_data   => rC_data(7 downto 0),
      data_out            => barrel_out);

  multiply_1 : multiply
    port map (
      mul      => mul,
      data_inA => rA_data,
      data_inB => rB_data,
      mul_out  => mul_out);



  barrel_in <= extend_bbl_offset when branch = "01" else rB_data when immediate = '0' else imm_value when immediate = '1' else (others => '-');

  with branch select
    exe_out_i <=
    s_alu      when "00",               -- no branch
    rA_data    when "10",               -- BX
    barrel_out when "01",               -- BBL
    s_alu      when others;

  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      exe_out <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        exe_out              <= exe_out_i;
        dest_rD_addr         <= rD_addr;
        mem_ldr_str_logic    <= ldr_str_logic;
        mem_ldr_str          <= exe_ldr_str;
        exe_ok               <= '1';
        PC_8                 <= d_PC_4;
        mem_data_rC          <= rC_data;
        mem_ldr_str_base_reg <= exe_ldr_str_base_reg;
      else
        exe_ok <= '0';
      end if;
    end if;
  end process;

end behavioral;
