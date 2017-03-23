library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity barrel_shifter is
  
  port (
    immediate  : in  std_logic;  -- bit 25 de l'instruction data processing
    operand2   : in  std_logic_vector(11 downto 0);
    data_rB    : in  std_logic_vector(31 downto 0);
    data_rC    : in  std_logic_vector(31 downto 0);
    barrel_out : out std_logic_vector(31 downto 0));

  -- immediate : 0 => operand2 is a register ([11:4] = shift, [3:0] = register)
  --             1 => operand2 is a imm. value ([7:0] = value, [11:8] = rotate)
  -- https://cs107e.github.io/readings/armisa.pdf p.10 for more


end barrel_shifter;

architecture rtl of barrel_shifter is

  signal tmp_rB    : std_logic_vector(31 downto 0);
  signal imm_value : std_logic_vector(31 downto 0);

begin  -- rtl

  -- shift op. on registers https://cs107e.github.io/readings/armisa.pdf p.12
  -- operand2(4) : 0 => imm. shift amount in [11:7]
  --               1 => shift amount is bottom byte of a register specified in
  --               [11:8]


  process (immediate, operand2, data_rB)
  begin  -- process
    if immediate = '0' then
      if operand2(4) = '0' and unsigned(operand2(11 downto 7)) = 0 then
        tmp_rB <= data_rB;
      elsif operand2(4) = '1' and unsigned(data_rC(7 downto 0)) = 0 then
        tmp_rB <= data_rB;
      else
        case operand2(6 downto 5) is              -- shift type
          when "00" => if operand2(4) = '0' then  -- logical left
                         tmp_rB <= data_rB(31 downto to_integer(unsigned(operand2(11 downto 7)), 5)) & (to_integer(unsigned(operand2(11 downto 7)),5)-1 downto 0 => '0');
                       elsif operand2(4) = '1' then
                         tmp_rB <= data_rB(31 downto to_integer(unsigned(data_rC(7 downto 0)),8)) & (to_integer(unsigned(data_rC(7 downto 0)),8)-1 downto 0 => '0');
                       else
                         tmp_rB <= (others => '-');
                       end if;
          when "01" => if operand2(4) = '0' then  -- logical right
                         tmp_rB <= (to_integer(unsigned(operand2(11 downto 7)))-1 downto 0 => '0') & data_rB(31 downto to_integer(unsigned(operand2(11 downto 7))));
                       elsif operand2(4) = '1' then
                         tmp_rB <= (to_integer(unsigned(data_rC(7 downto 0)))-1 downto 0 => '0') & data_rB(31 downto to_integer(unsigned(data_rC(7 downto 0))));
                       else
                         tmp_rB <= (others => '-');
                       end if;
          when "10" => if operand2(4) = '0' then  -- arithmetic right
                         tmp_rB <= data_rB(31 downto to_integer(unsigned(operand2(11 downto 7)))-1) & data_rB(31-to_integer(unsigned(operand2(11 downto 7))) downto to_integer(unsigned(operand2(11 downto 7))));
                       elsif operand2(4) = '1' then
                         tmp_rB <= data_rB(31 downto to_integer(unsigned(data_rC(7 downto 0)))-1) & data_rB(31-to_integer(unsigned(data_rC(11 downto 0))) downto to_integer(unsigned(data_rC(11 downto 0))));
                       else
                         tmp_rB <= (others => '-');
                       end if;
          when "11" => if operand2(4) = '0' then  -- rotate right
                         tmp_rB <= data_rB(to_integer(unsigned(operand2(11 downto 7)))-1 downto 0) & data_rB(31 downto to_integer(unsigned(operand2(11 downto 7))));
                       elsif operand2(4) = '1' then
                         tmp_rB <= data_rB(to_integer(unsigned(data_rC(7 downto 0)))-1 downto 0) & data_rB(31 downto to_integer(unsigned(data_rC(7 downto 0))));
                       else
                         tmp_rB <= (others => '-');
                       end if;
          when others => null;
        end case;
      end if;
      
    elsif immediate = '1' then
      imm_value <= ((23 downto 0 => '0') & operand2(7 downto 0));
    else
      null;
    end if;
  end process;

  barrel_out <= tmp_rB when immediate = '0' else imm_value when immediate = '1' else (others => '-');

end rtl;
