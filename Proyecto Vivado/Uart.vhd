----------------------------------------------------------------------------
--	UART_TX_CTRL.vhd -- UART Data Transfer Component
----------------------------------------------------------------------------
-- Author:  Sam Bobrowicz
--          Copyright 2011 Digilent, Inc.
-- https://github.com/Digilent/Cmod-A7-35T-GPIO?_ga=2.8624054.2033129824.1591550998-679692057.1572889039
----------------------------------------------------------------------------
--
----------------------------------------------------------------------------
--	This component may be used to transfer data over a UART device. It will
-- serialize a byte of data and transmit it over a TXD line. The serialized
-- data has the following characteristics:
--         *9600 Baud Rate
--         *8 data bits, LSB first
--         *1 stop bit
--         *no parity
--         				
-- Port Descriptions:
--
--    SEND - Used to trigger a send operation. The upper layer logic should 
--           set this signal high for a single clock cycle to trigger a 
--           send. When this signal is set high DATA must be valid . Should 
--           not be asserted unless READY is high.
--    DATA - The parallel data to be sent. Must be valid the clock cycle
--           that SEND has gone high.
--    CLK  - A 100 MHz clock is expected
--   READY - This signal goes low once a send operation has begun and
--           remains low until it has completed and the module is ready to
--           send another byte.
-- UART_TX - This signal should be routed to the appropriate TX pin of the 
--           external UART device.
--   
----------------------------------------------------------------------------
--
----------------------------------------------------------------------------
-- Revision History:
--  08/08/2011(SamB): Created using Xilinx Tools 13.2
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Uart is
    Port ( CLK : in  std_logic;
           SEND : in  std_logic;
           RECV : in std_logic;
           DATA : in  std_logic_vector (7 downto 0);
           DATA_OUT : out  std_logic_vector (7 downto 0);
           READY : out  std_logic;
           UART_TX : out  std_logic;
           UART_RX: in  std_logic
);
end Uart;

architecture Behavioral of Uart is

type TX_RX_STATE_TYPE is (RDY, LOAD_BIT_TX, SEND_BIT, RECV_BIT, LOAD_BIT_RX);

constant BIT_TMR_MAX : std_logic_vector(13 downto 0) := "00010011100010"; --1250 = (round(12Mhz / 9600)) - 1
constant BIT_INDEX_MAX : natural := 10;

--Counter that keeps track of the number of clock cycles the current bit has been held stable over the
--UART TX line. It is used to signal when the ne
signal bitTmr : std_logic_vector(13 downto 0) := (others => '0');

--combinatorial logic that goes high when bitTmr has counted to the proper value to ensure
--a 9600 baud rate
signal bitDone : std_logic;

--Contains the index of the next bit in txData that needs to be transferred 
signal bitIndex : natural;

--a register that holds the current data being sent over the UART TX/RX line
signal txBit : std_logic := '1';
signal rxBit : std_logic := '0';

--A register that contains the whole data packet to be sent, including start and stop bits. 
signal txData : std_logic_vector(9 downto 0);
signal rxData : std_logic_vector(9 downto 0);

signal state : TX_RX_STATE_TYPE := RDY;

begin

--Next state logic
next_tx_rx_State_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		case state is 
		when RDY =>
			if (SEND = '1') then
				state <= LOAD_BIT_TX;
			elsif (RECV = '1') then
				state <= LOAD_BIT_RX;
			end if;
			
		when LOAD_BIT_TX =>
			state <= SEND_BIT;
	   
		when SEND_BIT =>
			if (bitDone = '1') then
				if (bitIndex = BIT_INDEX_MAX) then
					state <= RDY;
				else
					state <= LOAD_BIT_TX;
				end if;
			end if;
			
	    when LOAD_BIT_RX =>
			state <= RECV_BIT;
			   
		when RECV_BIT =>
			if (bitDone = '1') then
				if (bitIndex = BIT_INDEX_MAX) then
					state <= RDY;
				else
					state <= LOAD_BIT_RX;
				end if;
			end if;
			
		when others=> --should never be reached
			state <= RDY;
		end case;
	end if;
end process;

bit_timing_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		if (state = RDY) then
			bitTmr <= (others => '0');
		else
			if (bitDone = '1') then
				bitTmr <= (others => '0');
			else
				bitTmr <= bitTmr + 1;
			end if;
		end if;
	end if;
end process;

bitDone <= '1' when (bitTmr = BIT_TMR_MAX) else
				'0';

bit_counting_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		if (state = RDY) then
			bitIndex <= 0;
		elsif (state = LOAD_BIT_TX) then
			bitIndex <= bitIndex + 1;
	    elsif (state = LOAD_BIT_RX) then
			bitIndex <= bitIndex + 1;
		end if;
	end if;
end process;

tx_data_latch_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		if (SEND = '1') then
			txData <= '1' & DATA & '0';
		end if;
	end if;
end process;

rx_data_latch_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		if (state = RECV_BIT and bitDone = '1') then
			DATA_OUT <= rxData(8 downto 1);
		else 
		    DATA_OUT <= (others => '0');
		end if;
	end if;
end process;

tx_rx_bit_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		if (state = RDY) then
			txBit <= '1';
		elsif (state = LOAD_BIT_TX) then
			txBit <= txData(bitIndex);
		elsif (state = LOAD_BIT_RX) then
			rxData(bitIndex) <= rxBit;
		end if;
	end if;
end process;


UART_TX <= txBit;
rxBit <= UART_RX;

READY <= '1' when (state = RDY) else
			'0';

end Behavioral;

