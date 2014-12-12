%%%%%% Sascha Graeff, Frederik Wille


%%%%% Aufgabe 1
%%%% 1)
maximum([], -10000).
maximum([Head|Tail], Max) :-
    maximum(Tail, TailMax),
    Max = max(Head, TailMax).
    
multiply(In, Out, Factor) :- Out is In * Factor.
abs(Num, Abs) :- Abs is abs(Num).

apply_to_all([], _, []).
apply_to_all([InHead|InTail], Goal, [OutHead|OutTail]) :-
    copy_term(Goal, G),
    arg(1, G, InHead),
    arg(2, G, OutHead),
    call(G),
    apply_to_all(InTail, Goal, OutTail).


normalize(In, Norm, Out) :-
    functor(Abs, abs, 2),
    apply_to_all(In, Abs, InBetraege),
    
    max_list(InBetraege, MaxAmplitude),
    
    Factor is Norm / MaxAmplitude,
    
    functor(MultiplyWithFactor, multiply, 3),
    arg(3, MultiplyWithFactor, Factor),
    apply_to_all(In, MultiplyWithFactor, Out).