%% LABORATORUM SRMan
% �WICZENIE 5 - Regulator adaptacyjny. Zbie�no�� estymat parametr�w modelu manipulatora

% Estymaty macierzy  C, G, F - parametryzacja druga (SRManCw1.pdf, B)

%---- � NOTATKI
% 
function output = SRManCw5_ESTYMATA_MACIERZY_M(input)
% global M C G F

% Definicja sygna��w wej�ciowych
phat = input(1:7);
q = input(8:9);
qrDotDot = input(10:11);

% Wyznaczam estymat� macierzy Mhat wg (SRManCw1.pdf, B)
m11 = phat(1)+phat(3)+2*phat(2)*cos(q(2));
m12 = phat(1)+phat(2)*cos(q(2));
m21 = phat(1)+phat(2)*cos(q(2));
m22 = phat(1);

Mhat = [m11 m12; m21 m22];

output = Mhat * qrDotDot;