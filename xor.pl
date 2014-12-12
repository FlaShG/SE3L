
% xor(+If, +True, +False, -Result)
xor(true, True, _, True).
xor(false, _, False, False).
xor(If, True, False, Result) :-
    If =\= true,
    If =\= false,
    xor(not(not(If)), True, False, Result).