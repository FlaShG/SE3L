
% rule(+Pattern, -Response)

rule([[ich, habe], Menge, Art, [gegessen], _],
     [[warum, hast, du], Menge, Art, [gegessen, '?']]).


% flatten(+In, -Out)
% Macht aus einer Liste beliebiger Tiefe eine "flache" Liste
% mit den gleichen Elementen
flatten([Word], [Word]).

flatten([Word|Tail], [FlatWord|FlatTail]) :-
    flatten(Word, FlatWord),
    flatten(Tail, FlatTail).



flatten([[]|Tail], Tail).

flatten([Word|Tail], [Word|Result]) :-
    Word \= [_],
    Word \= [],
    flatten(Tail, Result).

flatten([[Word|InnerTail]|Tail], [Word|Result]) :-
    Word \= [_],
    Word \= [],
    flatten(Tail, Result).

/*
flatten([[Word] | Tail], [Word|Result]) :-
    flatten(Tail, Result).

flatten([[Word|Tail1] | Tail2], [Word|Result]) :-
    Tail1 \= [],
    flatten([Tail1|Tail2], Result).

flatten([Word|Tail], [Word|Result]) :-
    Tail \= [],
    flatten(Tail, Result).

flatten([Word], [Word]).
*/

answer(Input, Response) :- 
    flatten(Pattern, Input),
    rule(Pattern, Response), !.