%% LABORATORUM SRMan
% �WICZENIE 3 - Schemat sterowania z niezale�nymi regulatorami osi i
%               kompensacj� oddzia�ywania grawitacyjnego
% 
% Plik inicjalizacyjny

close all; clc; clear all

%---- � NOTATKI
% 27/05 Rozdziel sygna�y tak, kompletne uk�ady sterowania by�y dla ka�dej
%       osi osobno.
% 2/06  Rozdzielono. 
%% SEKCJA PARAMETR�W
%---- � PARAMETRY PR�BKOWANIA
tend = 30;
Tp = 0.1;
t = 0 :Tp: tend;
N = size(t,2);

%---- � PARAMETRY MANIPULATORA
global m1 I1 L1 b1 g m2 I2 L2 b2 fC1 fC2
% Parametry ramienia 0 - rysunek zob. plik PDF
L1 = 1.0;           % m
m1 = 5.0;           % kg
I1 = m1*L1^2/12;    % kg*m
b1 = 9.5;           % N*s/rad
fC1 = 0.2;          % N*m

% Parametry ramienia 1
L2 = 0.8;           % m
m2 = 3.0;           % kg
I2 = m2*L2^2/12;    % kg*m
b2 = 4.5;           % N*s/rad
fC2 = 0.1;          % N*m

% Przyspieszenie grawitacyjne
g = 9.81;           % m/s^2

% Wektory warunk�w pocz�tkowych - po�o�enie ogniw
initConditionsVel = [0; 0];
initConditionsPos = [-pi/2; 0];

%---- � PARAMETRY GENERATOR�W SYGNA��W REFERENCYJNCYCH      
% G1 (Generator sinusoidalny)
Qd0 = 0.1;
Qd1 = 1.2;      
Qd2 = 1.3;      
Qd3 = 0.4;
omega1 = 0.6;
omega2 = 0.7;

% G2 (Generator wielomianowy)
Qd01 = 0.65;
Qd11 = 0.75;
Qd21 = 0.70;
Qd31 = 0.45;

Qd02 = 0.65;
Qd12 = 0.78;
Qd22 = 0.98;
Qd32 = 0.90;

% G3 (Generator odcinkami sta�y)
Qd1const = 0.7;             % amplituda
Qd2const = 0.8;             % amplituda
Ta = 5;
Tb = Ta*1.8;
Ti = Ta+Tb;
Wi = Ta / (Ta+Tb);

% micha�ek
% Qd1 = 1.3;
wd1 = 0.05;
% Qd2 = 0.9;
wd2 = 0.075;

%% OBLICZENIA
%---- � Dokonuj� wymaganych oblicze� z danych motora dost�pnych w pliku 
%       KartaKatF2260.PDF. 

% Zamieniam na jednostki SI sta�� maszyny Km Torque Constant (Motor Data, p. 12)
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

%% ZADANIE 1.1
%---- � Zaimplementowa� rozszerzony model manipulatora PM2R zgodnie z r�wnaniem (10) i
%----   schematem z rys. 2 (pocz�tkowo przyj�� ?? = 0). Warto�ci parametr�w nap�d�w (w
%----   jednostkach SI) przyj�� na podstawie karty katalogowej wybranego silnika DC zinte-
%----   growanego z przek�adni� redukcyjn�. Nale�y pami�ta�, �e elementy bezw�adno�ciowe w
%----   macierzy M(q) powinny uwzgl�dnia� teraz mas� uk�adu wykonawczego i spos�b jego
%----   umieszczenia w manipulatorze.

%----   MODYFIKACJA OBLICZE�
% Zmiana postaci macierzy M oraz F w pliku ~\ZAD0_PROSTE_DYNAMIKI.m
% Elementy sta�e macierzy mas M
global Jl1 Jl2
Jl1 = m1*L1^2+I1+m2*L2^2+I2;
Jl2 = m2*L2^2+I2;

%----   DANE PRZEK�ADNI
% Prze�o�enie eta
global  eta1 eta2 eta
eta1 = 1/181;
eta2 = 1/181;
eta = diag([eta1; eta2]);   


%----   DANE SILNIK�W
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

%----   ZAK��CENIA
global tauDelta
% Wektor zak��ce� tauDelta
tauDelta = [0; 0];

%----   NAPI�CIE STERUJ�CE
U = [24.0; 24.0];                              % V

%% ZADANIE 2.1
%---- � Dla manipulatora PM2R zaimplementowa� zdecentralizowany sterownik PID+FF zgod-
%----   nie z r�wnaniami (13), (15), (17) i (20) � patrz rys. 3. Przeprowadzi� parametryczn� syn-
%----   tez� blok�w PID sterownika korzystaj�c z r�wna� (25) pami�taj�c o og�lnych zasadach
%----   projektowych (24). Sprawdzi� wp�yw warto�ci parametr�w ?n i ? na jako�� sterowania.
%----   Jak wygl�da�yby r�wnania syntezy przy zastosowaniu regulator�w typu PD?

%----   SYNTEZA REGULATOR�W
%----   Synteza regulatora FF
% Ogniwo nr 1
J1 = Jm1 + (eta1^2) * Jl1;
b1 = (eta1^2) *b1 + bm1 + (km1*kb1)/R1;
% Ogniwo nr 2
J2 = Jm2 + eta2^2*Jl2;
b2 = (eta2^2) *b2 + bm2 + (km2*kb2)/R2;

%----   Synteza regulatora PID
% Ogniwo nr 1
omega_n1 = 6.0;
zeta1 = 1.0;
lambda1 = 6.0;
kp1 = (omega_n1^2) * (1 + 2*lambda1*zeta1^2)*J1;
kd1 = omega_n1*zeta1*(2 + lambda1)*J1 - b1;
ki1 = (omega_n1^3) *lambda1*zeta1*J1;
% Ogniwo nr 2
omega_n2 = 6.0;
zeta2 = 1.0;
lambda2 = 4.0;
kp2 = (omega_n2^2) *(1 + 2*lambda2*zeta2^2)*J2;
kd2 = omega_n2*zeta2*(2 + lambda2)*J2 - b2;
ki2 = (omega_n2^3) * lambda2*zeta2*J2;

Kd = diag([kd1; kd2])
Kp = diag([kp1; kp2])
Ki = diag([ki1; ki2])

%----   Synteza regulatora AW
% Ogniwo nr 1
kc1 = 1 / sqrt(kd1 / ki1);
% Ogniwo nr 2
kc2 = 1 / sqrt(kd2 / ki2);

%% ZADANIE 3.1
%---- � Dla manipulatora PM2R zaimplementowa� cz�ciowo scentralizowany
%----   sterownik PID+FF+G zgodnie z r�wnaniami (30), (15), (17), (31) i (32) � 
%----   patrz rys. 6. Przeprowadzi� parametryczn� syntez� blok�w PID sterownika 
%----   korzystaj�c z r�wna� (25) pami�taj�c o og�lnych zasadach projektowych (24).
