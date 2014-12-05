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
%    [M, N, [M, 1, N], [1, 0, 1], N]
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

% ?- [r|W] = [V,V,V].
% W = [V, V]
% V = r,
% W = [r, r].

%%%%% Aufgabe 2
%%%% 1)
% my_numlist(+Low, +High, -List)
my_numlist(Low, Low, [Low]).
my_numlist(Low, High, List) :-
    once((
        Low < High,
        LessLow is Low + 1,
        my_numlist(LessLow, High, Tail),
        List = [Low|Tail]
    )).

% Tests (numlist hatte immer jeweils das gleiche Ergebnis):
% ?- my_numlist(1,1,Liste).
%    Liste = [1].
% ?- my_numlist(1,5,Liste).
%    Liste = [1,2,3,4,5].
% ?- my_numlist(1,0).
%    false.

% my_numlist unterscheidet sich von numlist lediglich in der Fehlerbehandlung:
% ?- my_numlist(1,a,List).
%    ERROR: </2: Arithmetic: `a/0' is not a function
% ?- numlist(1,a,List).
%    ERROR: Type error: `integer' expected, found `a'

%%%% 2)
% nth0(+Index, ?List, ?Elem)
% Unsere Variante ist mit +Index definiert.
% Das originale nth0 hat ?Index, wirft aber einen Fehler,
% wenn Index ungebunden ist. Das fanden wir weniger klug als +Index.

my_nth0(0, List, Elem) :-
    List = [Elem|_].
my_nth0(Index, List, Elem) :-
    once((
        Index > 0,
        List = [_|Tail],
        IndexPlusOne is Index - 1,
        my_nth0(IndexPlusOne, Tail, Elem)
    )).

% Test (nth0 hatte immer jeweils das gleiche Ergebnis):
% ?- my_nth0(0, [a,b,c,d,e], a).
%    true;
%    false.
% ?- my_nth0(1, [a,b,c,d,e], a).
%    false.
% ?- my_nth0(0, [a,b,c,d,e], b).
%    false.
% ?- my_nth0(2, [a,b,c,d,e], Elem).
%    Elem = c.
% ?- my_nth0(3, Liste, a).
%    Liste = [_G19528, _G19531, _G19534, a|_G19538].

















