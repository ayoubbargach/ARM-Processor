library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity decode is
  
  port (
    clk            : in  std_logic;
    enable         : in  std_logic;
    reset          : in  std_logic;
    instruction_in : in  std_logic_vector(31 downto 0);
    op_code        : out std_logic_vector(3 downto 0);
    rd_registers   : out std_logic;
    immediate      : out std_logic;  -- bit 25 de l'instruction data processing
    rA_addr        : out std_logic_vector(3 downto 0);
    rB_addr        : out std_logic_vector(3 downto 0);
    rC_addr        : out std_logic_vector(3 downto 0);
    imm_value      : out std_logic_vector(31 downto 0);
    dest_rD        : out std_logic_vector(3 downto 0);  -- adresse du registre de destination
    shift_amt      : out std_logic_vector(4 downto 0);
    shift_type     : out std_logic_vector(1 downto 0);
    shift_reg      : out std_logic);

end decode;

-- see https://cs107e.github.io/readings/armisa.pdf for data processing instructions

architecture behavioral of decode is

  type   instruct_type is (data_proc, BX, BBL);  -- instruc. de data et de branchements pour l'instant
  signal instruction : instruct_type;

  signal op_code_i      : std_logic_vector(3 downto 0);
  signal rd_registers_i : std_logic;
  signal immediate_i    : std_logic;
  signal rA_addr_i      : std_logic_vector(3 downto 0);
  signal rB_addr_i      : std_logic_vector(3 downto 0);
  signal rC_addr_i      : std_logic_vector(3 downto 0);
  signal imm_value_i    : std_logic_vector(31 downto 0);
  signal dest_rD_i      : std_logic_vector(3 downto 0);
  signal shift_amt_i    : std_logic_vector(4 downto 0);
  signal shift_type_i   : std_logic_vector(1 downto 0);
  signal shift_reg_i    : std_logic;
  

begin  -- behavioral

  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      op_code      <= (others => '-');
      rd_registers <= '-';
      immediate    <= '-';
      rA_addr      <= (others => '-');
      rB_addr      <= (others => '-');
      rC_addr      <= (others => '-');
      imm_value    <= (others => '-');
      dest_rD      <= (others => '-');
      shift_amt    <= (others => '-');
      shift_type   <= (others => '-');
      shift_reg    <= '-';

    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        op_code      <= op_code_i;
        rd_registers <= '1';
        immediate    <= immediate_i;
        rA_addr      <= rA_addr_i;
        rB_addr      <= rB_addr_i;
        rC_addr      <= rC_addr_i;
        imm_value    <= imm_value_i;
        dest_rD      <= dest_rD_i;
        shift_amt    <= shift_amt_i;
        shift_type   <= shift_type_i;
        shift_reg    <= shift_reg_i;
      else
        rd_registers <= '0';
      end if;
    end if;
  end process;

  process (instruction_in)
  begin  -- process
    if instruction_in(27 downto 26) = "00" then
      if instruction_in(27 downto 4) = x"12fff1" then
        instruction <= BX;
      else
        instruction <= data_proc;
      end if;
    elsif instruction_in(27 downto 25) = "101" then
      instruction <= BBL;
    else
      instruction <= instruction;
    end if;
  end process;

  process (instruction, instruction_in)
  begin  -- process
    case instruction is
      when data_proc => op_code_i <= instruction_in(24 downto 21);
                        dest_rD_i   <= instruction_in(19 downto 16);
                        rA_addr_i   <= instruction_in(15 downto 12);
                        immediate_i <= instruction_in(25);
                        if instruction_in(25) = '1' then
                          shift_amt_i  <= instruction_in(11 downto 8) & '0';
                          shift_type_i <= "11";
                          imm_value_i  <= x"000000" & instruction_in(7 downto 0);
                        else
                          rB_addr_i    <= instruction_in(3 downto 0);
                          shift_type_i <= instruction_in(6 downto 5);
                          shift_reg_i  <= instruction_in(4);
                          if instruction_in(4) = '1' then
                            rC_addr_i <= instruction_in(11 downto 8);
                          else
                            shift_amt_i <= instruction_in(11 downto 7);
                          end if;
                        end if;
      when BX     => rA_addr_i <= instruction_in(3 downto 0);
      when BBL    =>
      when others => null;
    end case;
  end process;
  
end behavioral;
