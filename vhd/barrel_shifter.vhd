library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruction_field.all;

entity barrelshifter is
  
  port (
    data_in             : in  std_logic_vector(31 downto 0);
    shift_amt           : in  std_logic_vector(4 downto 0);
    shift_type          : in  std_logic_vector(1 downto 0);
    shift_from_data_reg : in  std_logic;
    leastByte_rC_data   : in  std_logic_vector(7 downto 0);
    data_out            : out std_logic_vector(31 downto 0));

end barrelshifter;

architecture rtl of barrelshifter is

  signal shift_amt_i        : std_logic_vector(4 downto 0);
  signal s1, s2, s3, s4, s5 : std_logic_vector(31 downto 0);

begin  -- rtl

  shift_amt_i <= leastByte_rC_data(4 downto 0) when shift_from_data_reg = '1' else shift_amt;


  stage1 : process (data_in, shift_amt_i, shift_type)
  begin  -- process stage1
    if shift_amt_i(0) = '1' then        -- decalage de 1
      case shift_type is
        when "00"   => s1 <= data_in(30 downto 0) & '0';          -- LSL1
        when "01"   => s1 <= '0' & data_in(31 downto 1);          -- LSR1
        when "10"   => s1 <= data_in(31) & data_in(31 downto 1);  -- ASR1
        when "11"   => s1 <= data_in(0) & data_in(31 downto 1);   -- ROR1
        when others => null;
      end case;
    else
      s1 <= data_in;
    end if;
  end process stage1;

  stage2 : process (s1, shift_amt_i, shift_type)
  begin  -- process stage2
    if shift_amt_i(1) = '1' then        -- decalage de 2
      case shift_type is
        when "00"   => s2 <= s1(29 downto 0) & "00";            -- LSL2
        when "01"   => s2 <= "00" & s1(31 downto 2);            -- LSR2
        when "10"   => s2 <= (31 downto 30 => s1(31)) & s1(31 downto 2);  -- ASR2
        when "11"   => s2 <= s1(1 downto 0) & s1(31 downto 2);  -- ROR2
        when others => null;
      end case;
    else
      s2 <= s1;
    end if;
  end process stage2;

  stage3 : process (s2, shift_amt_i, shift_type)
  begin  -- process stage3
    if shift_amt_i(2) = '1' then        -- decalage de 4
      case shift_type is
        when "00"   => s3 <= s2(27 downto 0) & "0000";          -- LSL4
        when "01"   => s3 <= "0000" & s2(31 downto 4);          -- LSR4
        when "10"   => s3 <= (31 downto 28 => s2(31)) & s2(31 downto 4);  -- ASR4
        when "11"   => s3 <= s2(3 downto 0) & s2(31 downto 4);  -- ROR4
        when others => null;
      end case;
    else
      s3 <= s2;
    end if;
  end process stage3;

  stage4 : process (s3, shift_amt_i, shift_type)
  begin  -- process stage4
    if shift_amt_i(3) = '1' then        -- decalage de 8
      case shift_type is
        when "00"   => s4 <= s3(23 downto 0) & x"00";           -- LSL8
        when "01"   => s4 <= x"00" & s3(31 downto 8);           -- LSR8
        when "10"   => s4 <= (31 downto 24 => s3(31)) & s3(31 downto 8);  -- ASR8
        when "11"   => s4 <= s3(7 downto 0) & s3(31 downto 8);  -- ROR8
        when others => null;
      end case;
    else
      s4 <= s3;
    end if;
  end process stage4;

  stage5 : process (s4, shift_amt_i, shift_type)
  begin  -- process stage5
    if shift_amt_i(4) = '1' then        -- decalage de 16
      case shift_type is
        when "00"   => s5 <= s4(15 downto 0) & x"0000";           -- LSL16
        when "01"   => s5 <= x"0000" & s4(31 downto 16);          -- LSR16
        when "10"   => s5 <= (31 downto 16 => s4(31)) & s4(31 downto 16);  -- ASR16
        when "11"   => s5 <= s4(15 downto 0) & s4(31 downto 16);  -- ROR16
        when others => null;
      end case;
    else
      s5 <= s4;
    end if;
  end process stage5;

  data_out <= (others => '0') when shift_from_data_reg = '1' and unsigned(leastByte_rC_data) >= 32 else s5;

end rtl;
