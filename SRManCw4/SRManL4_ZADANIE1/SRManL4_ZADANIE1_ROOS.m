%% LABORATORUM SRMan
% �WICZENIE 4 - Jako�� sterowania z regulatorem ROOS dla dw�ch rodzaj�w ograniczonych
%               podprzestrzeni sterowa�: hiperkuli i hiperprostopad�o�cianu

%---- � Regulator ROOS

function u = SRManL4_ZADANIE1_ROOS(input)

global epsilon umax
r1 = input(1);
r2 = input(2);
r = [r1; r2];

%  R�wnanie (5)
if norm(r) >= epsilon
    ans = (min(umax)/norm(r)) * r;
else
    ans = (min(umax)/epsilon) * r;
end

u = ans;