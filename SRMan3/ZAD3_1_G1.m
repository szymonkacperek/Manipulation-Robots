%% LABORATORUM SRMan
% �WICZENIE 3 - Schemat sterowania z niezale�nymi regulatorami osi i
%               kompensacj� oddzia�ywania grawitacyjnego
% 
% Funkcja obliczaj�ca G1
%% ZADANIE 3.1
%---- � Dla manipulatora PM2R zaimplementowa� cz�ciowo scentralizowany
%----   sterownik PID+FF+G zgodnie z r�wnaniami (30), (15), (17), (31) i (32) � 
%----   patrz rys. 6. Przeprowadzi� parametryczn� syntez� blok�w PID sterownika 
%----   korzystaj�c z r�wna� (25) pami�taj�c o og�lnych zasadach projektowych (24).


%---- � NOTATKI
% 
function tau_G1 = ZAD3_1_G1(input)

q_m1 = input(1);
q_m2 = input(2);

global eta1 eta2 m1 m2 g L1 L2

tau_G1 = eta1*( (m1*L1 + 2*m2*L1)*g*cos(eta1*q_m1) + m2*L2*g*cos(eta1*q_m1 + eta2*q_m2) );
