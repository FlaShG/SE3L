
% rule(+Pattern, -Response)

rule([[ich, habe], Menge, Art, [gegessen], _],
     [[warum, hast, du], Menge, Art, [gegessen, '?']]).


% dasis quatsch
answer([[Word|Tail1]|Tail2], Response) :-
    answer([Word|Tail1], Response)

answer(Input, Response) :- 
    rule(Input, Response), !.