%% LABORATORUM SRMan
% �WICZENIE 5 - Regulator adaptacyjny. Zbie�no�� estymat parametr�w modelu manipulatora
% 
% ZADANIE 2 - Plik inicjalizacyjny

close all; clc; clear all
 
%---- � NOTATKI
% 
%% 1   PARAMETRY
%% 1.1 PARAMETRY PR�BKOWANIA
tend = 30;
Tp = 0.1;
t = 0 :Tp: tend;
N = size(t,2);

%% 1.2 PARAMETRY MANIPULATORA
global m1 I1 L1 b1 g m2 I2 L2 b2 fC1 fC2
% Parametry ramienia 0 - rysunek zob. plik PDF
L1 = 1.0*0.5;           % m
m1 = 5.0;           % kg
I1 = m1*L1^2/12;    % kg*m
b1 = 9.5;           % N*s/rad
fC1 = 0.2;          % N*m

% Parametry ramienia 1
L2 = 0.8*0.4;           % m
m2 = 3.0*1.6;           % kg
I2 = m2*L2^2/12;    % kg*m
b2 = 4.5;           % N*s/rad
fC2 = 0.1;          % N*m

% Przyspieszenie grawitacyjne
g = 9.81;           % m/s^2

% Wektory warunk�w pocz�tkowych - po�o�enie ogniw
initConditionsVel = [0; 0];
initConditionsPos = [0; 0];

%% 1.6 PARAMETRY GENERATOR�W SYGNA��W REFERENCYJNCYCH      
% G1 (Generator sinusoidalny)
Qd0 = 1;
Qd1 = 1;      
Qd2 = 1;      
Qd3 = 1;
omega1 = 0.6;
omega2 = 0.7;

% G2 (Generator wielomianowy)
Qd01 = 0.0025;
Qd11 = 0.0020;
Qd21 = 0.0015;
Qd31 = 0.001;

Qd02 = 0.0025;
Qd12 = 0.002;
Qd22 = 0.0015;
Qd32 = 0.001;

% G3 (Generator odcinkami sta�y)
Qd1const = 1;             % amplituda
Qd2const = 1;             % amplituda
Ta = 5;
Tb = Ta*1.8;

%% 2    ZADANIA
%% (a)  ZADANIE 2.1 
%---- � Korzystaj�c z parametryzacji modelu manipulatora PM2R z �wiczenia 1, wyprowadzi�
%       posta� macierzy regresji z r�wnania (14) � elementy q�r i q�r wyst�puj�ce w tej macierzy
%       wynikaj� z postaci r�wnania (13).

% zobacz plik ./SRManCw5_ZADANIE1_PRAWO_ESTYMACJI.m

%% (b)  ZADANIE 2.2
%---- � Przyj�� pocz�tkowe warto�ci estymat parametr�w manipulatora phat != 0.

% Zmienn� wpisuj� w bloku ca�kuj�cym z subsystemu Simulink "PARAMETRY DYN."
phatInitConditions = [0.1 0.1 0.1 0.1 0.1 0.1 0.1];

%% (c)  ZADANIE 2.3
%---- � Zamodelowa� p�tl� regulacyjn� (13) � rys. 2. Warto�ci macierzy Kv i Lambda dobra� do�wiadczalnie
%       jako macierze sta�e w czasie.

Lambda = diag([800 800]);
Kv = diag([800 800]);

% Macierz wzmocnie�
global Gamma
Gamma = diag([100 100 100 100 100 100 100]);

%% (d)  ZADANIE 2.4
%---- � Zamodelowa� blok estymacji parametr�w (14) � rys. 2.

% zobacz ./SRManCw5_ZADANIE2_PRAWO_ESTYMACJI.m

%% (e)  ZADANIE 1.5
%---- � Przeprowadzi� symulacje uk�adu sterowania (7)+(8) z manipulatorem (1) dla nast�puj�cych
%       sygna��w zadanych: G1 i G2. Zapewni� niezerowe pocz�tkowe warto�ci b��d�w �ledzenia e0 != 0.
%       � Jak zachowuj� si� b��dy �ledzenia e(t)? Czy zmierzaj� asymptotycznie do zera?
%         Czy s� ograniczone w ca�ym horyzoncie sterowania? Jak zachowuj� si� b��dy pr�dko�ci e�(t)?
%       � Zbada� wp�yw warto�ci wsp�czynnik�w wzmocnienia ? bloku estymacji na szybko��
%         zmian warto�ci estymat ?p(t) w ca�ym horyzoncie czasowym sterowania. Czy
%         warto�ci estymat ?p(t) zmierzaj� do prawdziwych warto�ci parametr�w dynamicznych
%         p manipulatora?