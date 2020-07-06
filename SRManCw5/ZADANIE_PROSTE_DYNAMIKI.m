%% LABORATORUM SRMan
% �WICZENIE 2 - Sterowanie z linearyzacj� sprz�eniem zwrotnym
% ZADANIE 1.1

%---- � MIEJSCE NA NOTATKI
% 
%% ZADANIE 1.1
%---- � Zaimplementowa� p�tl� wewn�trzn� (3) � por. rysunek 1 � zapewniaj�c� 
%----   dynamiczn� linearyzacj� i odsprz�ganie r�wnania (1) w ca�ej przestrzeni 
%----   roboczej manipulatora PM2R.

function qDotDot = ZADANIE_PROSTE_DYNAMIKI(u)
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

% Wyznaczenie macierzy bezwladnosci manipulatora
M11 = m1*L1^2+I1+m2*L2^2+I2+4*m2*L1^2+4*m2*L1*L2*cos(q2);
M21 = m2*L2^2+I2+2*m2*L1*L2*cos(q2);
M12 = m2*L2^2+I2+2*m2*L1*L2*cos(q2);
M22 = m2*L2^2+I2;
global M
M = [M11 M21; M12 M22];

% Wyznaczenie macierzy wspolczynnikow uogolnionych sil Coriolisa i odsrodkowych
C11 = -2*m2*L1*L2*q2_dot*sin(q2);
C21 = 2*m2*L1*L2*q1_dot*sin(q2);
C12 = -2*m2*L1*L2*(q1_dot+q2_dot)*sin(q2);
C22 = 0;
global C
C = [C11 C21; C12 C22];

% Wyznaczenie wektora uogolnionych sil grawitacji
G11 = (m1*L1+2*m2*L1)*g*cos(q1)+m2*L2*g*cos(q1+q2);
G21 = m2*L2*g*cos(q1+q2);
global G
G = [G11; G21];

% Wyznaczenie wektora uogolnionych sil tarcia
%   Micha�ek zezwoli� na wyzerowanie wsp�czynnik�w zale�nych od tarcia
%   Coulomba.
F11 = b1*q1_dot;%+fC1*sign(q1_dot);
F21 = b2*q2_dot;%+fC2*sign(q2_dot);
global F
F = [F11; F21];

% Odpowied� funkcji (wektor przyspiesze� w przegubach)
h = C*qDot+G+F;
qDotDot = inv(M)*(tau-h);