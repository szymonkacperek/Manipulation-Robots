%% LABORATORUM SRMan
% �WICZENIE 3 - Schemat sterowania z niezale�nymi regulatorami osi i
%               kompensacj� oddzia�ywania grawitacyjnego
% 
% Funkcja obliczaj�ca tau

%---- � NOTATKI
% 
function u = ZAD2_1_RxKm(input)

tauS = input(1:2);

global Km R

u = R * inv(Km) * tauS;
