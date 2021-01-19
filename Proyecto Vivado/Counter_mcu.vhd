library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity Counter_mcu is
    Port ( clk, reset, reset_count_mcu, load, mcu : in STD_LOGIC;
	       led_mcu: out std_logic;
           count: out std_logic_vector(ADDRESS-1 downto 0));
end Counter_mcu; 

architecture Behavioral of Counter_mcu is

    signal s_count : unsigned(ADDRESS-1 downto 0) :=(others => '0'); 

begin

    count <= std_logic_vector(s_count);
    
    process(clk, reset)
    begin
        if(reset = '1') then    
            s_count <= (others => '0');
	        led_mcu <= '1';
        elsif(rising_edge(clk)) then
            if(reset_count_mcu = '1') then
                s_count <= (others => '0');
                led_mcu <= '1';
            elsif( load = '0' and mcu = '0') then
                   s_count <= s_count + 1;
		           led_mcu <= '0';
            end if;
        end if;
    end process;
end Behavioral;