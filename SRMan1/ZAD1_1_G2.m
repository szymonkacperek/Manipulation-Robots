%% LABORATORUM SRMan
% �WICZENIE 1 - Model manipulatora PM2R. Zadanie proste i odwrotne dynamiki
% ZADANIE 1.1: Zamodelowa� nast�puj�ce generatory sygna��w referencyjnych (zadanych) (i = 1, 2):

%---- � MIEJSCE NA NOTATKI
% 
%% ZADANIE 1.1b
%---- � Zamodelowa� G2: generator sygna��w wielomianowych 3-go stopnia:

function q23bis = ZAD1_1_G2(u)
global Qd2 Qd3 t
q23bis = [6*Qd3 2*Qd2];
q23bis = polyval(q23bis, t);
end