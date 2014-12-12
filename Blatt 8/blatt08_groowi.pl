%%%%%% Sascha Graeff, Frederik Wille


%%%%% Aufgabe 1
%%%% 1)

% Multipliziert In mit Factor und gibt es als Out zurück.
% multiply(+In, -Out, +Factor)
multiply(In, Out, Factor) :- Out is In * Factor.

% Zweistellige definition von abs
% abs(+Num, ?Abs)
abs(Num, Abs) :- Abs is abs(Num).

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
    
    
%%%% 2)
unterschiedliche_vorzeichen(A,B) :- A < 0, B >= 0.
unterschiedliche_vorzeichen(A,B) :- B < 0, A >= 0.

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
    
    