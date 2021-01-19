library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity Data_path is
    port(reset, clk : in std_logic;
        control_load : in std_logic_vector(5 downto 0);
        control_reset : in std_logic_vector(3 downto 0);
        control_freq : in std_logic_vector(3 downto 0);
        err : in std_logic;
        read_data : in std_logic_vector(INPUT_OUTPUT-1 downto 0);
        control_tc : out std_logic_vector(1 downto 0);
        result_addr, result_error, result_mcu : out std_logic_vector(ADDRESS-1 downto 0);
        result_cycles : out std_logic_vector(CYCLES-1 downto 0);
        result_data : out std_logic_vector(INPUT_OUTPUT-1 downto 0);
        result_freq : out std_logic_vector(REFRESH-1 downto 0);
        led_mcu,led_error : out std_logic);
    end Data_path ;

architecture Behavioral of Data_path is
    
    component Counter_addr is
    port (clk, reset, reset_count_addr, load : in std_logic;
        tc : out std_logic;
        count : out std_logic_vector(ADDRESS-1 downto 0));
    end component;
    ----------------------------------------------------------------------------------
    component Counter_error is
    Port ( clk, reset, reset_count_error, error, load: in STD_LOGIC;
        g: out std_logic;
        count: out std_logic_vector(ADDRESS-1 downto 0));
    end component;
    ----------------------------------------------------------------------------------
    component Counter_cycles is
    Port ( clk, reset_count_cycles, reset, load : in STD_LOGIC;
        count: out std_logic_vector(CYCLES-1 downto 0));
    end component;
    ----------------------------------------------------------------------------------
    component Counter_mcu is
    Port ( clk, reset, reset_count_mcu, load, mcu : in STD_LOGIC;
        led_mcu: out std_logic;
        count: out std_logic_vector(ADDRESS-1 downto 0));
    end component; 
    ----------------------------------------------------------------------------------
    component Counter_frequencies is
    Port ( clk, reset, load, op, np: in STD_LOGIC;
           freq: out std_logic_vector(FREQUENCY-1 downto 0));
    end component;
    ----------------------------------------------------------------------------------
    component Counter_refresh is
    Port (clk, reset, load : in std_logic;
      freq: in std_logic_vector(REFRESH-1 downto 0);
	  tc : out std_logic);
    end component;
    ----------------------------------------------------------------------------------
    component Register_data is
    Port (clk, reset, load, reset_register_data : in std_logic;
        data_out : out std_logic_vector(INPUT_OUTPUT-1 downto 0));
    end component;
    ----------------------------------------------------------------------------------
    component Register_frequency is
    Port (clk, reset, load : in std_logic;
        count_freq : in std_logic_vector(FREQUENCY-1 downto 0);
        data_out : out std_logic_vector(REFRESH-1 downto 0));
    end component;
        
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
    
    signal s_control_freq:	std_logic_vector(3	downto	0);
    alias load_count_freq : std_logic is s_control_freq(0);
    alias op : std_logic is s_control_freq(1);
    alias load_register_freq: std_logic is s_control_freq(2);
    alias np : std_logic is s_control_freq(3);
    
    signal s_control_tc:	std_logic_vector(1	downto	0);
    alias tc_addr : std_logic is s_control_tc(0);
    alias tc_refresh : std_logic is s_control_tc(1);

    
    -- COUNTERS
    signal s_count_addr: std_logic_vector(ADDRESS-1 downto 0);
    signal s_count_error: std_logic_vector(ADDRESS-1 downto 0);
    signal s_count_cycles: std_logic_vector(CYCLES-1 downto 0);
    signal s_count_mcu: std_logic_vector(ADDRESS-1 downto 0);
    signal s_count_freq: std_logic_vector(FREQUENCY-1 downto 0);
    
    --REGISTERS
    signal s_register_cycles: std_logic_vector(CYCLES-1 downto 0);
    signal s_register_data: std_logic_vector(INPUT_OUTPUT-1 downto 0);
    signal s_register_mcu: std_logic_vector(ADDRESS-1 downto 0);
    signal s_register_error: std_logic_vector(ADDRESS-1 downto 0);
    signal s_register_freq: std_logic_vector(REFRESH-1 downto 0);
    
    signal s_mcu: std_logic;
    signal s_err: std_logic;
    signal s_g: std_logic;
begin
      
    ADDR_COUNTER: Counter_addr
    port map(clk => clk, reset => reset, load => load_count_addr, tc => tc_addr, count => s_count_addr, reset_count_addr=> reset_count_addr);
    ---------------------------------------------------------------------------------------------
    ERROR_COUNTER: Counter_error
    port map(clk => clk, reset => reset, reset_count_error => reset_count_error, error => err, g => s_g, load => load_count_error, count => s_count_error);
    ---------------------------------------------------------------------------------------------
    CYCLES_COUNTER: Counter_cycles
    port map( clk => clk , reset_count_cycles => reset_count_cycles , reset => reset, load => load_count_cycles, count => s_count_cycles);
    --------------------------------------------------------------------------------------------- 
    MCU_COUNTER: Counter_mcu
    port map( clk => clk , reset_count_mcu => reset_count_error , reset => reset, load => load_count_mcu, mcu => s_mcu, count => s_count_mcu, led_mcu => led_mcu);
    ---------------------------------------------------------------------------------------------   
    FREQ_COUNTER: Counter_frequencies
    port map( clk => clk , reset => reset, load => load_count_freq, op => op, np => np, freq => s_count_freq);
    ---------------------------------------------------------------------------------------------
    REFRESH_COUNTER: Counter_refresh
    port map( clk => clk , reset => reset, load => load_count_ref, freq => s_register_freq, tc => tc_refresh);
    --------------------------------------------------------------------------------------------
    DATA_REGISTER: Register_data
    port map(clk => clk, reset => reset, load => load_register_data, data_out => s_register_data, reset_register_data => reset_register_data);
    --------------------------------------------------------------------------------------------
    FREQ_REGISTER: Register_frequency
    port map(clk => clk, reset => reset, load => load_register_freq, count_freq => s_count_freq, data_out => s_register_freq);
    
    s_control_load <= control_load;
    s_control_reset <= control_reset;
    s_control_freq <= control_freq;
    control_tc <= s_control_tc;
    result_addr <= s_count_addr;
    result_data <= s_register_data;
    result_cycles <= s_count_cycles;
    result_mcu <= s_count_mcu;
    result_error <= s_count_error;
    result_freq <= s_register_freq;
    
    s_mcu <= '0' when read_data /= s_register_data else '1';
    --Control de errores, se pone ROJO cuando detecta error y lo corrige.	    
	P_ERR: process(reset)
	begin
        if reset = '1' then
            led_error <= '1';
        else
            if err = '1' then
                led_error<= '0';
            end if;
        end if;
     end process;
	P_S_ERR: process(reset)
	begin
        if reset = '1' then
            s_err <= '0';
        else
            if err = '1' then
                s_err <= '1';
            elsif s_g = '1' then 
                s_err <= '0';
            end if;
        end if;
     end process;	
end Behavioral;
