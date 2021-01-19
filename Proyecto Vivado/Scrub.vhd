library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity Scrub is
    port( reset, clk : in  std_logic;
        btn, rx     : in std_logic;
        addr : out STD_LOGIC_VECTOR (ADDRESS-1 downto 0);
        w, r,ce: out STD_LOGIC;
        err: in STD_LOGIC;
        led_read,led_write,led_mcu,led_blue,led_error,tx: out std_logic;
        io : inout STD_LOGIC_VECTOR (INPUT_OUTPUT-1 downto 0));
end Scrub;

architecture arch_ASM_scrub of Scrub is
    component Controller
        port( clk, reset : in std_logic;
            btn: in  std_logic;
            control_tc: in std_logic_vector(1 downto 0);
            tc_out, write_read, ce : out std_logic;
            control_load:	out std_logic_vector(5	downto 0);	
            control_reset:	out std_logic_vector(3	downto 0);
            led_read, led_write, led_blue : out std_logic); 
    end component Controller;
    --------------------------------------------------------------------------------------------    
    component Data_path
        port(reset, clk : in std_logic;
            control_load:	in std_logic_vector(5	downto 0);	
            control_reset:	in std_logic_vector(3	downto 0);
            control_freq:	in std_logic_vector(3	downto 0);
            err : in std_logic;
            read_data : in std_logic_vector(INPUT_OUTPUT-1 downto 0);
            control_tc: out std_logic_vector(1 downto 0);
            result_addr, result_error, result_mcu : out std_logic_vector(ADDRESS-1 downto 0);
            result_cycles : out std_logic_vector(CYCLES-1 downto 0);
            result_data : out std_logic_vector(INPUT_OUTPUT-1 downto 0);
            result_freq : out std_logic_vector(REFRESH-1 downto 0);
            led_mcu,led_error : out std_logic);
    end component ;
    --------------------------------------------------------------------------------------------
    component Debouncer is
        generic(
            clk_freq    : integer := 12_000_000;  --system clock frequency in Hz
            stable_time : integer := 1000);         --time button must remain stable in ms
        port(
            clk     : in  std_logic;  --input clock
            reset : in  std_logic;  --asynchronous active low reset
            button  : in  std_logic;  --input signal to be debounced
            result  : out std_logic); --debounced signal
    end component Debouncer;
    --------------------------------------------------------------------------------------------
    component Uart is
        Port ( CLK : in  std_logic;
               SEND : in  std_logic;
               RECV : in std_logic;
               DATA : in  std_logic_vector (7 downto 0);
               DATA_OUT : out  std_logic_vector (7 downto 0);
               READY : out  std_logic;
               UART_TX : out  std_logic;
               UART_RX: in  std_logic);
    end component Uart;
    --------------------------------------------------------------------------------------------
    component Binary_bcd_cycles is
        port(
            clk, reset: in std_logic;
            binary_in: in std_logic_vector(CYCLES-1 downto 0);
            bcd: out std_logic_vector(31 downto 0));
    end component Binary_bcd_cycles ;
    
    --------------------------------------------------------------------------------------------   
    component Binary_bcd_failures is
        port(
            clk, reset: in std_logic;
            binary_in: in std_logic_vector(ADDRESS-1 downto 0);
            bcd: out std_logic_vector(27 downto 0));
    end component Binary_bcd_failures;
    --------------------------------------------------------------------------------------------   
    component Binary_bcd_frequencies is
        port(
            clk, reset: in std_logic;
            binary_in: in std_logic_vector(REFRESH-1 downto 0);
            bcd: out std_logic_vector(39 downto 0));
    end component;
    --------------------------------------------------------------------------------------------   
    component Uart_controller is
        port ( clk, reset, tc, rx, uartRdy: in std_logic;
            uartRecv, uartSend,  tx : out std_logic;
            uartDataRx : in std_logic_vector (7 downto 0);
            uartDataTx : out std_logic_vector (7 downto 0);
            control_freq: out std_logic_vector(3	downto 0);
            bcd_error, bcd_mcu: in std_logic_vector(27 downto 0);
            bcd_cycles: in std_logic_vector(31 downto 0);
            bcd_freq: in std_logic_vector(39 downto 0));
    end component;
        
    signal s_control_load: std_logic_vector(5	downto 0);	
    signal s_control_reset: std_logic_vector(3	downto 0);
    signal s_control_tc: std_logic_vector(1 downto 0);
    
    signal s_result_error: std_logic_vector(ADDRESS-1 downto 0);
    signal s_result_mcu: std_logic_vector(ADDRESS-1 downto 0);
    signal s_result_cycles: std_logic_vector(CYCLES-1 downto 0);
    signal s_result_data : std_logic_vector(INPUT_OUTPUT-1 downto 0);
    signal s_result_freq : std_logic_vector(REFRESH-1 downto 0);
    --TC
    signal s_tc_out : std_logic;      
    --DEBOUNCER
    signal s_btn: std_logic;
    --MEMORY
    signal s_write_read : std_logic;
    --UART_TX_RX_CTRL control signals
    signal s_uartRdy : std_logic;
    signal s_uartDataTx : std_logic_vector (7 downto 0):= "00000000";
    signal s_uartDataRx : std_logic_vector (7 downto 0):= "00000000";
    signal s_uartTx : std_logic;
    signal s_uartRx : std_logic;
    signal s_uartSend : std_logic := '0';
    signal s_uartRecv : std_logic := '0';
    -- BCD Conversor
    signal s_bcd_cycles: std_logic_vector(31 downto 0);
    signal s_bcd_error, s_bcd_mcu: std_logic_vector(27 downto 0);
    signal s_bcd_freq: std_logic_vector(39 downto 0);
   
    --Freq
    signal s_control_freq:	std_logic_vector(3	downto	0);

begin
    
    U_CONTROLLER: Controller
    port map(clk => clk, reset => reset,
        control_tc => s_control_tc, btn => s_btn,
        tc_out => s_tc_out, write_read => s_write_read, ce => ce, 
        control_load => s_control_load, control_reset => s_control_reset,
        led_read => led_read, led_write => led_write, led_blue => led_blue);
    -------------------------------------------------------------------------------------		  
    U_DATA_PATH: Data_path
    port map(clk => clk, reset => reset, control_tc => s_control_tc,
        control_load => s_control_load, control_reset => s_control_reset, control_freq => s_control_freq,
        err => err, read_data => io,
        result_addr => addr, result_error => s_result_error, result_mcu => s_result_mcu,
        result_cycles => s_result_cycles, result_data => s_result_data, result_freq => s_result_freq, 
        led_mcu => led_mcu, led_error => led_error);
    -------------------------------------------------------------------------------------
    U_DEBOUNCER: Debouncer
    generic map(clk_freq => 12_000_000, stable_time => 10)
    port map(clk => clk,reset => reset, button => btn, result => s_btn);            
    -------------------------------------------------------------------------------------
    U_UART: Uart
    port map(CLK => clk, SEND => s_uartSend, RECV => s_uartRecv, DATA => s_uartDataTx, DATA_OUT => s_uartDataRx, 
     READY => s_uartRdy, UART_TX => s_uartTX, UART_RX => s_uartRX );
    -------------------------------------------------------------------------------------        
    BCD_CYCLES: Binary_bcd_cycles
    port map(clk => clk, reset => reset, binary_in => s_result_cycles,bcd => s_bcd_cycles);
    -------------------------------------------------------------------------------------           
    BCD_MCU: Binary_bcd_failures
    port map(clk => clk, reset => reset, binary_in => s_result_mcu, bcd => s_bcd_mcu);
    -------------------------------------------------------------------------------------
    BCD_ERR: Binary_bcd_failures
    port map(clk => clk, reset => reset, binary_in => s_result_error, bcd => s_bcd_error);
    -------------------------------------------------------------------------------------
    BCD_FREQ: Binary_bcd_frequencies
    port map(clk => clk, reset => reset, binary_in => s_result_freq, bcd => s_bcd_freq);
    -------------------------------------------------------------------------------------
    U_UART_CONTROLLER: Uart_controller
    port map(clk => clk, reset => reset, tc => s_tc_out, rx => s_uartRX, tx => s_uartTX, uartRdy => s_uartRdy,
        bcd_freq => s_bcd_freq, bcd_error => s_bcd_error, bcd_mcu => s_bcd_mcu, bcd_cycles=> s_bcd_cycles,
        control_freq => s_control_freq, uartRecv => s_uartRecv, uartSend => s_uartSend, uartDataRx => s_uartDataRx, uartDataTx => s_uartDataTx
        );      
    r <= not s_write_read;
    w <= s_write_read;
    io  <= s_result_data when s_write_read = '0' else (others => 'Z');
    tx <= s_uartTX;
    s_uartRX <= rx;

end arch_ASM_scrub ;
