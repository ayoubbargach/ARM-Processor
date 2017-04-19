library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

use work.instruction_field.all;

entity memory is

  port (
    enable           : in  std_logic;
    clk              : in  std_logic;
    reset            : in  std_logic;
    ldr_str          : in  std_logic;
    data_in          : in  std_logic_vector(31 downto 0);
    rD_addr          : in  std_logic_vector(3 downto 0);
    ldr_str_base_reg : in  std_logic_vector(3 downto 0);
    rC_data          : in  std_logic_vector(31 downto 0);
    ldr_str_logic    : in  std_logic_vector(4 downto 0);  -- [24:20] de l'instruction LDR, STR
    mem_addr_out     : out std_logic_vector(31 downto 0);
    data_out         : out std_logic_vector(31 downto 0);
    dest_reg         : out std_logic_vector(3 downto 0);
    mem_wr           : out std_logic;
    mem_rd           : out std_logic;
    mem_data_in      : in  std_logic_vector(31 downto 0);
    mem_data_out     : out std_logic_vector(31 downto 0);
    reg_wr           : out std_logic);

end memory;

architecture rtl of memory is

  signal data_out_i     : std_logic_vector(31 downto 0);
  signal data_in_i      : std_logic_vector(31 downto 0);
  signal reg_wr_i       : std_logic;
  signal dest_reg_i     : std_logic_vector(3 downto 0);
  signal mem_wr_i       : std_logic;
  signal mem_rd_i       : std_logic;
  signal mem_data_in_i  : std_logic_vector(31 downto 0);
  signal mem_data_out_i : std_logic_vector(31 downto 0);
  signal mem_addr_out_i : std_logic_vector(31 downto 0);


begin  -- rtl

  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      data_out <= (others => '-');
      dest_reg <= (others => '-');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        data_out <= data_in;
        dest_reg <= dest_reg_i;
        reg_wr   <= reg_wr_i;
      else
        reg_wr <= '0';
      end if;
    end if;
  end process;

  process (ldr_str, data_in, ldr_str_logic) is
  begin  -- process
    if ldr_str = '1' then
      case ldr_str_logic(1 downto 0) is
        when "00" => mem_addr_out_i <= data_in;
                     mem_wr_i       <= '1';
                     mem_rd_i       <= '0';
                     mem_data_out_i <= rC_data;
                     reg_wr_i       <= '0';
        when "01" => mem_addr_out_i <= data_in;
                     mem_rd_i      <= '1';
                     mem_wr_i      <= '0';
                     mem_data_in_i <= mem_data_in;
                     reg_wr_i      <= '0';
        when "10" => mem_addr_out_i <= data_in;
                     mem_wr_i       <= '1';
                     mem_rd_i       <= '0';
                     mem_data_out_i <= rC_data;
                     dest_reg_i     <= ldr_str_base_reg;
                     data_out_i     <= data_in;
                     reg_wr_i       <= '1';
        when "11" => mem_addr_out_i <= data_in;
                     mem_rd_i      <= '1';
                     mem_wr_i      <= '0';
                     reg_wr_i      <= '1';
                     dest_reg_i    <= ldr_str_base_reg;
                     data_out_i    <= data_in;
                     mem_data_in_i <= mem_data_in;
        when others => mem_wr_i <= '0';
                       mem_rd_i <= '0';
                       reg_wr_i <= '0';
      end case;
    else
      data_out_i <= data_in;
      dest_reg_i <= rD_addr;
      reg_wr_i   <= '1';
    end if;
  end process;

end rtl;
