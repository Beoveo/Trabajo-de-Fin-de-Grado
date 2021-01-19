library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity Counter_cycles is
    Port ( clk, reset_count_cycles, reset, load : in STD_LOGIC;
           count: out std_logic_vector(CYCLES-1 downto 0));
end Counter_cycles; 

architecture Behavioral of Counter_cycles is

    signal s_count : unsigned(CYCLES-1 downto 0) :=(others => '0'); 

begin

    count <= std_logic_vector(s_count);
    
    process(clk, reset)
    begin
        if(reset = '1') then 
            s_count <= (others => '0');
        elsif(rising_edge(clk)) then
            if(reset_count_cycles = '1') then
                s_count <= (others => '0');
            elsif ( load='0') then
                s_count <= s_count + 1;
            end if;
        end if;
    
    end process;

end Behavioral;