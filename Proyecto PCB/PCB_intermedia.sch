EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "RGB 2019/2020"
Date "2020-07-15"
Rev ""
Comp "Universidad Complutense de Madrid"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Device:CP C1
U 1 1 5F040746
P 6300 5600
F 0 "C1" V 6555 5600 50  0000 C CNB
F 1 "10uF" V 6464 5600 50  0000 C CNB
F 2 "Capacitor_THT:C_Radial_D4.0mm_H5.0mm_P1.50mm" H 6338 5450 50  0001 C CNN
F 3 "~" H 6300 5600 50  0001 C CNN
	1    6300 5600
	0    -1   -1   0   
$EndComp
Connection ~ 6150 5600
Wire Wire Line
	6150 5600 6200 5600
Wire Wire Line
	6400 5600 6450 5600
Connection ~ 6450 5600
Wire Wire Line
	6450 5600 6700 5600
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5F07F5A2
P 6700 5600
F 0 "#FLG0101" H 6700 5675 50  0001 C CNN
F 1 "PWR_FLAG" H 6700 5773 50  0000 C CNN
F 2 "" H 6700 5600 50  0001 C CNN
F 3 "~" H 6700 5600 50  0001 C CNN
	1    6700 5600
	1    0    0    -1  
$EndComp
NoConn ~ 4400 4500
NoConn ~ 4400 4600
NoConn ~ 4400 4700
NoConn ~ 4400 4800
NoConn ~ 4400 4900
$Comp
L Connector:Conn_01x24_Female J2
U 1 1 5F03DF61
P 4200 3900
F 0 "J2" H 4100 2500 50  0000 C CNB
F 1 "Conn_01x24_Female" H 3900 5100 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x24_P2.54mm_Vertical" H 4200 3900 50  0001 C CNN
F 3 "~" H 4200 3900 50  0001 C CNN
	1    4200 3900
	-1   0    0    1   
$EndComp
Text Label 3000 2700 0    50   ~ 10
O0
Text Label 3000 2800 0    50   ~ 10
O2
Text Label 3000 3000 0    50   ~ 10
O6
Text Label 3000 3100 0    50   ~ 10
A0
Text Label 3000 3200 0    50   ~ 10
A2
Text Label 3000 3300 0    50   ~ 10
A4
Text Label 3000 3400 0    50   ~ 10
A6
Text Label 3000 3500 0    50   ~ 10
A8
Text Label 3000 3600 0    50   ~ 10
A10
Text Label 3000 3700 0    50   ~ 10
A12
Text Label 3000 3800 0    50   ~ 10
A14
Text Label 3000 3900 0    50   ~ 10
A16
Text Label 3000 4000 0    50   ~ 10
A18
Text Label 3000 4300 0    50   ~ 10
A20
Text Label 3000 4400 0    50   ~ 10
A22
Text Label 3000 5000 0    50   ~ 10
Vcc
Wire Wire Line
	3200 3500 3000 3500
Wire Wire Line
	3200 3400 3000 3400
Wire Wire Line
	3200 3300 3000 3300
Wire Wire Line
	3200 3200 3000 3200
Wire Wire Line
	3200 3100 3000 3100
Wire Wire Line
	3200 3000 3000 3000
Wire Wire Line
	3200 5000 3000 5000
NoConn ~ 3200 4900
NoConn ~ 3200 4800
NoConn ~ 3200 4700
NoConn ~ 3200 4600
Wire Wire Line
	3200 2800 3000 2800
NoConn ~ 3200 4500
Wire Wire Line
	3200 4400 3000 4400
Wire Wire Line
	3200 4300 3000 4300
NoConn ~ 3200 4200
NoConn ~ 3200 4100
Wire Wire Line
	3200 4000 3000 4000
Wire Wire Line
	3200 3900 3000 3900
Wire Wire Line
	3200 3800 3000 3800
Wire Wire Line
	3200 3700 3000 3700
Wire Wire Line
	3200 3600 3000 3600
Wire Wire Line
	3200 2700 3000 2700
$Comp
L Connector:Conn_01x24_Female J1
U 1 1 5F03A47B
P 3400 3800
F 0 "J1" H 3300 5100 50  0000 L CNB
F 1 "Conn_01x24_Female" H 3000 2500 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x24_P2.54mm_Vertical" H 3400 3800 50  0001 C CNN
F 3 "~" H 3400 3800 50  0001 C CNN
	1    3400 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 2900 3000 2900
Text Label 3000 2900 0    50   ~ 10
O4
Wire Wire Line
	4400 5000 4600 5000
Wire Wire Line
	4400 4400 4600 4400
Wire Wire Line
	4400 4300 4600 4300
Wire Wire Line
	4400 4200 4600 4200
Wire Wire Line
	4400 4100 4600 4100
Wire Wire Line
	4400 4000 4600 4000
Wire Wire Line
	4400 3900 4600 3900
Wire Wire Line
	4400 3800 4600 3800
Wire Wire Line
	4400 3700 4600 3700
Wire Wire Line
	4400 3600 4600 3600
Wire Wire Line
	4400 3500 4600 3500
Wire Wire Line
	4400 3400 4600 3400
Wire Wire Line
	4400 3300 4600 3300
Wire Wire Line
	4400 3200 4600 3200
Wire Wire Line
	4400 3100 4600 3100
Wire Wire Line
	4400 3000 4600 3000
Wire Wire Line
	4400 2900 4600 2900
Wire Wire Line
	4400 2800 4600 2800
Wire Wire Line
	4400 2700 4600 2700
Text Label 4600 5000 2    50   ~ 10
GND
Wire Wire Line
	6700 5600 7200 5600
Connection ~ 6700 5600
Text Label 7200 5600 2    50   ~ 10
GND
Wire Wire Line
	5700 5600 6150 5600
Text Label 5700 5600 0    50   ~ 10
Vcc
Text Label 4600 4400 2    50   ~ 10
OEN
Text Label 4600 4300 2    50   ~ 10
WEN
Text Label 4600 4200 2    50   ~ 10
EN00
Text Label 4600 4100 2    50   ~ 10
A21
Text Label 4600 4000 2    50   ~ 10
A19
Text Label 4600 3900 2    50   ~ 10
A17
Text Label 4600 3800 2    50   ~ 10
A15
Text Label 4600 3700 2    50   ~ 10
A13
Text Label 4600 3600 2    50   ~ 10
A11
Text Label 4600 3500 2    50   ~ 10
A9
Text Label 4600 3400 2    50   ~ 10
A7
Text Label 4600 3300 2    50   ~ 10
A5
Text Label 4600 3200 2    50   ~ 10
A3
Text Label 4600 3100 2    50   ~ 10
A1
Text Label 4600 3000 2    50   ~ 10
O7
Text Label 4600 2900 2    50   ~ 10
O5
Text Label 4600 2800 2    50   ~ 10
O3
Text Label 4600 2700 2    50   ~ 10
O1
Text Label 6300 4600 0    50   ~ 10
O1
Wire Wire Line
	6500 4600 6300 4600
$Comp
L Connector_Generic:Conn_02x18_Odd_Even J3
U 1 1 5F030D9B
P 6800 3700
F 0 "J3" H 6850 4717 50  0000 C CNB
F 1 "Conn_02x18_Odd_Even" H 6900 4800 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x18_P2.54mm_Vertical" H 6800 3700 50  0001 C CNN
F 3 "~" H 6800 3700 50  0001 C CNN
	1    6800 3700
	-1   0    0    -1  
$EndComp
Wire Wire Line
	7000 4600 7200 4600
Wire Wire Line
	7000 4500 7200 4500
Wire Wire Line
	7000 4400 7200 4400
Wire Wire Line
	7000 4300 7200 4300
Wire Wire Line
	7000 4200 7200 4200
Wire Wire Line
	7000 4100 7200 4100
Wire Wire Line
	7000 4000 7200 4000
Wire Wire Line
	7000 3900 7200 3900
Wire Wire Line
	7000 3800 7200 3800
Wire Wire Line
	7000 3700 7200 3700
Wire Wire Line
	7000 3600 7200 3600
Wire Wire Line
	7000 3500 7200 3500
Wire Wire Line
	7000 3400 7200 3400
Wire Wire Line
	7000 3300 7200 3300
Wire Wire Line
	7000 3200 7200 3200
Wire Wire Line
	7000 3100 7200 3100
Wire Wire Line
	7000 3000 7200 3000
Wire Wire Line
	7000 2900 7200 2900
Wire Wire Line
	6500 2900 6300 2900
Wire Wire Line
	6500 3000 6300 3000
Wire Wire Line
	6500 3100 6300 3100
Wire Wire Line
	6500 3200 6300 3200
Wire Wire Line
	6500 3300 6300 3300
Wire Wire Line
	6500 3400 6300 3400
Wire Wire Line
	6500 3500 6300 3500
Wire Wire Line
	6500 3600 6300 3600
Wire Wire Line
	6500 3700 6300 3700
Wire Wire Line
	6500 3800 6300 3800
Wire Wire Line
	6500 3900 6300 3900
Wire Wire Line
	6500 4000 6300 4000
Wire Wire Line
	6500 4100 6300 4100
Wire Wire Line
	6500 4200 6300 4200
Wire Wire Line
	6500 4300 6300 4300
Wire Wire Line
	6500 4400 6300 4400
Wire Wire Line
	6500 4500 6300 4500
Text Label 6300 4500 0    50   ~ 10
O3
Text Label 6300 4400 0    50   ~ 10
O5
Text Label 6300 4300 0    50   ~ 10
O7
Text Label 6300 4200 0    50   ~ 10
A1
Text Label 6300 4100 0    50   ~ 10
A3
Text Label 6300 4000 0    50   ~ 10
A5
Text Label 6300 3900 0    50   ~ 10
A7
Text Label 6300 3800 0    50   ~ 10
A9
Text Label 6300 3700 0    50   ~ 10
A11
Text Label 6300 3600 0    50   ~ 10
A13
Text Label 6300 3500 0    50   ~ 10
A15
Text Label 6300 3400 0    50   ~ 10
A17
Text Label 6300 3300 0    50   ~ 10
A19
Text Label 6300 3200 0    50   ~ 10
A21
Text Label 6300 3100 0    50   ~ 10
EN00
Text Label 6300 3000 0    50   ~ 10
WEN
Text Label 6300 2900 0    50   ~ 10
OEN
Text Label 7200 4600 2    50   ~ 10
O0
Text Label 7200 4500 2    50   ~ 10
O2
Text Label 7200 4400 2    50   ~ 10
O4
Text Label 7200 4300 2    50   ~ 10
O6
Text Label 7200 4200 2    50   ~ 10
A0
Text Label 7200 4100 2    50   ~ 10
A2
Text Label 7200 4000 2    50   ~ 10
A4
Text Label 7200 3900 2    50   ~ 10
A6
Text Label 7200 3800 2    50   ~ 10
A8
Text Label 7200 3700 2    50   ~ 10
A10
Text Label 7200 3600 2    50   ~ 10
A12
Text Label 7200 3500 2    50   ~ 10
A14
Text Label 7200 3400 2    50   ~ 10
A16
Text Label 7200 3300 2    50   ~ 10
A18
Text Label 7200 3200 2    50   ~ 10
A20
Text Label 7200 3100 2    50   ~ 10
A22
Text Label 7200 3000 2    50   ~ 10
GND
Text Label 7200 2900 2    50   ~ 10
Vcc
$EndSCHEMATC
