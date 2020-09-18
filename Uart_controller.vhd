library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity Uart_controller is
    port ( clk, reset, tc, rx, uartRdy : in std_logic;
    uartRecv, uartSend, tx: out std_logic;
    uartDataRx : in std_logic_vector (7 downto 0);
    uartDataTx : out std_logic_vector (7 downto 0);
    control_freq: out std_logic_vector(3 downto 0);
    bcd_error, bcd_mcu: in std_logic_vector(27 downto 0);
    bcd_cycles: in std_logic_vector(31 downto 0);
    bcd_freq: in std_logic_vector(39 downto 0)
    );
end Uart_controller;

architecture Behavioral of Uart_controller is
    type UART_STATE_TYPE is (N_DATA, INIT_PARSE, INIT_SEL, PARSE, INDEX, 
        WAIT_PARSE, RECV_CHAR_RX, WAIT_RDY_RX,
        LD_INIT_STR_TX, SEND_CHAR_TX, RDY_LOW_TX, WAIT_RDY_TX, WAIT_FREQ,
        START,FREQ_RDY
        ); 
    signal uartState : UART_STATE_TYPE := START;
    signal s_control_freq:	std_logic_vector(3	downto	0);
    alias load_count_freq : std_logic is s_control_freq(0);
    alias op : std_logic is s_control_freq(1);
    alias load_register_freq: std_logic is s_control_freq(2);
    alias np : std_logic is s_control_freq(3);
    
    signal s_intEnd : natural;
    signal s_intEndParse : natural;
    signal s_intIndex : natural; 
    signal s_intIndexParse : natural;

    signal s_reset_data: std_logic:= '0';
    signal s_turn: std_logic_vector(2 downto 0):= "000";
    signal s_keep_tc: std_logic:= '0';
    signal DATA_STR: CHAR_ARRAY(0 to N_MCU_STR-1):= (others=>X"30");
    signal s_sel: std_logic_vector(3 downto 0);
begin
    control_freq <= s_control_freq;
    keep_tc: process(clk,reset)
    begin
        if reset = '1' then
            s_keep_tc <= '0';
        else
            if (tc = '1') then
                s_keep_tc <= '1';
            end if;
            if (uartState = N_DATA and s_turn = "100") then
                s_keep_tc <= '0';
            end if;
        end if;
    end process;

    next_uartState : process (clk,reset)
    begin
        if reset = '1' then
            s_reset_data <= '0';
            uartState <= START;
            load_count_freq <= '1';
            load_register_freq <= '1';
        elsif (rising_edge(clk)) then
            case uartState is
                when START =>
                    load_count_freq <= '1';
                    load_register_freq <= '1';
                    s_reset_data <= '0';
                    if(rx = '0') then
                     uartstate <= RECV_CHAR_RX;
                    elsif(s_keep_tc = '1') then
                        s_turn <= "000";
                        uartState <= N_DATA;
                    else
                        uartState <= START;
                    end if;
                --string ciclos
                when N_DATA =>
                    s_reset_data <= '0';
                    uartState <= LD_INIT_STR_TX;
                --parseo
                when INIT_PARSE =>
                    s_reset_data <= '0';
                    uartState <= INIT_SEL;
                when INIT_SEL =>
                    uartState <= PARSE;
                when PARSE =>
                    uartState <= INDEX;
                when INDEX =>
                    uartState <= WAIT_PARSE;
                when WAIT_PARSE => 
                    if(s_intEnd = s_intIndexParse) then
                        uartState <= LD_INIT_STR_TX;
                    else
                        uartState <= INIT_SEL;
                    end if;      
                when LD_INIT_STR_TX =>
                    uartState <= SEND_CHAR_TX;
                when SEND_CHAR_TX =>
                    uartState <= RDY_LOW_TX;
                when RDY_LOW_TX =>
                    uartState <= WAIT_RDY_TX;
                when WAIT_RDY_TX =>
                    if (uartRdy = '1') then
                        if(s_intEnd = s_intIndex) then
                            s_reset_data <= '1';
                            if(s_turn = "000") then
                                s_turn <= "001";
                                uartState <= INIT_PARSE;
                            elsif(s_turn = "001") then
                                s_turn <= "010";
                                uartState <= N_DATA;
                            elsif(s_turn = "010") then
                                s_turn <= "011";
                                uartState <= INIT_PARSE;
                            elsif(s_turn = "011") then
                                s_turn <= "100";
                                uartState <= N_DATA;
                            elsif(s_turn = "100") then
                                s_turn <= "101";
                                uartState <= INIT_PARSE;
                            elsif(s_turn = "101") then
                                s_turn <= "110";
                                uartState <= N_DATA;
                            elsif(s_turn = "110") then
                                s_turn <= "111";
                                uartState <= INIT_PARSE;
                            elsif(s_turn = "111") then
                                s_turn <= "000";
                                uartState <= START;
                            else
                                uartState <= START;
                            end if;
                        else
                            s_reset_data <= '0';
                            uartState <= SEND_CHAR_TX;
                        end if;
                    end if;
                 --recepción uart
                 when RECV_CHAR_RX =>
                    uartState <= WAIT_RDY_RX;
                when WAIT_RDY_RX =>
                    if(uartRdy = '1') then
                        uartState <= WAIT_FREQ;
                        load_count_freq <= '0';
                    else
                       uartState <= WAIT_RDY_RX;
                     end if;
                when WAIT_FREQ =>
                    load_count_freq <= '1';
                    load_register_freq <= '0';
                    uartState <= FREQ_RDY;  
                when FREQ_RDY =>
                    load_register_freq <= '1';
                    s_turn <= "000";
                    uartState <= START; 
                when others=> --should never be reached
                uartState <= START;
            end case;            
        end if;
    end process;
            	    
    count_parse : process (clk)
    begin
        if (rising_edge(clk)) then
            --INDEX para el parseo
            if (uartState = INIT_PARSE) then
                s_intIndexParse <= 0;
                case s_turn is
                    when "001" => 
                        s_intEnd <= N_CYCLES_INT;
                    when "011" => 
                        s_intEnd <= N_FAILURES_INT;
                    when "101" => 
                         s_intEnd <= N_FAILURES_INT;
                    when "111" => 
                         s_intEnd <= N_FREQUENCY_INT;
                    when others =>
                        s_intEnd <= 0;
                end case;   
            elsif (uartState = INDEX) then 
                s_intIndexParse <= s_intIndexParse + 1;
            end if;
            if (uartState = N_DATA) then
                case s_turn is
                    when "000" => 
                        s_intEnd <= N_CYCLES_STR;
                    when "010" => 
                        s_intEnd <= N_ERROR_STR;
                    when "100" => 
                         s_intEnd <= N_MCU_STR;
                    when "110" => 
                         s_intEnd <= N_FREQUENCY_STR;
                    when others =>
                        s_intEnd <= 0;
                end case;        
            end if;		
            --INDEX para enviar datos a la UART
            if (uartState = LD_INIT_STR_TX) then
                s_intIndex <= 0;
            elsif (uartState = SEND_CHAR_TX) then
                s_intIndex <= s_intIndex + 1;
            end if;
        end if;
    end process;

    parse_BCD:	process(clk)
    begin
        if (rising_edge(clk)) then
            --Resetea el contenido de DATA_STR
            if(s_reset_data = '1') then
                DATA_STR <= (others=>X"30");
            end if;
            --Carga la informacion en DATA_STR parseada
            if (uartState = PARSE) then
                if (s_intIndexParse = s_intEnd-1) then --Mete un salto de linea
                    DATA_STR(s_intEnd-1) <= X"0A";
                else
                    DATA_STR(s_intIndexParse) <= X"3" & s_sel;
         
                end if;
            end if;
            --Carga la informacion en DATA_STR del string de ciclos
            if(uartState = N_DATA) then
                case s_turn is
                    when "000" => 
                        DATA_STR(0 to N_CYCLES_STR-1) <= CYCLES_STR;
                    when "010" => 
                        DATA_STR(0 to N_ERROR_STR-1) <= ERROR_STR;
                    when "100" => 
                         DATA_STR(0 to N_MCU_STR-1) <= MCU_STR;
                    when "110" => 
                         DATA_STR(0 to N_FREQUENCY_STR-1) <= FREQUENCY_STR;
                    when others =>
                        DATA_STR <= DATA_STR;
                end case;  
            end if;
        end if;
    end process;
	    
    sel_parse_BCD:	process(clk)
    begin
        if (rising_edge(clk)) then
            if (uartState = INIT_SEL) then
                case s_turn is
                    when "001" => 
                         case s_intIndexParse is
                            when 0 => 
                                s_sel <= bcd_cycles(31 downto 28);
                            when 1 => 
                                s_sel <= bcd_cycles(27 downto 24);
                            when 2 => 
                                s_sel <= bcd_cycles(23 downto 20);
                            when 3 => 
                                s_sel <= bcd_cycles(19 downto 16);
                            when 4 => 
                                s_sel <= bcd_cycles(15 downto 12);
                            when 5 => 
                                s_sel <= bcd_cycles(11 downto 8);
                            when 6 => 
                                s_sel <= bcd_cycles(7 downto 4);
                            when 7 => 
                                s_sel <= bcd_cycles(3 downto 0);
                            when others =>
                                s_sel <= "1111";
                        end case; 
                    when "011" => 
                        case s_intIndexParse is
                            when 0 => 
                                s_sel <= bcd_error(27 downto 24);
                            when 1 => 
                                s_sel <= bcd_error(23 downto 20);
                            when 2 => 
                                s_sel <= bcd_error(19 downto 16);
                            when 3 => 
                                s_sel <= bcd_error(15 downto 12);
                            when 4 => 
                                s_sel <= bcd_error(11 downto 8);
                            when 5 => 
                                s_sel <= bcd_error(7 downto 4);
                            when 6 => 
                                s_sel <= bcd_error(3 downto 0);
                            when others =>
                                s_sel <= "1111";
                        end case; 
                    when "101" => 
                         case s_intIndexParse is
                            when 0 => 
                                s_sel <= bcd_mcu(27 downto 24);
                            when 1 => 
                                s_sel <= bcd_mcu(23 downto 20);
                            when 2 => 
                                s_sel <= bcd_mcu(19 downto 16);
                            when 3 => 
                                s_sel <= bcd_mcu(15 downto 12);
                            when 4 => 
                                s_sel <= bcd_mcu(11 downto 8);
                            when 5 => 
                                s_sel <= bcd_mcu(7 downto 4);
                            when 6 => 
                                s_sel <= bcd_mcu(3 downto 0);
                            when others =>
                                s_sel <= "1111";
                        end case; 
                    when "111" => 
                         case s_intIndexParse is
                            when 0 => 
                                s_sel <= bcd_freq(39 downto 36);
                            when 1 => 
                                s_sel <= bcd_freq(35 downto 32);
                            when 2 => 
                                s_sel <= bcd_freq(31 downto 28);
                            when 3 => 
                                s_sel <= bcd_freq(27 downto 24);
                            when 4 => 
                                s_sel <= bcd_freq(23 downto 20);
                            when 5 => 
                                s_sel <= bcd_freq(19 downto 16);
                            when 6 => 
                                s_sel <= bcd_freq(15 downto 12);
                            when 7 => 
                                s_sel <= bcd_freq(11 downto 8);
                            when 8 => 
                                s_sel <= bcd_freq(7 downto 4);
                            when 9 => 
                                s_sel <= bcd_freq(3 downto 0);
                            when others =>
                                s_sel <= "1111";
                        end case; 
                    when others =>   
                end case;
            end if;
        end if;
    end process;

    send_char_uart : process (clk)
    begin
        if (rising_edge(clk)) then
            if (uartState = SEND_CHAR_TX) then
                uartSend <= '1';
                uartDataTx <= DATA_STR(s_intIndex);
            else
                uartSend <= '0';
            end if;
        end if;
    end process;   
    
    recv_char_uart : process (clk)
    begin
        if (rising_edge(clk)) then
            if (uartState = RECV_CHAR_RX) then
                uartRecv <= '1';
            else
                uartRecv <= '0';
            end if;
            if (uartState = WAIT_RDY_RX and uartRdy = '1') then
            -- op = 0 => +
            -- op = 1 => - 
                if(uartDataRx = X"2B") then
                    op <= '0';
                    np <= '0';
                elsif(uartDataRx = X"2D") then
                    op <= '1';
                    np <= '0';
                else
                    np <= '1';  
                end if;
            end if;
        end if;
    end process;
end Behavioral;
