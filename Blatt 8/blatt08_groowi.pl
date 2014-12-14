%%%%%% Sascha Graeff, Frederik Wille


%%%%% Aufgabe 1
%%%% 1)



% Multipliziert In mit Factor und gibt es als Out zurück.
% multiply(+In, -Out, +Factor)
multiply(In, Out, Factor) :- Out is In * Factor.

/* TESTS
?- multiply(3, X, 2).
X = 6.

?- multiply(2, X, 2).
X = 4.
*/


% Zweistellige definition von abs
% abs(+Num, ?Abs)
abs(Num, Abs) :- Abs is abs(Num).

/* TEST
?- abs(-1,X).
X = 1.

?- abs(-1337,X).
X = 1337.

?- abs(1337,X).
X = 1337.
*/

% apply_to_all(+InListe, +Goal, -OutListe)
% jedes Prädikat auf eine leere Liste angewandt, ergibt die leere Liste
apply_to_all([], _, []).
% wir wenden Goald auf eine Liste an und geben eine neue Liste aus
apply_to_all([InHead|InTail], Goal, [OutHead|OutTail]) :-
    % Wir kopieren Goal damit wir es unverändert in den Rekursionsaufruf geben können 
    copy_term(Goal, G),
    % Erste beiden Argumente werden für G belegt
    arg(1, G, InHead), 
    arg(2, G, OutHead),
    % G wird auf für das erste Listenelement aufgerufen
    call(G),
    % Rekursionsaufruf
    apply_to_all(InTail, Goal, OutTail).
/*
?- functor(Abs, abs, 2), apply_to_all([1,-2,3], Abs, X).
Abs = abs(_G1050, _G1051),
X = [1, 2, 3].
*/


% Normalisiert die Werte der Liste In auf den Wert Norm.
% normalize(+In, +Norm, -Out)
normalize(In, Norm, Out) :-
    % abs wird als zweistellig festgelegt.
    functor(Abs, abs, 2),
    % wir brauchen betraege, da sonst die negativen Amplituden bei max_list nicht beruecksichtigt werden
    apply_to_all(In, Abs, InBetraege),
    % das maximum der Betragsliste
    max_list(InBetraege, MaxAmplitude),
    Factor is Norm / MaxAmplitude,
    
    functor(MultiplyWithFactor, multiply, 3),
    % binden den Factor der Funktion an unseren berechneten Factor
    arg(3, MultiplyWithFactor, Factor),
    % Multiplizieren aller Werte in der Liste
    apply_to_all(In, MultiplyWithFactor, Out).

/*
?- normalize([0.5, 0.2, 0.4, -0.4, 0.23], 1, X).
X = [1.0, 0.4, 0.8, -0.8, 0.46].

?- normalize([0.5, -0.2, 0.4, -0.4, 0.23], 2, X).
X = [2.0, -0.8, 1.6, -1.6, 0.92].

?- normalize([0.5, -0.2, 0.4, -0.4, 0.23], 0.5, X).
X = [0.5, -0.2, 0.4, -0.4, 0.23].
*/
    
    
%%%% 2)
unterschiedliche_vorzeichen(A,B) :- A < 0, B >= 0.
unterschiedliche_vorzeichen(A,B) :- B < 0, A >= 0.

nulldurchgaenge([], 0).
nulldurchgaenge([_], 0).
nulldurchgaenge([A,B|Rest], Durchgaenge) :-
    nulldurchgaenge([B|Rest], RestDurchgaenge),
    (
        (
            unterschiedliche_vorzeichen(A,B),
            Durchgaenge is RestDurchgaenge + 1
        );
        Durchgaenge is RestDurchgaenge
    ),!.

/* TESTS:
?- nulldurchgaenge([1,-1], ND).
ND = 1.

?- nulldurchgaenge([1,-1,1], ND).
ND = 2.

?- nulldurchgaenge([1,-1,1,2], ND).
ND = 2.

?- nulldurchgaenge([1,-1,1,2,1], ND).
ND = 2.

?- nulldurchgaenge([1,-1,1,2,1,-1], ND).
ND = 3.
*/

nulldurchgangsdichte(Liste, Dichte) :-
    nulldurchgaenge(Liste, ND),
    % Samples sind in 16kHz
    % und 1600 Werte, also 0,1 Sekunde lang.
    % Ergebnis soll in 1Hz sein
    Dichte is ND * 10.
    
nulldurchgangsdichte_von_laut(ID, Dichte) :-
    sound(ID, _, Liste),
    nulldurchgangsdichte(Liste, Dichte).


%%%% 3)
/*
?- nulldurchgangsdichte_von_laut(ID, Dichte).
ID = 1,
Dichte = 7970 ;
ID = 2,
Dichte = 7890 ;
ID = 3,
Dichte = 8310 ;
ID = 4,
Dichte = 1140 ;
ID = 5,
Dichte = 930 ;
ID = 6,
Dichte = 590 ;
ID = 7,
Dichte = 460 ;
ID = 8,
Dichte = 300 ;
ID = 9,
Dichte = 340 ;
ID = 10,
Dichte = 480.
*/
    
% Die Grenze scheint etwa bei 800 zu liegen. Da wir einiges nicht wissen, z.B.,
% wie das "p" gesprochen wurde ("p" oder "peeh"), können wir kaum eine
% geschicktere Grenze setzen.

% ist_stimmhaft(?ID)
ist_stimmhaft(ID) :-
    nulldurchgangsdichte_von_laut(ID, Dichte),
    Dichte < 800.
    
%%%% 4)
ist_stimmlos(ID) :- not(ist_stimmhaft(ID)).

/*
?- sound(ID,_,_), ist_stimmhaft(ID).
ID = 11 ;
ID = 18 .
*/

/*
?- sound(ID,_,_), ist_stimmlos(ID).
ID = 12 ;
ID = 13 ;
ID = 14 ;
ID = 15 ;
ID = 16 ;
ID = 17 ;
false.
*/

% Unser Prädikat behauptet, dass die Sounds 11 und 18 stimmhaft sind.
% Entsprechend sollen alle anderen stimmlos sein.


%%%%% Aufgabe 2

%%%% 3)