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
my_list_to_set([First|Tail], Set) :-
    once(( % begrenzen auf eine Ausgabe
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
my_ord_union(Set1, [Element|Set2Tail], Union) :-
    once((
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
%%%% 1)
% gerade(+Binaerzahl)
gerade([0|_]).
% ungerade(+Binaerzahl)
ungerade([1|_]).

% ?- gerade([0,1]).
%    true.
% ?- gerade([1,1]).
%    false.
% ?- ungerade([0,1]).
%    false.
% ?- ungerade([1,1]).
%    true.

%%%% 2)
% doppelt(+Binaerzahl, -Doppelt)
% doppelt(-BinaerZahl, +Doppelt)
doppelt(Binaerzahl, [0|Binaerzahl]).

% ?- doppelt([0,1,1], Z).
%    Z = [0, 0, 1, 1].
% ?- doppelt(Z, [0,1,1]).
%    Z = [1, 1].

%%%% 3)
% gerade(+Binaerzahl, -Gerade)
% Ersetze eine "führende 1" durch eine 0:
mach_gerade([1|Rest], [0|Rest]).
% Wenn die Zahl schon gerade ist, soll nicht false, sondern wieder
% die Zahl als Ergebnis kommen:
mach_gerade([0|Rest], [0|Rest]).

% ?- mach_gerade([0,1,1], Z).
%    Z = [0, 1, 1].
% ?- mach_gerade([1,1,1], Z).
%    Z = [0, 1, 1] ;
%    false.

%%%% 4)
% binaerzahl(+Ding)
binaerzahl(Ding) :-
    once(
        Ding = []; % Die 0
        binaerzahl_helper(Ding)
    ).

% binaerzahl_helper(+Ding) - Hilfsprädikat für alle Zahlen \= [0]
binaerzahl_helper([1]).
binaerzahl_helper([0|Rest]) :-
    binaerzahl_helper(Rest).
binaerzahl_helper([1|Rest]) :-
    binaerzahl_helper(Rest).
    

% ?- binaerzahl([0]).
%    true.
% ?- binaerzahl([1]).
%    true.
% ?- binaerzahl([0, 1]).
%    true.
% ?- binaerzahl([1, 1]).
%    true.

% ?- binaerzahl([1, 0]).
%    false.
% ?- binaerzahl([0, 0]).
%    false.

%%%% 5)
% binaer_zu_int(+Binaerzahl, -Int)
binaer_zu_int(Binaerzahl, Int) :-
    once(binaer_zu_int_helper(Binaerzahl, 1, Int)).

% binaer_zu_int_helper(+Binaerzahl, +Stelligkeit, -Int)
% Simple Fälle: 0 und 1
binaer_zu_int_helper([], _, 0).
binaer_zu_int_helper([1], Stelligkeit, Stelligkeit).

% 0 auf der linken Seite hat keinen Einfluss auf das Ergebnis,
% also weiter mit den anderen Ziffern mit doppelter Stelligkeit.
binaer_zu_int_helper([0|Rest], Stelligkeit, Int) :-
    S is Stelligkeit * 2,
    binaer_zu_int_helper(Rest, S, Int).
    
% Steht links eine 1, wird das Ergebnis der folgenden Ziffern
% um die aktuelle Stelligkeit erhöht.
binaer_zu_int_helper([1|Rest], Stelligkeit, Int) :-
    S is Stelligkeit * 2,
    binaer_zu_int_helper(Rest, S, RestInt),
    Int is RestInt + Stelligkeit.

% ?- binaer_zu_int([], Int).
%    Int = 0.
% ?- binaer_zu_int([0], Int).
%    Int = 0.
% ?- binaer_zu_int([1], Int).
%    Int = 1.
% ?- binaer_zu_int([1,0], Int).
%    Int = 1.
% ?- binaer_zu_int([0,1], Int).
%    Int = 2.
% ?- binaer_zu_int([1,1], Int).
%    Int = 3.
% ?- binaer_zu_int([0,0,1], Int).
%    Int = 4.


% int_zu_binaer(+Int, -Binaerzahl)
int_zu_binaer(Int, BinaerZahl) :-
    once(int_zu_binaer_helper(Int, BinaerZahl)).
    
% int_zu_binaer_helper(+Int, -BinaerZahl)
int_zu_binaer_helper(0, []).
int_zu_binaer_helper(1, [1]).
int_zu_binaer_helper(Int, BinaerZahl) :-
    Half is floor(Int / 2), % abgerundete Hälfte von Int
    int_zu_binaer_helper(Half, RestZahl), % Die Bits rechts vom aktuellen Bit bilden sich aus besagter Hälfte
    Bit is Int mod 2, % Das aktuelle bit ist 1 wenn Int ungerade, sonst 0
    BinaerZahl = [Bit|RestZahl]. % Hänge das aktuelle Bit vorne an die anderen
    
% ?- int_zu_binaer(0, B).
%    B = [].
% ?- int_zu_binaer(1, B).
%    B = [1].
% ?- int_zu_binaer(2, B).
%    B = [0, 1].
% ?- int_zu_binaer(3, B).
%    B = [1, 1].
% ?- int_zu_binaer(4, B).
%    B = [0, 0, 1].
% ?- int_zu_binaer(5, B).
%    B = [1, 0, 1].
    
%%%% 6)
% volladdierer(+Bit1, +Bit2, +Uebertrag, -Ergebnis, -ErgebnisUebertrag)
volladdierer(false, false, false, false, false).
volladdierer(Bit1, Bit2, Uebertrag, true, false) :-
    (Bit1, not(Bit2), not(Uebertrag));
    (not(Bit1), Bit2, not(Uebertrag));
    (not(Bit1), not(Bit2), Uebertrag).
volladdierer(Bit1, Bit2, Uebertrag, false, true) :-
    (not(Bit1), Bit2, Uebertrag);
    (Bit1, not(Bit2), Uebertrag);
    (Bit1, Bit2, not(Uebertrag)).
volladdierer(true, true, true, true, true).

% volladdierer_int(+Bit1, +Bit2, +Uebertrag, -Ergebnis, -ErgebnisUebertrag)
volladdierer_int(Bit1, Bit2, Uebertrag, Ergebnis, ErgebnisUebertrag) :-
    once(volladdierer(
        Bit1 = 1,
        Bit2 = 1,
        Uebertrag = 1,
        ErgebnisBool,
        ErgebnisUebertrag
    )).

%%%% 7)
% addiere_binaer(+Binaer1, +Binaer2, -Ergebnis)
addiere_binaer(Binaer1, Binaer2, Ergebnis) :-
    once(addiere_binaer(Binaer1, Binaer2, 0, Ergebnis)).
    %umgedreht(GedrehtesErgebnis, Ergebnis).
    
% addiere_binaer(+Binaer1, +Binaer2, +Uebertrag, -Ergebnis)
% Wenn Binaer1 = [] ist, tausche die Summanden
addiere_binaer([], [Bit2|Rest2], Uebertrag, Ergebnis) :-
    addiere_binaer([Bit2|Rest2], [], Uebertrag, Ergebnis).
    
% Drei Fälle, in denen Binaer2 = [] ist.
addiere_binaer(Binaer1, [], 0, Binaer1). % mit 0 Übertrag
addiere_binaer([0|Rest], [], 1, [1|Rest]). % Bei einem Übertrag von 1, ersetze die Einser-0 durch eine 1
addiere_binaer([1|Rest], [], 1, [0,1|Rest]). % ...bzw. schiebe eine 0 vor die Einser-1.

% Sind beide Zahlen > 0 (\= []), so werden sie so lange abgearbeitet, bis dies nicht mehr der Fall ist.
addiere_binaer([Bit1|Rest1], [Bit2|Rest2], Uebertrag, Ergebnis) :-
    volladdierer_int(Bit1, Bit2, Uebertrag, VAErgebnis, VAUebertrag),
    addiere_binaer(Rest1, Rest2, VAUebertrag, RestErgebnis),
    Ergebnis = [VAErgebnis|RestErgebnis].

% umgedreht(+Liste, -Umgedreht)
umgedreht(Liste, Umgedreht) :- umgedreht(Liste, Umgedreht, []).
umgedreht([], Z, Z).
umgedreht([H|T], Z, Acc) :- umgedreht(T, Z, [H|Acc]).
    
    
    
    
    
    


