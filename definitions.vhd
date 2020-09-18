library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package definitions is
    constant W_FACTORS : integer := 21;
    constant ADDRESS : integer := 21;
    constant CYCLES: integer:= 24;
    constant INPUT_OUTPUT : integer := 8;
    constant ADDR_COUNT : integer := 2000000;
    constant FREQUENCY : integer := 3;
    constant REFRESH : integer := 32;
    
    --UART
    constant N_CYCLES_STR : integer := 10;
    constant N_CYCLES_INT : integer := 9;
    constant N_ERROR_STR : integer := 11;
    constant N_FAILURES_INT : integer := 8; 
    constant N_MCU_STR : integer := 15;
    constant N_FREQUENCY_INT : integer := 11; 
    constant N_FREQUENCY_STR : integer := 12; 
    
    --Tabla de frecuencias  
    type FREQX is array (8-1 downto 0) of std_logic_vector(REFRESH-1 downto 0); 
    constant FREQ_TABLE : FREQX := ("01000100100010111001101110000000", "00111011100110101100101000000000", "00101100101101000001011110000000",
     "00011101110011010110010100000000", "00001110111001101011001010000000", "00001000111100001101000110000000", "00000100011110000110100011000000", 
     "00000010001101001001001101000000");
     
     type CHAR_ARRAY is array (integer range<>) of std_logic_vector(7 downto 0);
constant CYCLES_STR : CHAR_ARRAY(0 to N_CYCLES_STR-1) := (X"0A",  --\n
        X"0D",  --\r
        X"43",  --C
        X"59",  --Y
        X"43",  --C
        X"4C",  --L
        X"45",  --E
        X"53",  --S
        X"3A",  --:
        X"20"); --
    
    constant ERROR_STR : CHAR_ARRAY(0 to N_ERROR_STR-1) := (
        X"0D",  --\r
        X"46",  --F
        X"41",  --A
        X"49",  --I
        X"4C",  --L
        X"55",  --U
        X"52",  --R
        X"45",  --E
        X"53",  --S
        X"3A",  --:
        X"20"); --
    
    constant MCU_STR : CHAR_ARRAY(0 to N_MCU_STR-1) := (
        X"0D",  --\r
        X"4D",  --M
        X"43",  --C
        X"55",  --U
        X"20",  --
        X"46",  --F
        X"41",  --A
        X"49",  --I
        X"4C",  --L
        X"55",  --U
        X"52",  --R
        X"45",  --E
        X"53",  --S
        X"3A",  --:
        X"20"); --
        
    constant FREQUENCY_STR : CHAR_ARRAY(0 to N_FREQUENCY_STR-1) := (
        X"0D",  --\r
        X"46",  --F
        X"52",  --R
        X"45",  --E
        X"51",  --Q
        X"55",  --U
        X"45",  --E
        X"4E",  --N
        X"43",  --C
        X"59",  --Y
        X"3A",  --:
        X"20"); --
        
    
end package definitions;