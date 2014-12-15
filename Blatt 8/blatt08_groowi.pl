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

% Baut eine Hash-Tabelle mit Bucket Buckets
% create_hashtable(+Buckets, -Table)
create_hashtable(1, [[]]) :- !.
create_hashtable(Buckets, [[]|Tail]) :-
    BucketsMinusOne is Buckets - 1,
    create_hashtable(BucketsMinusOne, Tail).

%%%% 3)
% Errechnet einen Hash für ein beliebiges Atom
% hash(+Thing, -Hash)
hash(Thing, Hash) :-
    atom_codes(Thing, Ascii),
    build_hash(Ascii, 1, Hash).

% Baut einen Hash aus einer Liste von Zahlen
% Formel:
% f(A) := Summe[über i von 1 bis Länge(A)](A[i] * i)
% build_hash(+List, +Index, -Hash)
build_hash([], Index, Index).
build_hash([Head|Tail], Index, Hash) :-
    IndexPlusOne is Index + 1,
    build_hash(Tail, IndexPlusOne, OtherHash),
    Hash is OtherHash + Index * Head.

% Fügt das Element (in Form von [Key, Value]) in die Hash-Tabelle Table ein, gibt das Ergebnis als NewTable zurück
% add_to_hashtabke(+Table, +Pair, -NewTable)
add_to_hashtable(Table, [Key, Value], NewTable) :-
    hash(Key, Hash), % get the hash
    length(Table, BucketCount), % get the bucket count
    Index is Hash mod BucketCount, % calculate the bucket index
    add_to_hashtable(Table, [Key, Value], Index, NewTable). % put the element in the right bucket

% Fügt das Element in die Hash-Tabelle Table ein, in den Bucket mit Index Index.
% add_to_hashtable(+Table, +Pair, -NewTable)
% Ist der Index 0, füge das Paar in den ersten Bucket ein
add_to_hashtable([Bucket|Tail], Pair, 0, [[Pair|Bucket]|Tail]) :- !.
% Ansonsten schaue dir rekursiv die anderen Buckets mit niedrigerem Index an
add_to_hashtable([Bucket|Tail], Pair, Index, [Bucket|NewTail]) :-
    IndexMinusOne is Index - 1,
    add_to_hashtable(Tail, Pair, IndexMinusOne, NewTail).
    
%%%% 4)
% Erzeugt eine Hash-Tabelle aus einer Liste von Key-Value-Paaren.
% create_hashtable_from_data(+KeyValuePairs, -Table)
create_hashtable_from_data([], Table) :-
    create_hashtable(20, Table), !.

create_hashtable_from_data([KeyValuePair|OtherPairs], Table) :-
    create_hashtable_from_data(OtherPairs, T),
    add_to_hashtable(T, KeyValuePair, Table).

% Erzeugt eine Hashtabelle aus den Daten aus testindex.pl
% test_create_hashtable_from_data(-Table)
test_create_hashtable_from_data(Table) :- index(L), create_hashtable_from_data(L, Table).

%%%% 5)
% Findet alle Schlüssel/Werte, die zum gegebenen Schlüssel/Wert passen
% get_from_hashtable(+Table, ?Key, ?Value)
get_from_hashtable(Table, Key, Value) :-
    hash(Key, Hash), % get the hash
    length(Table, BucketCount), % get the bucket count
    Index is Hash mod BucketCount, % calculate the bucket index
    get_from_hashtable(Table, Index, Key, Value).

% Findet alle Schlüssel/Werte, die zum gegebenen Schlüssel/Wert passen.
% Gesucht wird nur im Bucket mit dem Index Index.
% get_from_hashtable(+Table, +Index, ?Key, ?Value)
get_from_hashtable([Bucket|_], 0, Key, Value) :-
    get_from_bucket(Bucket, Key, Value).
get_from_hashtable([_|OtherBuckets], Index, Key, Value) :-
    IndexMinusOne is Index -1,
    get_from_hashtable(OtherBuckets, IndexMinusOne, Key, Value).

% Findet alle Schlüssel/Werte, die zum gegebenen Schlüssel/Wert passen.
% Gesucht wird nur im gegebenen Bucket.
% get_from_bucket(+Bucket, ?Key, ?Value)
get_from_bucket([], _, _) :- !.
get_from_bucket([[Key, Value]|_], Key, Value).
get_from_bucket([_|OtherPairs], Key, Value) :-
    get_from_bucket(OtherPairs, Key, Value).

%%%% 6)
/*
 Man kann streambasiert mehrere Werte pro Schlüssel durch ; abfragen.
*/

% ?- test_create_hashtable_from_data(T), get_from_hashtable(T, machen, V).
% T = [...],
% V =  43;
% T = [...],
% V =  328;
% T = [...],
% V =  344;
% T = [...] ;
% false.

%%%% 7)
% Die Tests in dieser Teilaufgabe beziehen sich auf Hashtabellen mit 20 Buckets
% und folgender Hashfunktion:
% f(A) := Summe[über i von 1 bis Länge(A)](A[i] * i)

% Gibt streambasiert die Größen aller Buckets zurück
% bucket_sizes(+Table, -Size)
bucket_sizes([Bucket|[]], Size) :-
    length(Bucket, Size),
    !.
bucket_sizes([Bucket|Tail], Size) :-
    length(Bucket, Size);
    bucket_sizes(Tail, Size).

% Ermittelt die Größe des größten Buckets
% max_bucket_size_in(+Table, -Size)
max_bucket_size_in(Table, Size) :-
    findall(S, bucket_sizes(Table, S), List),
    max_list(List, Size).

% ?- test_create_hashtable_from_data(T), axn_bucket_size_in(T, S).
% T = [...],
% S = 16.
    
% Ermittelt die Größe des kleinsten Buckets
% min_bucket_size_in(+Table, -Size)
min_bucket_size_in(Table, Size) :-
    findall(S, bucket_sizes(Table, S), List),
    min_list(List, Size).
    
% ?- test_create_hashtable_from_data(T), min_bucket_size_in(T, S).
% T = [...],
% S = 5.

% Ermittelt die durchschnittliche Größe der Buckets
% avg_bucket_size_in(+Table, -Size)
avg_bucket_size_in(Table, Size) :-
    findall(S, bucket_sizes(Table, S), List),
    length(List, Length),
    sum_list(List, Sum),
    Size is Sum / Length.

% ?- test_create_hashtable_from_data(T), avg_bucket_size_in(T, S).
% T = [...],
% S = 10.55.
    

%%%% 8)
/*
 Dass die Güte der Hash-Funktion und die Anzahl der Buckets einer Hash-Tabelle
 ausschlaggebend für die Anzahl der entstehenden Kollisionen sind, ist in der
 Theorie hinter der ganzen Sache fest verankert. Die Antwort ist also: Natürlich!
*/

% Test mit 50 statt 20 Buckets:
% ?- test_create_hashtable_from_data(T), avg_bucket_size_in(T, S).
% T = [...],
% S = 4.22.
% ?- test_create_hashtable_from_data(T), max_bucket_size_in(T, S).
% T = [...],
% S = 11.

% Test mit 20 Buckets und Hash-Funktion:
% f(A) := Summe[über i von 1 bis Länge(A)](A[i] * i * i)
% ?- test_create_hashtable_from_data(T), avg_bucket_size_in(T, S).
% T = [...],
% S = 10.55.
% ?- test_create_hashtable_from_data(T), max_bucket_size_in(T, S).
% T = [...],
% S = 21.

% Test mit 50 Buckets und Hash-Funktion:
% f(A) := Summe[über i von 1 bis Länge(A)](A[i] * i * i)
% ?- test_create_hashtable_from_data(T), avg_bucket_size_in(T, S).
% T = [...],
% S = 4.22.
% ?- test_create_hashtable_from_data(T), max_bucket_size_in(T, S).
% T = [...],
% S = 10.

/*
 Es ist klar erkennbar (und logisch), dass die Anzahl und die
 Durchschnittsgröße der Buckets antiproportional sind.
 Außerdem hat die Hash-Funktion einen Einfluss auf die maximale Befüllung von Buckets.
 Bei 50 Buckets verringert sich die maximale Befüllung mit quadriertem Index-Term,
 bei 20 Buckets erhöht sie sich. Besonders raffinierte Hash-Funktionen sind beide
 Versionen nicht.