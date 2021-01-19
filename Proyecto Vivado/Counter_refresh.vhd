library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity Counter_refresh is
port (clk, reset, load : in std_logic;
      freq: in std_logic_vector(REFRESH-1 downto 0); --cambiar por tam bueno
	  tc : out std_logic);
end Counter_refresh ;

architecture behavioral of Counter_refresh is

    signal s_count : unsigned(REFRESH-1 downto 0) :=(others => '0');  
    signal s_freq : integer := 0; 
    signal s_tc : std_logic;  

begin
    
    s_freq <= to_integer(unsigned(freq));
    tc <= s_tc;
    
    process(clk, reset)
    begin
        if(reset = '1') then   
            s_count <= (others => '0');
            s_tc <= '0';
        elsif(rising_edge(clk)) then
            if ( load='0') then
                if( to_integer(unsigned(s_count)) > s_freq ) then
                    s_tc <= '1';
                else 
                    if( to_integer(unsigned(s_count)) = s_freq - 2) then --le restas dos por que hay que resetear los contadores, por eso hay que avisar dos ciclos antes.
                        s_tc <= '1';
                    else
                        s_count <= s_count + 1;
                    end if;
                end if;
            else 
                s_tc <= '0';
                s_count <= (others => '0');
            end if;
        end if;
    end process;

end behavioral;
