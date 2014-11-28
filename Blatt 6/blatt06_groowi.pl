%%%%%% Sascha Graeff, Frederik Wille

%%%%% Aufgabe 4
%%%% 1)

% Einzelner Knoten ist auch ein Baum
s(Atom) :-
    atom(Atom).
% Rechterzweig ist ein Atom und Links ist ein Baum
s(s(_), Rechts) :-
    atom(Rechts).
% Links ist ein Atom und Rechts ein gültiger Baum
s(Links, s(_)) :-
    atom(Links).
% Beide Seiten sind Bäume
s(s(_),s(_)).
% Beide Seiten sind Atome (Nicht ganz sicher, ob dies nötig ist)
s(Links, Rechts) :-
    atom(Links),
    atom(Rechts).

%%%% 2)
%Tiefe eines Atomes ist 0
tiefe(Atom, Tiefe) :-
    atom(Atom),
    Tiefe = 0.

tiefe(s(Links, _), Tiefe) :-
    tiefe(Links, Tiefe1),
    Tiefe is Tiefe1 + 1.
tiefe(s(_, Rechts), Tiefe) :-
    tiefe(Rechts, Tiefe1),
    Tiefe is Tiefe1 + 1.