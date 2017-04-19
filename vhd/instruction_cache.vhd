library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity instr_cache is

  port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    cache_rd       : in  std_logic;
    cache_wr       : in  std_logic;
    instr_addr_rd  : in  std_logic_vector(31 downto 0);
    instr_data_in  : in  std_logic_vector(31 downto 0);
    instr_addr_wr  : in  std_logic_vector(31 downto 0);
    instr_data_out : out std_logic_vector(31 downto 0));

end entity instr_cache;

-- cache de 64ko
architecture rtl of instr_cache is
  type cache_addr is array (0 to 63999) of std_logic_vector(7 downto 0);
  signal inst : cache_addr;

  signal inst_addr_rd_u   : unsigned(15 downto 0);
  signal instr_data_out_i : std_logic_vector(31 downto 0);

  signal inst_addr_wr_u : unsigned(15 downto 0);

begin  -- architecture rtl

  inst_addr_rd_u <= unsigned(instr_addr_rd(15 downto 0));

  process (cache_rd, inst_addr_rd_u)
  begin  -- process
    if cache_rd = '1' then
      instr_data_out_i <= inst(to_integer(inst_addr_rd_u)) & inst(to_integer(inst_addr_rd_u+1)) & inst(to_integer(inst_addr_rd_u+2)) & inst(to_integer(inst_addr_rd_u+3));
    else
      instr_data_out_i <= instr_data_out_i;
    end if;
  end process;

  instr_data_out <= instr_data_out_i;

  inst_addr_wr_u <= unsigned(instr_addr_wr(15 downto 0));

  process (clk, reset)
    variable i : integer range 0 to 63999 := 0;
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      inst <= (others => ((others => '0')));
    elsif clk'event and clk = '1' then  -- rising clock edge
      if cache_wr = '1' then
        inst(to_integer(inst_addr_wr_u))   <= instr_data_in(31 downto 24);
        inst(to_integer(inst_addr_wr_u+1)) <= instr_data_in(23 downto 16);
        inst(to_integer(inst_addr_wr_u+2)) <= instr_data_in(15 downto 8);
        inst(to_integer(inst_addr_wr_u+3)) <= instr_data_in(7 downto 0);
      end if;
    end if;
  end process;

end architecture rtl;
