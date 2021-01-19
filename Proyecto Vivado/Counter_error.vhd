library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity Counter_error is
    Port ( clk, reset, reset_count_error, error, load: in STD_LOGIC;
           g: out std_logic;
           count: out std_logic_vector(ADDRESS-1 downto 0));
end Counter_error;

architecture Behavioral of Counter_error is

    signal s_count : unsigned(ADDRESS-1 downto 0) :=(others => '0'); 

begin

    count <= std_logic_vector(s_count);
    
    process(clk, reset)
    begin
        if(reset = '1') then 
            s_count <= (others => '0');
        elsif(rising_edge(clk)) then
            if(reset_count_error = '1')then
                s_count <= (others => '0');
            elsif (load = '0') then
               if(error = '1')then 
                   s_count <= s_count + 1;
                   g <= '1';
               else 
                   g <= '0';
               end if;
          end if;
        end if;
    end process;

end Behavioral;