%%%%%% Sascha Graeff, Frederik Wille

%%%%% Aufgabe 1
% ?- [A,m,A] = [B,B,n]
% 3-elementige Liste = 3-elementige Liste
% A = B
% m = B => A = B = m
% A = n => A = m =\= n
% An A wird erst m gebunden, dann soll n gebunden werden.
% Aufgrund dieser Kollision schlägt die Unifikation fehl.

% ?- [0, [T, 1, T], S, [1, S, 1]] =
     [M, N, [M, 1, N], [1, 0, 1], N]
% 4-elementige Liste =\= 5-elementige Liste
% Die Unifikation schlägt fehl, da die Listen unterschiedlich lang sind.

% ?- [D,D|E] = [[P,b], [a|Q], [Q,P], [P,Q], [P|Q], [Q|P]]
% D = [P,b]
% D = [a|Q]
% [P,b] = [a|Q]
% P = a
% [b] = Q
% E = [[Q,P],    [P,Q],    [P|Q],  [Q|P]]
% E = [[[b], a], [a, [b]], [a, b], [[b]| a]]
% Unifikation erfolgreich mit:
% P = a
% Q = [b]
% E = [[[b], a], [a, [b]], [a, b], [[b]| a]]