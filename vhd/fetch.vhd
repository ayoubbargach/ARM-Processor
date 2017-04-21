library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity fetch is

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

end fetch;

architecture behavioral of fetch is

  signal current_pc : unsigned(31 downto 0);
  signal pc         : unsigned(31 downto 0);
  signal fetch_ok_i : std_logic;
  signal cache_rd_i : std_logic;
  signal count      : std_logic;
  signal count_i    : std_logic;

begin  -- behavioral

-- /!\ In ARM state, bits [1:0] of r15 are undefined and must be ignored. Bits [31:2] contain the
-- PC. Pas pris en compte pour le moment

  process(clk, reset)
  begin
    if reset = '1' then                 -- reset asynchrone sur niveau haut
      current_pc <= (others => '0');
      fetch_ok   <= '0';
      cache_rd   <= '0';
      count      <= '0';
    elsif clk'event and clk = '1' then
      current_pc <= pc;
      fetch_ok   <= fetch_ok_i;
      cache_rd   <= cache_rd_i;
      count      <= count_i;
    end if;
  end process;

  process(pc_wr, current_pc, cache_miss, enable, count, pc_data)
  begin
    if pc_wr = '1' then
      --instruct_addr <= pc_data;
      pc         <= unsigned(pc_data);
      fetch_ok_i <= '0';
      cache_rd_i <= '1';
      count_i    <= '0';
    else
      --instruct_addr <= std_logic_vector(current_pc);
      if enable = '1' and cache_miss = '0' then
        count_i <= '1';
        if count = '1' then
          pc <= current_pc + 4;
        else
          pc <= current_pc;
        end if;

        fetch_ok_i <= '1';
        cache_rd_i <= '1';
      else
        count_i    <= '0';
        pc         <= current_pc;
        fetch_ok_i <= '0';
        cache_rd_i <= '0';
      end if;
    end if;
  end process;

  pc_4          <= std_logic_vector(pc + 4);
  instruct_addr <= std_logic_vector(current_pc(31 downto 0));

end behavioral;
