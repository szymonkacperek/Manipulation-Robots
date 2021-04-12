%% LABORATORUM SRMan
% �WICZENIE 2 - Sterowanie z linearyzacj� sprz�eniem zwrotnym
% ZADANIE 1.1

%---- � MIEJSCE NA NOTATKI
% 
%% ZADANIE 1.1
%---- � Zaimplementowa� p�tl� wewn�trzn� (3) � por. rysunek 1 � zapewniaj�c� 
%----   dynamiczn� linearyzacj� i odsprz�ganie r�wnania (1) w ca�ej przestrzeni 
%----   roboczej manipulatora PM2R.

%---- Macierz M

function Mv = ZAD1_1_macierz_M(u)
global m1 I1 L1 m2 I2 L2
% Definicja wej��
q1 = u(1);
q2 = u(2);
q = [q1; q2];

v1 = u(3);
v2 = u(4);
v = [v1; v2];

% Wyznaczenie macierzy bezwladnosci manipulatora
M11 = m1*L1^2+I1+m2*L2^2+I2+4*m2*L1^2+4*m2*L1*L2*cos(q2);
M21 = m2*L2^2+I2+2*m2*L1*L2*cos(q2);
M12 = m2*L2^2+I2+2*m2*L1*L2*cos(q2);
M22 = m2*L2^2+I2;
M = [M11 M21; M12 M22];

% Odpowied� funkcji
Mv = M*v;