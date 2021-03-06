% Baut eine Hash-Tabelle mit Bucket Buckets
% create_hashtable(+Buckets, -Table)
create_hashtable(1, [[]]) :- !.
create_hashtable(Buckets, [[]|Tail]) :-
    BucketsMinusOne is Buckets - 1,
    create_hashtable(BucketsMinusOne, Tail).

% Errechnet einen Hash für ein beliebiges Atom
% hash(+Thing, -Hash)
hash(Thing, Hash) :-
    atom_codes(Thing, Ascii),
    build_hash(Ascii, 1, Hash).

% Baut einen Hash aus einer Liste von Zahlen
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
add_to_hashtable([Bucket|Tail], Pair, 0, [[Pair|Bucket]|Tail]) :- !.
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
*/