library ieee;
use ieee.std_logic_1164.all;
--use work.definitions.all;

entity Controller is
    port( clk, reset : in std_logic;
        btn: in  std_logic;
        control_tc: in std_logic_vector(1 downto 0);
        tc_out, write_read, ce : out std_logic;
        control_load:	out std_logic_vector(5	downto 0);	
        control_reset:	out std_logic_vector(3	downto 0);
        led_read, led_write, led_blue : out std_logic);     
end Controller;

architecture arch_controller of Controller is
    type T_STATE is (IDLE, WRITE, START, WAIT_RST_COUNT, READ);
    signal s_state: T_STATE;
    
    signal s_control_load:	std_logic_vector(5	downto	0);
    alias load_count_addr	:	std_logic is s_control_load(0); 
    alias load_count_cycles	:	std_logic is s_control_load(1); 
    alias load_count_error:	std_logic is s_control_load(2); 
    alias load_count_mcu	:	std_logic is s_control_load(3); 
    alias load_register_data	:	std_logic is s_control_load(4); 
    alias load_count_ref : std_logic is s_control_load(5);
    
    signal s_control_reset:	std_logic_vector(3	downto	0);
    alias reset_register_data	:	std_logic is s_control_reset(0); 
    alias reset_count_addr:	std_logic is s_control_reset(1); 
    alias reset_count_cycles	:	std_logic is s_control_reset(2); 
    alias reset_count_error	:	std_logic is s_control_reset(3); 
    
    signal s_control_tc:	std_logic_vector(1	downto	0);
    alias tc_addr : std_logic is s_control_tc(0);
    alias tc_refresh : std_logic is s_control_tc(1);
    
    signal s_btn : std_logic;
    signal s_tc: std_logic:= '0';
begin
    tc_out <= s_tc;
    led_write <= '1' when s_state = WRITE else '0';
    led_read <= '1' when s_state = READ else '0';
    control_load <= s_control_load;
    control_reset <= s_control_reset;
    s_control_tc <= control_tc;
    P_BTN: process(btn, s_state)
    begin
        if btn = '1' then
            s_btn <= '1';
        elsif s_state = READ then
            s_btn <= '0';
        end if;
    end process; 
    
    INI_LED: process (reset, s_state)
    begin
        if reset = '1' then
            led_blue <= '1';
        end if;
    end process INI_LED;     
    
    COMB: process (clk, reset)
    begin
        if reset = '1' then
            --memoria
            ce <= '1';
            write_read <= '0';
            --regdata
            load_register_data <= '1';
            reset_register_data <= '1';
            --contaddress
            load_count_addr <= '1';
            reset_count_addr <= '1';
            --uart
            s_tc <= '0';
            --ciclos
            reset_count_cycles <= '1';
            load_count_cycles <= '1';
            --mcu
            load_count_mcu <= '1';
            --err
            load_count_error <= '1';
            reset_count_error <= '1'; 
            --refresh
            load_count_ref <= '1';
            s_state <= IDLE;
        elsif clk'event and clk = '1' then
            case s_state is
                when IDLE =>
                    --memoria
                    ce <= '0';
                    write_read <= '0';
                    --regdata
                    load_register_data <= '1';
                    reset_register_data <= '1';
                    --contaddress
                    load_count_addr <= '1';
                    reset_count_addr <= '1';
                    --uart
                    s_tc <= '0';
                    --ciclos
                    reset_count_cycles <= '0';
                    load_count_cycles <= '1';
                    --mcu
                    load_count_mcu <= '1';
                    --err
                    load_count_error <= '1';
                    reset_count_error <= '0'; 
                    --refresh
                    load_count_ref <= '1';
                    s_state <= WRITE;
                when WRITE =>                          
                    if(tc_addr = '1') then 
                        ce <= '1';
                        load_count_addr <= '1';
                        reset_count_addr <= '1';
                        load_count_ref <= '0';
                        s_state <= START;
                    else
                        ce <= '0';
                        load_count_addr <= '0';
                        reset_count_addr <= '0';                       
                    end if;                                 
                when START =>
                    s_tc <= '0';                                  
                    if (tc_refresh = '1') then 
                        reset_count_cycles <= '1';
                        reset_count_error <= '1';
                        s_state <= WAIT_RST_COUNT;
                    else
                        write_read <= '0';         
                        s_state <= START;
                    end if;
                when WAIT_RST_COUNT=>
                    ce <= '0';
                    write_read <= '1';
                    load_count_cycles <= '0';
                    reset_count_cycles <= '0';
                    load_count_error <= '0';
                    reset_count_error <= '0';
                    load_count_ref <= '1'; 
                    reset_count_addr <= '0';
                    s_state <= READ;   
                when READ =>
                    if(tc_addr = '1') then 
                        ce <= '1';
                        load_count_addr <= '1';
                        load_count_cycles <= '1';
                        s_tc <= '1';
                        load_count_mcu <= '1';
                        load_count_error <= '1';
                        reset_count_addr <= '1';   
                        load_count_ref <= '0';
                        s_state <= START;
                    else 
                        load_count_addr <= '0';
                        reset_count_addr <= '0'; 
                        load_count_mcu <= '0';
                    end if;         
            end case;
        end if;
    end process;
end arch_controller;