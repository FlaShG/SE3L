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
% Unifikation Erfolgreich


%%%%% Aufgabe 2
%%%% 1)
% my_numlist(+Low, +High, -List)
% Im Gegensatz zu dem Standard numlist gibt unser my_numlist bei Low=High nach dem Elemte an dieser Stelle noch ein false aus. 
% Dies beeinträchtigt jedoch nicht die Funktionalität.

% Bei gleichen Grenzen enthält nur die zurückgegebene Liste die Grenze
my_numlist(Low, Low, [Low]).
my_numlist(Low, High, List) :-
    once(( % begrenzen auf eine Ausgabe
        Low < High, % Guard
        % untere Grenze wird erstes Element der Liste
        % Rest der Liste wird mit inkrementiertem Low rekursiv aufgebaut
        LessLow is Low + 1, 
        my_numlist(LessLow, High, Tail),
        List = [Low|Tail] 
    )).

% Tests:
% numlist hatte immer jeweils das gleiche Ergebnis.
% Ausgenommen sind die Fälle mit Low=High, in denen unsere Variante
% noch weiter unifizieren möchte.
% ?- my_numlist(1,1,Liste).
%    Liste = [1];
%    false.
% ?- my_numlist(1,5,Liste).
%    Liste = [1,2,3,4,5].
% ?- my_numlist(1,0).% begrenzen auf eine Ausgabe
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

% Abbruch: Index = 0, erstes Element ist das gesucht
my_nth0(0, List, Elem) :-
    List = [Elem|_].
my_nth0(Index, List, Elem) :-
    once(( % begrenzen auf eine Ausgabe
        Index > 0, % Guard
        % Entferne erstes Element der Liste 
        % und rufe das Prädikat mit dekrementiertem Index rekursiv auf
        List = [_|Tail], 
        IndexMinusOne is Index - 1, 
        my_nth0(IndexMinusOne, Tail, Elem)
    )).

% Tests:
% nth0 hatte immer jeweils das gleiche Ergebnis.
% Ausgenommen die Fälle mit Index=0, bei denen wie eben
% noch ein weiteres Mal unifiziert werden will.
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

%%%% 3)
% my_list_to_set(+List, ?Set)
% Abbruch: Eine leere Liste ist eine Menge
my_list_to_set([], []).
% my_list_to_set(List, List) :- is_set(List).
my_list_to_set(List, Set) :-
    once(( % begrenzen auf eine Ausgabe
        List \= [], % Guard
        List = [First|Tail], % Liste in das erste Element und den Rest aufsplitten
        my_list_to_set(Tail, SetOfTail), % rekursiv mit dem Rest aufgerufen 
        add_to_set(SetOfTail, First, Set) % Fügt das Ergebnis der Rekursion in das Set hinzu
    )).

% add_to_set(?Set, ?Elem, ?NewSet)
add_to_set(Set, Elem, Set) :-
    member(Elem, Set). % Gibt das Set zurück wenn das Element bereits enthalten ist
add_to_set(Set, Elem, [Elem|Set]) :-
    not(member(Elem, Set)). % Fügt das Element dem Set hinzu, wenn es nicht enthalten ist

% Tests:
% list_to_set hat ein weitestgehend ähnliches Verhalten.
% Unterschiede: Die weitere Unifizierung bei der leeren Liste (s.o.),
% sowie die Reihenfolge der Elemente im Ergebnis.
% Wir haben uns um die Reihenfolge nicht weiter gekümmert, gemäß der mathematischen
% Definition einer Menge, unsortiert zu sein.
% ?- my_list_to_set([], Set).
% Set = [];
% false.
% ?- my_list_to_set([a,b,c], Set).
% Set = [a,b,c].
% ?- my_list_to_set([a,b,a,c], Set).
% Set = [b,a,c].
% ?- list_to_set([a,b,a,c], Set).
% Set = [a,b,c].

%%%% 4)
% my_ord_union(+Set1, +Set2, -Union)
% Abbruch: Union = Set1 wenn Set2 = []
my_ord_union(Set1, [], Set1).
my_ord_union(Set1, Set2, Union) :-
    once((
        Set2 \= [], % Guard
        Set2 = [Element|Set2Tail], % Trenne Set2 in Element und Set2Tail
        my_ord_union(Set1, Set2Tail, UnionWithoutElement), % Bilde die Union aus Set1 und Set2Tail, um die Union ohne das eben abgetrennte Element zu erhalten
        add_to_set(UnionWithoutElement, Element, Union) % Füge noch das Element in die Union ein. 1-A-Beispiel für Nicht-Endrekursion.
    )).

% Tests:
% Wie in 2.3 sind unsere Sets anders sortiert und der Rekursionsabbruch-Fall
% mit Set2 = [] versucht ein Mal mehr zu unifizieren als nötig.
% ?- my_ord_union([a,b,c], [], Union).
%    Union = [a,b,c];
%    false.
% ?- my_ord_union([a,b,c], [a,c,e], Union).
%    Union = [e, a, b, c].
% ?- ord_union([a,b,c], [a,c,e], Union).
%    Union = [a, b, c, e].


%%%%% Aufgabe 3
