library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

-- Registro que guarda el valor "11111111" que se escribirá en la memoria
entity Register_data is
    Port (clk, reset, load, reset_register_data : in std_logic;
     data_out : out std_logic_vector(INPUT_OUTPUT-1 downto 0));
end Register_data;

architecture Behavioral of Register_data is
    signal s_data : std_logic_vector(INPUT_OUTPUT-1 downto 0);
begin
    process(clk, reset)
    begin
        if(reset = '1') then    --active high reset for the counter.
            s_data <= (others => '1');
        elsif(rising_edge(clk)) then
            if (reset_register_data = '1') then
                s_data <= (others => '1');
            elsif (load = '0') then
               s_data <= (others => '1');
            end if;
        end if;
    end process;
    data_out <= s_data;
end Behavioral;
