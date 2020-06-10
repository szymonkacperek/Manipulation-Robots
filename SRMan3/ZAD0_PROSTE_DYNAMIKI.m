%% LABORATORUM SRMan
% �WICZENIE 3 - Schemat sterowania z niezale�nymi regulatorami osi i kompensacj� oddzia�ywania grawitacyjnego
% ZADANIE 1.1

%---- � NOTATKI
% 
%% ZADANIE 1.1
%---- � Zaimplementowa� rozszerzony model manipulatora PM2R zgodnie z r�wnaniem (10) i
%----   schematem z rys. 2 (pocz�tkowo przyj�� ?? = 0). Warto�ci parametr�w nap�d�w (w
%----   jednostkach SI) przyj�� na podstawie karty katalogowej wybranego silnika DC zinte-
%----   growanego z przek�adni� redukcyjn�. Nale�y pami�ta�, �e elementy bezw�adno�ciowe w
%----   macierzy M(q) powinny uwzgl�dnia� teraz mas� uk�adu wykonawczego i spos�b jego
%----   umieszczenia w manipulatorze.

function qDotDot = ZAD0_PROSTE_DYNAMIKI(u)
global m1 I1 L1 b1 g m2 I2 L2 b2 fC1 fC2

% Definicja sygna��w wej�ciowych
tau1 = u(1);
tau2 = u(2);    
tau = [tau1; tau2];

q1 = u(3);
q2 = u(4);
q = [q1; q2];

q1_dot = u(5);
q2_dot = u(6);
qDot = [q1_dot; q2_dot];

% Wyznaczenie zmodyfikowanej macierzy bezwladnosci manipulatora M
global Jm1 Jm2 eta1 eta2 Jl1 Jl2
M11 = ((1/eta1^2)*Jm1+Jl1)+4*m2*L1^2+4*m2*L1*L2*cos(q2);
M21 = m2*L2^2+I2+2*m2*L1*L2*cos(q2);
M12 = m2*L2^2+I2+2*m2*L1*L2*cos(q2);
M22 = (1/eta2^2)*Jm2+Jl2;
M = [M11 M21; M12 M22];

% Wyznaczenie macierzy wspolczynnikow uogolnionych sil Coriolisa i odsrodkowych
C11 = -2*m2*L1*L2*q2_dot*sin(q2);
C21 = 2*m2*L1*L2*q1_dot*sin(q2);
C12 = -2*m2*L1*L2*(q1_dot+q2_dot)*sin(q2);
C22 = 0;
C = [C11 C21; C12 C22];

% Wyznaczenie wektora uogolnionych sil grawitacji
G11 = (m1*L1+2*m2*L1)*g*cos(q1)+m2*L2*g*cos(q1+q2);
G21 = m2*L2*g*cos(q1+q2);
G = [G11; G21];

% Wyznaczenie wektora uogolnionych sil tarcia
global bm1 bm2 km1 km2 R1 R2 kb1 kb2
F11 = fC1*sign(q1_dot) + (b1 + (1/eta1^2)*bm1 + (km1*kb1)/(eta1^2*R1)) * q1_dot;
F21 = fC2*sign(q2_dot) + (b2 + (1/eta2^2)*bm2 + (km2*kb2)/(eta2^2*R2)) * q2_dot;
F = [F11; F21];

% Odpowied� funkcji (wektor przyspiesze� w przegubach)
global tauDelta
h = C*qDot + G + F + tauDelta;

qDotDot = inv(M)*(tau-h);