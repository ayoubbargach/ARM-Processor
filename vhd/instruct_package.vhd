library ieee;
use ieee.std_logic_1164.all;

package instruction_field is

-- condition fields
constant EQ : std_logic_vector (3 downto 0) := "0000"; -- Equal
constant NE : std_logic_vector (3 downto 0) := "0001"; -- Not Equal
constant CS : std_logic_vector (3 downto 0) := "0010"; -- Carry Set
constant CC : std_logic_vector (3 downto 0) := "0011"; -- Carry Clear
constant MI : std_logic_vector (3 downto 0) := "0100"; -- Minus/Negative
constant PL : std_logic_vector (3 downto 0) := "0101"; -- Plus/Positive
constant VS : std_logic_vector (3 downto 0) := "0110"; -- Overflow
constant VC : std_logic_vector (3 downto 0) := "0111"; -- No overflow
constant HI : std_logic_vector (3 downto 0) := "1000"; -- Unsigned higher
constant LS : std_logic_vector (3 downto 0) := "1001"; -- Unsigned lower
constant GE : std_logic_vector (3 downto 0) := "1010"; -- Signed greater than or equal
constant LT : std_logic_vector (3 downto 0) := "1011"; -- Signed less than
constant GT : std_logic_vector (3 downto 0) := "1100"; -- Signed greater than
constant LE : std_logic_vector (3 downto 0) := "1101"; -- Signed less than or equal
constant AL : std_logic_vector (3 downto 0) := "1110"; -- Always
-- "1111" IS RESERVED AND MUST NEVER BE USED
-- see https://cs107e.github.io/readings/armisa.pdf p.5 for more about cond. field
-- Les conditions set les flags dans le CPSR

-- registers
constant r0 : std_logic_vector (3 downto 0) := "0000";
constant r1 : std_logic_vector (3 downto 0) := "0001";
constant r2 : std_logic_vector (3 downto 0) := "0010";
constant r3 : std_logic_vector (3 downto 0) := "0011";
constant r4 : std_logic_vector (3 downto 0) := "0100";
constant r5 : std_logic_vector (3 downto 0) := "0101";
constant r6 : std_logic_vector (3 downto 0) := "0110";
constant r7 : std_logic_vector (3 downto 0) := "0111";
constant r8 : std_logic_vector (3 downto 0) := "1000";
constant r9 : std_logic_vector (3 downto 0) := "1001";
constant r10 : std_logic_vector (3 downto 0) := "1010";
constant r11 : std_logic_vector (3 downto 0) := "1011";
constant r12 : std_logic_vector (3 downto 0) := "1100";
constant r13 : std_logic_vector (3 downto 0) := "1101";
constant r14 : std_logic_vector (3 downto 0) := "1110";
constant r15 : std_logic_vector (3 downto 0) := "1111"; -- PC : Program Counter

-- Operation Code / CPSR flags
constant op_AND : std_logic_vector (3 downto 0) := "0000";
constant op_EOR : std_logic_vector (3 downto 0) := "0001";  -- Exclusive OR
constant op_SUB : std_logic_vector (3 downto 0) := "0010";
constant op_RSB : std_logic_vector (3 downto 0) := "0011";
constant op_ADD : std_logic_vector (3 downto 0) := "0100";
constant op_ADC : std_logic_vector (3 downto 0) := "0101";
constant op_SBC : std_logic_vector (3 downto 0) := "0110";
constant op_RSC : std_logic_vector (3 downto 0) := "0111";
constant op_TST : std_logic_vector (3 downto 0) := "1000";
constant op_TEQ : std_logic_vector (3 downto 0) := "1001";
constant op_CMP : std_logic_vector (3 downto 0) := "1010";
constant op_CMN : std_logic_vector (3 downto 0) := "1011";
constant op_ORR : std_logic_vector (3 downto 0) := "1100";
constant op_MOV : std_logic_vector (3 downto 0) := "1101";
constant op_BIC : std_logic_vector (3 downto 0) := "1110";
constant op_MVN : std_logic_vector (3 downto 0) := "1111";
-- see https://cs107e.github.io/readings/armisa.pdf p.10-11 for more


end instruction_field;
