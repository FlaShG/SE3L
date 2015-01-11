%%%%%% Sascha Graeff, Frederik Wille


%%%%% Aufgabe 1
%%%% 1)

% Es geht um Werbeplakate, genauer um eine Studie zur Wirksamkeit dieser.
% Die Plakate werden gleichzeitig für eine sehr kurze Zeit enthüllt, und die
% Testperson nennt, was vom Inhalt der Plakate hängen geblieben ist.

% Klassen:
% top = das Werbeplakat wurde sehr gründlich angesehen
% ok = das Werbeplakat wurde wahrgenommen
% flop = das Werbeplakat wurde kaum oder gar nicht wahrgenommen

% Merkmale:
% Helligkeit des Plakats (Werte von 0 (dunkel) bis 100 (hell))

% Person auf dem Plakat:
% -2 = leicht bekleideter Mann
% -1 = Mann
% 0 = keine Person
% 1 = Frau
% 2 = leicht bekleidete Frau
% (es war immer nur maximal eine Person auf dem Plakat)

% Tier(e) auf dem Plakat (Anzahl)

:- dynamic d/2.
d(top, [60, 2, 2]).
d(top, [55, 2, 0]).
d(top, [57, -2, 4]).
d(ok, [20, 2, 1]).
d(ok, [52, -1, 1]).
d(ok, [80, 0, 5]).
d(ok, [55, -1, 0]).
d(ok, [40, -2, 0]).
d(flop, [5, 1, 0]).
d(flop, [80, 0, 0]).
d(flop, [67, -1, 0]).
d(flop, [80, 0, 1]).


%%%% 2)
% eukl(+X, +Y, -Result)
eukl(X, Y, Result) :- eukl(X, Y, 0, Result).

eukl([], [], Sum, Result) :- Result is sqrt(Sum).
eukl([Head1|Tail1], [Head2|Tail2], Sum, Result) :-
    NextSum is Sum + (Head1 - Head2) * (Head1 - Head2),
    eukl(Tail1, Tail2, NextSum, Result).

% Tests:
/*
?- eukl([1,2,3], [1,2,3], R).
R = 0.0.

?- eukl([1,2,3], [2,2,3], R).
R = 1.0.

?- eukl([1,2,3], [2,3,3], R).
R = 1.4142135623730951.

?- eukl([1,2,3,0], [2,3,3,0], R).
R = 1.4142135623730951.
*/

%%%% 3)
% naechsterNachbar()


%%%% 4)


%%%%% Aufgabe 2
%%%% 1)
k_naechste_nachbarn(Beobachtung, K, Nachbarn) :-
    % finde alle potentiellen Nachbarn
    findall([Klasse, Merkmale], d(Klasse, Merkmale), AlleFakten),
    % starte das eigentliche Finden
    knn(Beobachtung, K, AlleFakten, [], NachbarnMitAbstand),
    % "formatiere" das Ergebnis. Siehe Kommentar des nächsten Prädikats
    findall(Nachbar, member([Nachbar,_], NachbarnMitAbstand), Nachbarn).

% knn(+Beobachtung, +K, +Rest, +Gefunden, -Ergebnis)
% Rest ist die Menge der noch zu untersuchenden, potentiellen Nachbarn, in der Form [Klasse, Merkmale].
% Gefunden ist eine Liste mit den bereits gefundenen Nachbarn (Akkumulator)
% Ergebnis ist eine Liste aus Paaren in der Form [Nachbar, Abstand],
% wobei Abstand der Abstand des Nachbars zur Beobachtung ist.
% Rekursionsabschluss
knn(_, _, [], Gefunden, Gefunden).

% Ein gefundener Nachbar wird eingefügt, wenn wir sowieso erst weniger als K Ergebnisse haben
knn(Beobachtung, K, [Nachbar|Rest], Gefunden, Ergebnis) :-
    length(Gefunden, Length),
    Length < K,
    % Wir haben noch keine K Nachbarn, also füge [Nachbar, Abstand] in Gefunden ein
    Nachbar = [_, Merkmale],
    Abstand is eukl(Beobachtung, Merkmale),
    knn_einfuegen(Gefunden, [Nachbar, Abstand], NeuGefunden),
    % Finde mehr Nachbarn
    knn(Beobachtung, K, Rest, NeuGefunden, Ergebnis).
    
% Ein gefundener Nachbar wird, wenn wir schon K Nachbarn gefunden haben, nur dann eingefügt,
% wenn er näher dran ist als einer der gefundenen Nachbarn.
% Da der am weitesten entfernte Nachbar am Listenanfang von Gefunden steht,
% wird dieser zum Vergleich verwendet und ggf. aus der Liste gestrichen.
knn(Beobachtung, K, [Nachbar|Rest], Gefunden, Ergebnis) :-
    length(Gefunden, Length),
    Length >= K,
    % Wir haben schon K Nachbarn, also vergleiche mit dem am weitesten entfernten unter den bereits gefundenen
    Nachbar = [_, Merkmale],
    Abstand is eukl(Beobachtung, Merkmale),
    Gefunden = [[_, WeitesterAbstand]|AndereGefunden],
    (
        Abstand < WeitesterAbstand
        ->
            % Füge [Nachbar,Abstand] in AndereGefunden ein.
            % In AndereGefunden fehlt bereits der bisher am weitesten entfernte Nachbar
            knn_einfuegen(AndereGefunden, [Nachbar,Abstand], NeuGefunden)
        ;
            % Keine Änderungen im Ergebnis, wenn der aktuell betrachtete Nachbar
            % weiter eg ist als der bisher am weitesten entfernte
            NeuGefunden = Gefunden
    ),
    % Finde mehr Nachbarn
    knn(Beobachtung, K, Rest, NeuGefunden, Ergebnis).
    
% knn_einfuegen(+Gefunden, +NachbarMitAbstand, -NeuGefunden)
% Fügt den Nachbar in Gefunden ein und gibt das Ergebnis zurück. Der Nachbar in Form von [Nachbar, Abstand] wird dabei
% in dem Abstand nach die Liste einsortiert. Der Nachbar mit dem niedrigsten Abstand steht am Listenanfang.
knn_einfuegen([], NachbarMitAbstand, [NachbarMitAbstand]).
knn_einfuegen([Naechster|Rest], [Nachbar,Abstand], NeuGefunden) :-
    Naechster = [_,WeitesterAbstand],
    Abstand > WeitesterAbstand
    ->
        % Ist der einzufügende Nachbar weiter weg als der überprüfte in der Liste,
        % füge ihn vor dem überprüften ein
        NeuGefunden = [[Nachbar, Abstand],Naechster|Rest]
    ;
        % Ansonsten: Füge den neuen Nachbarn in die Restliste ein und lasse den
        % überprüften davor stehen, denn er ist weiter weg.
        (
            knn_einfuegen(Rest, [Nachbar,Abstand], RestGefunden),
            NeuGefunden = [Naechster|RestGefunden]
        ).

% Tests:
/*
?- knn_einfuegen([[a, 10],[b, 8], [c, 5]], [x, 11], R).
R = [[x, 11], [a, 10], [b, 8], [c, 5]].

?- knn_einfuegen([[a, 10],[b, 8], [c, 5]], [x, 7], R).
R = [[a, 10], [b, 8], [x, 7], [c, 5]].

?- knn_einfuegen([[a, 10],[b, 8], [c, 5]], [x, 2], R).
R = [[a, 10], [b, 8], [c, 5], [x, 2]].
*/














