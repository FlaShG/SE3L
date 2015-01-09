%%%%%% Sascha Graeff, Frederik Wille


%%%%% Aufgabe 1
%%%% 1)

% Es geht um Werbeplakate, genauer um eine Studie zur Wirksamkeit dieser.
% Die Plakate werden gleichzeitig für eine sehr kurze Zeit enthüllt, und die
% Testperson nennt, was vom Inhalt der Plakate hängen geblieben ist.

% Klassen:
% top = das Werbeplakat wurde sehr gründlich angesehen
% ok = das Werbeplakat wurde wahrgenommen
% flop = das Werbeplakat wurde kaum oder gar nicht wahrgenommen

% Merkmale:
% Helligkeit des Plakats (Werte von 0 (dunkel) bis 100 (hell))

% Person auf dem Plakat:
% -2 = leicht bekleideter Mann
% -1 = Mann
% 0 = keine Person
% 1 = Frau
% 2 = leicht bekleidete Frau
% (es war immer nur maximal eine Person auf dem Plakat)

% Tier(e) auf dem Plakat (Anzahl)

:- dynamic d/2.
d(top, [60, 2, 2]).
d(top, [55, 2, 0]).
d(top, [57, -2, 4]).
d(ok, [20, 2, 1]).
d(ok, [52, -1, 1]).
d(ok, [80, 0, 5]).
d(ok, [55, -1, 0]).
d(ok, [40, -2, 0]).
d(flop, [5, 1, 0]).
d(flop, [80, 0, 0]).
d(flop, [67, -1, 0]).
d(flop, [80, 0, 1]).


%%%% 2)
% eukl(+X, +Y, -Result)
eukl(X, Y, Result) :- eukl(X, Y, 0, Result).

eukl([], [], Sum, Result) :- Result is sqrt(Sum).
eukl([Head1|Tail1], [Head2|Tail2], Sum, Result) :-
    NextSum is Sum + (Head1 - Head2) * (Head1 - Head2),
    eukl(Tail1, Tail2, NextSum, Result).


%%%% 3)
