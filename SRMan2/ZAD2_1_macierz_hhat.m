%% LABORATORUM SRMan
% �WICZENIE 2 - Sterowanie z linearyzacj� sprz�eniem zwrotnym
% ZADANIE 2.1

%---- � MIEJSCE NA NOTATKI
% 
%% ZADANIE 2.1
%---- � Wprowadzi� estymaty p? 6= p parametr�w dynamicznych manipulatora PM2R. 
%----   Dla przyj�tych estymat obliczy� macierze M? i h? wyst�puj�ce w r�wnaniach modelu (1). 
%----   Zamodelowa� p�tl� wewn�trzn� (10).

%---- Macierz h

function h = ZAD2_1_macierz_hhat(u)
global m1hat L1hat b1hat g m2hat L2hat b2hat fC1hat fC2hat
% Definicja wej��
q1Dot = u(1);
q2Dot = u(2);
qDot = [q1Dot; q2Dot];

q1 = u(3);
q2 = u(4);
q = [q1; q2];

% Wyznaczenie macierzy wspolczynnikow uogolnionych sil Coriolisa i odsrodkowych
C11 = -2*m2hat*L1hat*L2hat*q2Dot*sin(q2);
C21 = 2*m2hat*L1hat*L2hat*q1Dot*sin(q2);
C12 = -2*m2hat*L1hat*L2hat*(q1Dot+q2Dot)*sin(q2);
C22 = 0;
C = [C11 C21; C12 C22];

% Wyznaczenie wektora uogolnionych sil grawitacji
G11 = (m1hat*L1hat+2*m2hat*L1hat)*g*cos(q1)+m2hat*L2hat*g*cos(q1+q2);
G21 = m2hat*L2hat*g*cos(q1+q2);
G = [G11; G21];

% Wyznaczenie wektora uogolnionych sil tarcia
F11 = fC1hat*sign(q1Dot)+b1hat*q1Dot;
F21 = fC2hat*sign(q2Dot)+b2hat*q2Dot;
F = [F11; F21];

% Odpowied� funkcji (macierz h)
h = C*qDot+G+F;