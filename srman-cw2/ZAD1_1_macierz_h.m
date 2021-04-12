%% LABORATORUM SRMan
% �WICZENIE 2 - Sterowanie z linearyzacj� sprz�eniem zwrotnym
% ZADANIE 1.1

%---- � MIEJSCE NA NOTATKI
% 
%% ZADANIE 1.1
%---- � Zaimplementowa� p�tl� wewn�trzn� (3) � por. rysunek 1 � zapewniaj�c� 
%----   dynamiczn� linearyzacj� i odsprz�ganie r�wnania (1) w ca�ej przestrzeni 
%----   roboczej manipulatora PM2R.

%---- Macierz h

function h = ZAD1_1_macierz_h(u)
global m1 I1 L1 b1 g m2 I2 L2 b2 fC1 fC2
% Definicja wej��
q1Dot = u(1);
q2Dot = u(2);
qDot = [q1Dot; q2Dot];

q1 = u(3);
q2 = u(4);
q = [q1; q2];

% Wyznaczenie macierzy wspolczynnikow uogolnionych sil Coriolisa i odsrodkowych
C11 = -2*m2*L1*L2*q2Dot*sin(q2);
C21 = 2*m2*L1*L2*q1Dot*sin(q2);
C12 = -2*m2*L1*L2*(q1Dot+q2Dot)*sin(q2);
C22 = 0;
C = [C11 C21; C12 C22];

% Wyznaczenie wektora uogolnionych sil grawitacji
G11 = (m1*L1+2*m2*L1)*g*cos(q1)+m2*L2*g*cos(q1+q2);
G21 = m2*L2*g*cos(q1+q2);
G = [G11; G21];

% Wyznaczenie wektora uogolnionych sil tarcia
F11 = fC1*sign(q1Dot)+b1*q1Dot;
F21 = fC2*sign(q2Dot)+b2*q2Dot;
F = [F11; F21];

% Odpowied� funkcji (macierz h)
h = C*qDot+G+F;