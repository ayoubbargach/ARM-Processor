library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity execute is
  
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

  signal cond_true : std_logic;
  signal s_alu     : std_logic_vector(31 downto 0);

  signal barrel_in  : std_logic_vector(31 downto 0);
  signal barrel_out : std_logic_vector(31 downto 0);
  
begin  -- behavioral

  ALU_1 : ALU
    port map (
      op_code   => op_code,
      cond      => cond,
      data_inA  => rA_data,
      data_inB  => barrel_out,
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

  barrel_in <= rB_data when immediate = '0' else imm_value when immediate = '1' else (others => '-');

  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      exe_out <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        exe_out <= s_alu;
      end if;
    end if;
  end process;
  
end behavioral;
