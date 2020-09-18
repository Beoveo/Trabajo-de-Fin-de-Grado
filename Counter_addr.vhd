library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity Counter_addr is
port (clk, reset, reset_count_addr, load : in std_logic;
	  tc : out std_logic; --shows the end of read/write
      count : out std_logic_vector(ADDRESS-1 downto 0));
end Counter_addr ;

architecture behavioral of Counter_addr is

    signal s_count : unsigned(ADDRESS-1 downto 0) :=(others => '0');  
    signal s_tc : std_logic;  

begin

    count <= std_logic_vector(s_count);
    tc <= s_tc;
    
    process(clk, reset)
    begin
        if(reset = '1') then   
            s_count <= (others => '0');
            s_tc <= '0';
        elsif(rising_edge(clk)) then
            if ( load='0') then
                if( to_integer(unsigned(s_count)) = ADDR_COUNT ) then
                    s_count <= (others => '0');
                    s_tc <= '0';
                else 
                    if( to_integer(unsigned(s_count)) = ADDR_COUNT - 1) then
                        s_tc <= '1';
                    else
                        s_tc <= '0';
                    end if;
                    if s_tc = '0' then
                        s_count <= s_count + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

end behavioral;
