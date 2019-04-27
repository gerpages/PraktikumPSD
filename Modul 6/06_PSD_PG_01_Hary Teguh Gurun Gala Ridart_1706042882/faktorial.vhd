library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.all;

entity faktorial is
port (CLK,S : IN STD_LOGIC;
MULTIPLIER,MULTIPLICAND: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
PRODUCT: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
D: OUT STD_LOGIC);
END faktorial;

ARCHITECTURE BEHAVIORAL OF faktorial IS
SIGNAL STATE, NEXTSTATE: INTEGER RANGE 0 TO 4;
SIGNAL A,B,PU,PL: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL ANDARRAY: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL ADDOUT: STD_LOGIC_VECTOR (4 DOWNTO 0);
SIGNAL MUXOUT: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL BZ,LA,CP,DB,IB,IA,LPU,LPL,EA,MS,CC,SC,C: STD_LOGIC;
ALIAS B3: STD_LOGIC IS B(3);
ALIAS A3: STD_LOGIC IS A(3);
BEGIN
BZ <='1' WHEN B="0000" ELSE '0';
MUXOUT <= PU WHEN MS='1' ELSE PL;
ANDARRAY <= A WHEN EA = '1' AND IA = '0' ELSE
NOT A WHEN EA ='1' AND IA = '1' ELSE
"1111" WHEN EA = '0' AND IA ='1' ELSE "0000";
ADDOUT<=('0'&MUXOUT)+('0'&ANDARRAY)+("0000"&C); 
PRODUCT <= PU & PL;

PROCESS(S,STATE,BZ)
BEGIN
CP<='0';LA<='0';DB<='0';IB<='0';MS<='0';CC<='0';
SC<='0';EA<='0';IA<='0';LPU<='0';
LPL <='0';D<= '0';
CASE STATE IS
WHEN 0 =>
CP <= '1';LA <= '1';
IF S='1' THEN NEXTSTATE <=1;
ELSE NEXTSTATE <= 0; END IF;
WHEN 1 =>
NEXTSTATE <= 2;
IF B3 = '1' THEN SC <='1';
ELSE CC <= '1'; END IF;
WHEN 2 =>
IF BZ ='1' THEN NEXTSTATE <=4;
ELSE NEXTSTATE <= 3; LPL <= '1'; EA <='1';END IF;
IF BZ ='0' AND B3 ='1' THEN IA <= '1';END IF;
WHEN 3 =>
LPU <= '1'; MS<= '1';NEXTSTATE <= 2;
IF B3='0' THEN CC <= '1' ; DB <= '1';
ELSE SC <= '1'; IB <='1';END IF;
IF (A3 XOR B3) = '1' THEN IA <= '1' ; END IF;
WHEN 4 =>
D<='1';
IF S='1' THEN NEXTSTATE <= 4;
ELSE NEXTSTATE <= 0; END IF;
END CASE ;
END PROCESS;

PROCESS (CLK)
BEGIN
IF CLK'EVENT AND CLK='1'THEN
IF LA ='1' THEN B <= MULTIPLIER ;
A <= MULTIPLICAND ; END IF;
IF CP ='1' THEN PU <="0000";
PL<= "0000"; END IF;
IF DB='1' THEN B <=B-1; END IF;
IF IB ='1' THEN B <= B+1; END IF;
IF LPL ='1' THEN PL <= ADDOUT (3 DOWNTO 0);END IF;
IF CC='1' THEN C <='0';ELSIF SC ='1' THEN C <='1';
ELSE C <= ADDOUT (4); END IF;
STATE <= NEXTSTATE;
END IF;
END PROCESS;
END BEHAVIORAL;