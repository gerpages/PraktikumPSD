LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ADDER IS
	PORT(	NUM1, NUM2	:	IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			CLK	: 	IN		STD_LOGIC := '1';
			EN		:	IN		STD_LOGIC;
			RES	: 	OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0));
END ADDER;

ARCHITECTURE ADD OF ADDER IS
	SIGNAL SUM	: 	STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	BEGIN
		PROCESS	
		BEGIN
			WAIT UNTIL CLK = '1' AND CLK'EVENT;
			IF EN = '1' THEN
				SUM <= NUM1 + NUM2;
			END IF;
		END PROCESS;
		RES <= SUM;		
END ADD;