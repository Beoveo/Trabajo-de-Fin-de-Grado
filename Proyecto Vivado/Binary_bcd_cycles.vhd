library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.definitions.all;


entity Binary_bcd_cycles is
    port(
        clk, reset: in std_logic;
        binary_in: in std_logic_vector(CYCLES-1 downto 0);
        bcd: out std_logic_vector(31 downto 0)
    );
end Binary_bcd_cycles;

architecture behaviour of Binary_bcd_cycles is
    type states is (start, shift, done, inter);
    signal state, state_next: states;

    signal binary, binary_next: std_logic_vector(CYCLES-1 downto 0);
    signal bcds, bcds_reg, bcds_next: std_logic_vector(31 downto 0);
    -- output register keep output constant during conversion
    signal bcds_out_reg, bcds_out_reg_next: std_logic_vector(31 downto 0);
    -- need to keep track of shifts
    signal shift_counter, shift_counter_next: natural range 0 to CYCLES;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            binary <= (others => '0');
            bcds <= (others => '0');
            state <= start;
            bcds_out_reg <= (others => '0');
            shift_counter <= 0;
        elsif rising_edge(clk) then
            binary <= binary_next;
            bcds <= bcds_next;
            state <= state_next;
            bcds_out_reg <= bcds_out_reg_next;
            shift_counter <= shift_counter_next;
        end if;
    end process;

    convert:
    process(state, binary, binary_in, bcds, bcds_reg, shift_counter)
    begin
        state_next <= state;
        bcds_next <= bcds;
        binary_next <= binary;
        shift_counter_next <= shift_counter;

        case state is
            when start =>
                state_next <= shift;
                binary_next <= binary_in;
                bcds_next <= (others => '0');
                shift_counter_next <= 0;
            when inter =>
                state_next <= shift;
                binary_next <= binary_in;
                bcds_next <= (others => '0');
                shift_counter_next <= 0;
            when shift =>
                if shift_counter = CYCLES then
                    state_next <= done;
                else
                    binary_next <= binary(CYCLES-2 downto 0) & 'L';
                    bcds_next <= bcds_reg(30 downto 0) & binary(CYCLES-1);
                    shift_counter_next <= shift_counter + 1;
                end if;
            when done =>
                state_next <= inter;
        end case;
    end process;

    bcds_reg(31 downto 28) <= bcds(31 downto 28) + 3 when bcds(31 downto 28) > 4 else
                              bcds(31 downto 28);
    bcds_reg(27 downto 24) <= bcds(27 downto 24) + 3 when bcds(27 downto 24) > 4 else
                              bcds(27 downto 24);
    bcds_reg(23 downto 20) <= bcds(23 downto 20) + 3 when bcds(23 downto 20) > 4 else
                              bcds(23 downto 20);
    bcds_reg(19 downto 16) <= bcds(19 downto 16) + 3 when bcds(19 downto 16) > 4 else
                              bcds(19 downto 16);
    bcds_reg(15 downto 12) <= bcds(15 downto 12) + 3 when bcds(15 downto 12) > 4 else
                              bcds(15 downto 12);
    bcds_reg(11 downto 8)  <= bcds(11 downto 8) + 3 when bcds(11 downto 8) > 4 else
                              bcds(11 downto 8);
    bcds_reg(7 downto 4)   <= bcds(7 downto 4) + 3 when bcds(7 downto 4) > 4 else
                              bcds(7 downto 4);
    bcds_reg(3 downto 0)   <= bcds(3 downto 0) + 3 when bcds(3 downto 0) > 4 else
                              bcds(3 downto 0);

    bcds_out_reg_next <= bcds when state = done else
                         bcds_out_reg;

    bcd <= bcds_out_reg;

end behaviour; 
