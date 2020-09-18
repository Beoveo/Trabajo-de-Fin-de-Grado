library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity Counter_frequencies is
    Port ( clk, reset, load, op, np: in STD_LOGIC;
           freq: out std_logic_vector(FREQUENCY-1 downto 0));
end Counter_frequencies;
-- op = 0 => +
-- op = 1 => - 
architecture Behavioral of Counter_frequencies is

    signal s_freq : unsigned(FREQUENCY-1 downto 0) :=(others => '0'); 

begin

    freq <= std_logic_vector(s_freq);
    
    process(clk, reset)
    begin
        if(reset = '1') then 
            s_freq <= (others => '0');
        elsif(rising_edge(clk)) then
            if ( load = '0' and np = '0') then
                if(op = '0') then
                    s_freq <= s_freq +1;
                elsif (op = '1') then
                    s_freq <= s_freq -1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;