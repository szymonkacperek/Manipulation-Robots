%% LABORATORUM SRMan
% �WICZENIE 4 - Jako�� sterowania z regulatorem ROOS dla dw�ch rodzaj�w ograniczonych
%               podprzestrzeni sterowa�: hiperkuli i hiperprostopad�o�cianu
% 
% Plik inicjalizacyjny

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
L1 = 1.0*0.9;           % m
m1 = 5.0;           % kg
I1 = m1*L1^2/12;    % kg*m
b1 = 9.5;           % N*s/rad
fC1 = 0.2;          % N*m

% Parametry ramienia 1
L2 = 0.8*0.9;           % m
m2 = 3.0*1.1;           % kg
I2 = m2*L2^2/12;    % kg*m
b2 = 4.5;           % N*s/rad
fC2 = 0.1;          % N*m

% Przyspieszenie grawitacyjne
g = 9.81;           % m/s^2

% Wektory warunk�w pocz�tkowych - po�o�enie ogniw
initConditionsVel = [0; 0];
initConditionsPos = [0; 0];

%% 1.3 OBLICZENIA
%---- � Dokonuj� wymaganych oblicze� z danych motora dost�pnych w pliku 
%       KartaKatF2260.PDF. 
% Zamieniam na jednostki SI sta�� maszyny Km Torque Constant (Motor Data, 883, p. 12)
%       Sta�a ta odpowiada za generowany moment na wale silnika. Zale�na jest
%       od pr�du wg wzoru: tauM = Km * i (5).
torqueConstnonSI = 78.2;                    % mNm/A
km = torqueConstnonSI * 0.001;              % Nm/A

% Zamieniam na jednostki SI sta�� maszyny Kb Speed Constant (Motor Data, p. 13)
%       Sta�a ta ma swoje odzwierciedlenie w rozliczeniu napi�� panuj�cych
%       w silniku wg wzoru: u = R*i + Kb*qmDot (4).
speedConstNonSI = 122;                      % rpm/V
speedConst = speedConstNonSI * (pi/30);     % rad/(V*s)

% Warto�ci Km i Kb s� ze sob� skorelowane. �eby je por�wna�, nale�y
% odwr�ci� sta�� speedConst i otrzymamy kb.
kb = speedConst^-1;

%---- � Wyliczam wsp�czynniki potrzebne do r�wnania moment�w silnika (3) z
%       notatek.

% No load speed, current 
%       S� to warto�ci dla silnika bez obci��enia.
nlSpeedNonSI = 2840;                        % rpm       p. (2), dok.
qdotm = nlSpeedNonSI * (pi/30);             % rad/s     

nlCurrentNonSI = 226;                       % mA        p. (3), dok.
i0 = nlCurrentNonSI * 0.001;                % A

% Wsp�czynnik b_m (wz�r (6), notatki)
bm = km*i0/qdotm;      

% Wyliczam sta�� czasow� inercji Tm
%       Jest to Mechanical time constant (punkt (15), dokumentacja)
rotorInertiaNonSI = 1300;                   % g*cm^2,   p. (16), dok.
Jm = rotorInertiaNonSI * 0.0000001;         % kg*m^2
R = 0.917;                                  % ohm,      p. (10), dok.
Tm = (Jm*R) / (km*kb+R*bm);                 % s

% Wyznaczam wzmocnienie statyczne K
K = km / (km*kb+R*bm);   

% Elementy sta�e macierzy mas M
global Jl1 Jl2
Jl1 = m1*L1^2+I1+m2*L2^2+I2;
Jl2 = m2*L2^2+I2;

%% 1.4 PARAMETRY PRZEK�ADNI
% Prze�o�enie eta
global  eta1 eta2 eta
eta1 = 1/181;
eta2 = 1/181;
eta = diag([eta1; eta2]);   


%% 1.5 PARAMETRY SILNIK�W
% Sta�e maszyny km, kb, bm
global km1 km2 kb1 kb2 bm1 bm2 R1 R2 Km R Jm1 Jm2

%----   Dane silnika nr 1 - przymocowanego do �ciany
km1 = km;
kb1 = kb;
bm1 = bm;
R1 = R;
Jm1 = Jm;       % Moment bezw�adno�ci rotora
%----   Dane silnika nr 2 - przymocowanego do ogniwa
km2 = km;
kb2 = kb;
bm2 = bm;
R2 = R;
Jm2 = Jm;       % Moment bezw�adno�ci rotora
%----   Macierze
Km = diag([km1; km2]);
R = diag([R1; R2]);
invR = inv(R);

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
%---- � Przyj�� jednakowe ograniczenia moment�w nap�dowych dla obu silnik�w manipulatora
%       PM2R

% Ustalam ograniczenia napi�ciowe

global umax u1max u2max
u1max = 24; 
u2max = u1max*0.5;
umax = diag([u1max; u2max]);

%% (b)  ZADANIE 2.2
%---- � Zamodelowa� r�wnanie regulatora ROOS z (11) i zastosowa� j� do manipulatora (1).
%       Zapewni� mo�liwo�� swobodnej zmiany warto�ci zak�adanego tunelu ?.Warto�ci element�w
%       macierzy  dobra� do�wiadczalnie tak, aby zapewni� minimalne przeregulowania w
%       przebiegu b��du pozycji e(t).

% zobacz ~\SRManL4_ZADANIE1_ROOS.m

%---- USTALENIE TUNELU
global epsilon
epsilon = 0.9;

%---- STROJENIE REGULATORA
% uchyb e
lambda1 = 2.3;
lambda2 = 2.2;
Lambda = diag([lambda1 lambda2]);

% pochodna uchybu e'
d1 = 0.05;
d2 = 0.05;
D = diag([d1 d2]);
    