library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity writeback is

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

end entity writeback;

architecture rtl of writeback is

  signal PC_wr_i  : std_logic;
  signal reg_wr_i : std_logic;

begin  -- architecture rtl

  PC_wr_i  <= '1'    when rD_addr = r15  else '0';
  reg_wr_i <= reg_wr when rD_addr /= r15 else '0';

  process (clk, reset) is
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      PC_wr      <= '0';
      reg_wr_out <= '0';
      data_out   <= (others => 'X');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        PC_wr      <= PC_wr_i;
        reg_wr_out <= reg_wr_i;
        data_out   <= data_in;
        dest_reg   <= rD_addr;
      else
        PC_wr      <= '0';
        reg_wr_out <= '0';
      end if;
    end if;
  end process;

end architecture rtl;
