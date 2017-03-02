library IEEE ;
use IEEE.std_logic_1164.ALL ;
use ieee.numeric_std.all;

use work.instruction_field.all

entity ALU is
	port(	A,B		: in STD_LOGIC_VECTOR(31 downto 0) ;
		CMD		: in STD_LOGIC_VECTOR(3 downto 0) ;
		Clk      	: in std_logic;
		reset		: in std_logic;
		Zero		: out std_logic;
		S		: out STD_LOGIC_VECTOR(7 downto 0)) ;
		
end ALU;

architecture A of ALU is

signal result: unsigned (8 downto 0);
signal a_u: unsigned (7 downto 0);
signal b_u: unsigned (7 downto 0);

begin

process (Clk, reset)
begin

	if reset = '1' then
		result <= "000000000";
	elsif rising_edge(clk) then

		case CMD is
			when "000" => result <= ('0' & a_u);
			when "011" => result <= ('0' & a_u) + ('0' & b_u );
			when "010" => result <= ('0' & a_u) - ('0' & b_u );
			when "001" => result <= ('0' & b_u) - ('0' & a_u );
			when "100" => result <= ('0' & a_u) XOR ('0' & b_u );
			when "110" => result <= ('0' & a_u) AND ('0' & b_u );
			when "101" => result <= ('0' & a_u) OR ('0' & b_u );
			when "111" => result <= ('0' & a_u) + "000000001";
			when others => result <= "111111111";
		end case;

	end if;



--with CMD select result<= "000000000" when "000",
--			 ('0' & a_u) + ('0' & b_u ) when "011", --			
  -- 			 ('0' & a_u) - ('0' & b_u ) when "010",
	--		 ('0' & b_u) - ('0' & a_u ) when "001",
	--		 ('0' & a_u) XOR ('0' & b_u ) when "100",
	--		 ('0' & a_u) AND ('0' & b_u ) when "110",
	--		 ('0' & a_u) OR ('0' & b_u ) when "101",
    	--		 "111111111" when others;

end process;

zero <= '1' when result (7 downto 0) = "00000000"
	else '0';

S<= std_logic_vector(result(7 downto 0));
a_u<= unsigned(a);
b_u<= unsigned(b);

end A;
    
    

