library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity decode is

  port (
    clk              : in  std_logic;
    enable           : in  std_logic;
    reset            : in  std_logic;
    instruction_in   : in  std_logic_vector(31 downto 0);
    pc_4             : in  std_logic_vector(31 downto 0);
    condition        : out std_logic_vector(3 downto 0);
    op_code          : out std_logic_vector(3 downto 0);
    rd_registers     : out std_logic;
    immediate        : out std_logic;  -- bit 25 de l'instruction data processing
    rA_addr          : out std_logic_vector(3 downto 0);
    rB_addr          : out std_logic_vector(3 downto 0);
    rC_addr          : out std_logic_vector(3 downto 0);
    imm_value        : out std_logic_vector(31 downto 0);
    dest_rD          : out std_logic_vector(3 downto 0);  -- adresse du registre de destination
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

end decode;

-- see https://cs107e.github.io/readings/armisa.pdf for data processing instructions

architecture behavioral of decode is

  type instruct_type is (data_proc, MUL, BX, BBL, LDR_STR, miss);  -- instruc. de data et de branchements pour l'instant
  signal instruction : instruct_type;

  signal op_code_i          : std_logic_vector(3 downto 0);
  signal cond_i             : std_logic_vector(3 downto 0);
  --signal rd_registers_i     : std_logic;
  signal immediate_i        : std_logic;
  --signal rA_addr_i          : std_logic_vector(3 downto 0);
  --signal rB_addr_i          : std_logic_vector(3 downto 0);
  --signal rC_addr_i          : std_logic_vector(3 downto 0);
  signal imm_value_i        : std_logic_vector(31 downto 0);
  signal dest_rD_i          : std_logic_vector(3 downto 0);
  signal shift_amt_i        : std_logic_vector(4 downto 0);
  signal shift_type_i       : std_logic_vector(1 downto 0);
  signal shift_reg_i        : std_logic;
  signal mul_i              : std_logic;
  signal exe_BBL_i          : std_logic;
  signal exe_BX_i           : std_logic;
  signal bbl_offset_i       : std_logic_vector(23 downto 0);
  signal ldr_str_i          : std_logic;
  signal ldr_str_logic_i    : std_logic_vector(4 downto 0);
  signal ldr_str_base_reg_i : std_logic_vector(3 downto 0);



begin  -- behavioral

  cond_i <= instruction_in(31 downto 28);

  process (clk, reset)
  begin  -- process
    if reset = '1' then                 -- asynchronous reset (active high)
      condition   <= (others => '1');
      op_code     <= (others => '-');
      --rd_registers <= '-';
      immediate   <= '-';
      --rA_addr      <= (others => '-');
      --rB_addr      <= (others => '-');
      --rC_addr      <= (others => '-');
      imm_value   <= (others => '-');
      dest_rD     <= (others => '-');
      shift_amt   <= (others => '-');
      shift_type  <= (others => '-');
      shift_reg   <= '-';
      decode_ok   <= '0';
      exe_ldr_str <= '0';
      bbl_offset  <= (others => '-');
      exe_BX      <= '0';
      exe_BBL     <= '0';
      exe_mul     <= '0';

    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        condition        <= cond_i;
        op_code          <= op_code_i;
        --rd_registers     <= rd_registers_i;
        immediate        <= immediate_i;
        --rA_addr          <= rA_addr_i;
        --rB_addr          <= rB_addr_i;
        --rC_addr          <= rC_addr_i;
        imm_value        <= imm_value_i;
        dest_rD          <= dest_rD_i;
        shift_amt        <= shift_amt_i;
        shift_type       <= shift_type_i;
        shift_reg        <= shift_reg_i;
        exe_BX           <= exe_BX_i;
        exe_BBL          <= exe_BBL_i;
        bbl_offset       <= bbl_offset_i;
        decode_ok        <= '1';
        ldr_str_logic    <= ldr_str_logic_i;
        exe_ldr_str      <= ldr_str_i;
        ldr_str_base_reg <= ldr_str_base_reg_i;
        exe_mul          <= mul_i;
      else
        decode_ok <= '0';
      --rd_registers <= '0';
      end if;
    end if;
  end process;

  process (instruction_in)
  begin  -- process
    if instruction_in = x"00000000" then
      instruction <= miss;
    elsif instruction_in(27 downto 26) = "00" then
      if instruction_in(27 downto 4) = x"12fff1" then
        instruction <= BX;
      elsif instruction_in(25) = '0' and instruction_in(7 downto 4) = "1001" then
        instruction <= MUL;
      else
        instruction <= data_proc;
      end if;
    elsif instruction_in(27 downto 25) = "101" then
      instruction <= BBL;
    elsif instruction_in(27 downto 26) = "01" then
      instruction <= LDR_STR;
    else
      instruction <= instruction;
    end if;
  end process;

  process (instruction, instruction_in, pc_4)
  begin  -- process
    case instruction is
      when data_proc => op_code_i <= instruction_in(24 downto 21);
                        dest_rD_i       <= instruction_in(15 downto 12);
                        --rA_addr_i       <= instruction_in(19 downto 16);
                        rA_addr         <= instruction_in(19 downto 16);
                        immediate_i     <= instruction_in(25);
                        exe_BX_i        <= '0';
                        exe_BBL_i       <= '0';
                        ldr_str_i       <= '0';
                        mul_i           <= '0';
                        --rd_registers_i  <= '1';
                        rd_registers    <= '1';
                        ldr_str_logic_i <= (others => '-');

                        if instruction_in(25) = '1' then
                          shift_amt_i  <= instruction_in(11 downto 8) & '0';
                          shift_type_i <= "11";
                          imm_value_i  <= x"000000" & instruction_in(7 downto 0);
                        else
                          --rB_addr_i    <= instruction_in(3 downto 0);
                          rB_addr      <= instruction_in(3 downto 0);
                          shift_type_i <= instruction_in(6 downto 5);
                          shift_reg_i  <= instruction_in(4);
                          if instruction_in(4) = '1' then
                            --rC_addr_i <= instruction_in(11 downto 8);
                            rC_addr <= instruction_in(11 downto 8);
                          else
                            shift_amt_i <= instruction_in(11 downto 7);
                          end if;
                        end if;
      when MUL => dest_rD_i <= instruction_in(19 downto 16);
                  op_code_i       <= op_ADD;
                  rA_addr         <= instruction_in(3 downto 0);
                  rB_addr         <= instruction_in(11 downto 8);
                  rC_addr         <= instruction_in(15 downto 12);
                  immediate_i     <= instruction_in(21);  -- /!\ bit 21 = signal ACCUMULATE
                  exe_BX_i        <= '0';
                  exe_BBL_i       <= '0';
                  ldr_str_i       <= '0';
                  mul_i           <= '1';
                  rd_registers    <= '1';
                  ldr_str_logic_i <= (others => '-');

      when BX =>  --rA_addr_i <= instruction_in(3 downto 0);
        rA_addr         <= instruction_in(3 downto 0);
        dest_rD_i       <= r15;
        --rd_registers_i  <= '1';
        rd_registers    <= '1';
        mul_i           <= '0';
        exe_BX_i        <= '1';
        exe_BBL_i       <= '0';
        ldr_str_i       <= '0';
        ldr_str_logic_i <= (others => '-');
      when BBL => exe_BX_i <= '0';
                  exe_BBL_i       <= '1';
                  mul_i           <= '0';
                  ldr_str_i       <= '0';
                  dest_rD_i       <= r15;
                  shift_amt_i     <= "00010";
                  shift_type_i    <= "00";
                  --rd_registers_i  <= '0';
                  rd_registers    <= '0';
                  bbl_offset_i    <= instruction_in(23 downto 0);
                  ldr_str_logic_i <= (others => '-');
      when LDR_STR => immediate_i <= not instruction_in(25);
                      --rA_addr_i          <= instruction_in(19 downto 16);
                      rA_addr            <= instruction_in(19 downto 16);
                      ldr_str_base_reg_i <= instruction_in(19 downto 16);
                      --rC_addr_i          <= instruction_in(15 downto 12);
                      rC_addr            <= instruction_in(15 downto 12);
                      ldr_str_i          <= '1';
                      --rd_registers_i     <= '1';
                      rd_registers       <= '1';
                      mul_i              <= '0';
                      exe_BX_i           <= '0';
                      exe_BBL_i          <= '0';
                      ldr_str_logic_i    <= instruction_in(24 downto 20);
                      dest_rD_i          <= instruction_in(15 downto 12);
                      if instruction_in(25) = '0' then
                        imm_value_i <= x"00000" & instruction_in(11 downto 0);
                      else
                        --rB_addr_i    <= instruction_in(3 downto 0);
                        rB_addr      <= instruction_in(3 downto 0);
                        shift_type_i <= instruction_in(6 downto 5);
                      end if;

                      if instruction_in(24) = '0' then
                        op_code_i <= op_SUB;
                      else
                        op_code_i <= op_ADD;
                      end if;
      when miss => exe_BX_i <= '0';
                   exe_BBL_i    <= '0';
                   ldr_str_i    <= '0';
                   rd_registers <= '0';
                   mul_i        <= '0';
      when others => rd_registers <= '0';
    end case;
  end process;

end behavioral;
