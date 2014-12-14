create_hashtable(1, [[]]) :- !.
create_hashtable(Buckets, [[]|Tail]) :-
    BucketsMinusOne is Buckets - 1,
    create_hashtable(BucketsMinusOne, Tail).
    
hash(Thing, Hash) :-
    atom_codes(Thing, Ascii),
    build_hash(Ascii, 1, Hash).
    
build_hash([], Index, Index).
build_hash([Head|Tail], Index, Hash) :-
    IndexPlusOne is Index + 1,
    build_hash(Tail, IndexPlusOne, OtherHash),
    Hash is OtherHash + Index * Head.
    
add_to_hashtable(Table, [Key, Value], NewTable) :-
    hash(Key, Hash), % get the hash
    length(Table, BucketCount), % get the bucket count
    Index is Hash mod BucketCount, % calculate the bucket index
    add_to_hashtable(Table, [Key, Value], Index, NewTable). % put the element in the right bucket
    
add_to_hashtable([Bucket|Tail], Element, 0, [[Element|Bucket]|Tail]) :- !.
add_to_hashtable([Bucket|Tail], Element, Index, [Bucket|NewTail]) :-
    IndexMinusOne is Index - 1,
    add_to_hashtable(Tail, Element, IndexMinusOne, NewTail).
    
%%%% 4)
% create_hashtable_from_data(+KeyValuePairs, -Table)
create_hashtable_from_data([], Table) :-
    create_hashtable(20, Table), !.
    
create_hashtable_from_data([KeyValuePair|OtherPairs], Table) :-
    create_hashtable_from_data(OtherPairs, T),
    add_to_hashtable(T, KeyValuePair, Table).

test_create_hashtable_from_data(Table) :- index(L), create_hashtable_from_data(L, Table).

%%%% 5)
% get_from_hashtable(+Table, ?Key, ?Value)
get_from_hashtable(Table, Key, Value) :-
    hash(Key, Hash), % get the hash
    length(Table, BucketCount), % get the bucket count
    Index is Hash mod BucketCount, % calculate the bucket index
    get_from_hashtable(Table, Index, Key, Value).
    
get_from_hashtable([Bucket|_], 0, Key, Value) :-
    get_from_bucket(Bucket, Key, Value).
get_from_hashtable([_|OtherBuckets], Index, Key, Value) :-
    IndexMinusOne is Index -1,
    get_from_hashtable(OtherBuckets, IndexMinusOne, Key, Value).
    
get_from_bucket([], _, _) :- !.
get_from_bucket([[Key, Value]|_], Key, Value).
get_from_bucket([_|OtherPairs], Key, Value) :-
    get_from_bucket(OtherPairs, Key, Value).

%%%% 6)
/*
Man kann streambasiert mehrere Werte pro Schlüssel durch ; abfragen.
*/

%%%% 7)
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

