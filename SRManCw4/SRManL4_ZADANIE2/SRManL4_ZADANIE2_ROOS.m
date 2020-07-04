%% LABORATORUM SRMan
% �WICZENIE 4 - Jako�� sterowania z regulatorem ROOS dla dw�ch rodzaj�w ograniczonych
%               podprzestrzeni sterowa�: hiperkuli i hiperprostopad�o�cianu

%---- � Regulator ROOS

function u = SRManL4_ZADANIE2_ROOS(input)

global epsilon umax u1max u2max
r1 = input(1);
r2 = input(2);
r = [r1; r2];

%  I. R�wnanie (8)
if norm(r) >= epsilon
    up = (norm(umax)/norm(r)) * r;
else
    up = (norm(umax)/epsilon) * r;
end

% II. Okre�lenie wsp�czynnika k
k = inv(max([1; abs(up(1))/u1max; abs(up(2))/u2max]));

u = k * up;