library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity Register_frequency is
    Port (clk, reset, load : in std_logic;
     count_freq : in std_logic_vector(FREQUENCY-1 downto 0);
     data_out : out std_logic_vector(REFRESH-1 downto 0));
end Register_frequency;

architecture Behavioral of Register_frequency is
    signal s_data : std_logic_vector(REFRESH-1 downto 0);
    signal s_count_freq : integer;
    signal s_freq : std_logic_vector(REFRESH-1 downto 0);
begin
    s_count_freq <= to_integer(unsigned(count_freq));
    s_freq <= FREQ_TABLE(s_count_freq);
    process(clk, reset)
    begin
        if(reset = '1') then    
            s_data <= FREQ_TABLE(0);
        elsif(rising_edge(clk)) then
            if (load = '0') then
               s_data <= s_freq;
            end if;
        end if;
    end process;
    data_out <= s_data;
end Behavioral;