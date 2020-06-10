%% LABORATORUM SRMan
% �WICZENIE 1 - Model manipulatora PM2R. Zadanie proste i odwrotne dynamiki
% ZADANIE 2

%---- � MIEJSCE NA NOTATKI
% 27/04 Mo�na odpali� animacj� ruchu robota za pomoc� skryptu
%       ~/PM2Ranimation.m
% 
% 27/04 W blokach ca�kuj�cych nale�y ustawi� waruki 'Initial Conditions' na
%       zmienne initConditions, �eby model Simulink poprawnie dzia�a�.
% 
%%
close all; clc; clear all

%% Parametry pr�bkowania
tend = 20;
Tp = 0.01;
t = 0 :Tp: (tend-Tp);
N = size(t,2);

%% ZADANIE 2.1a, 2.1b
%---- � Zamodelowa� nast�puj�ce generatory moment�w nap�dowych (i = 1, 2) G4, G5:
%---- � G4: generator moment�w sinusoidalnych:

global omega
omega = 5.0;
tauM1 = 3.0;
tauM2 = 4.0;

%---- � G5: generator moment�w odcinkami sta�ych (rysunek 5): ?i(t) jako sygna� prostok�tny
%----   o zmiennej amplitudzie ?mi, zmiennym okresie Ti = Ta + Tb i zmiennym wype�nieniu Wi = Ta/(Ta+Tb):

Ta = 1;
Tb = 2*Ta;
Ti = Ta+Tb;
Wi = Ta / (Ta+Tb);

%% ZADANIE 2.2
%---- � Rozwi�za� zadanie proste dynamiki manipulatora PM2R na podstawie modelu (4) dla
%----   moment�w zadanych z generator�w G4-G5 (dla r�nych warto�ci parametr�w ka�dego
%----   rodzaju sygna�u).

%----   Realizacja: zobacz plik ~/ZAD2_2.m
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

% Wektory warunk�w pocz�tkowych
initConditionsAcc = [0 0];
initConditionsVel = [0 0];