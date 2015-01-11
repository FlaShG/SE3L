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
% brechnet fuer jedes Trainingsbeispiel den Abstand zum Testbeispiel
% alleAbstaende(+Test, -[Klasse,EuklResult])
alleAbstaende(Test, [Klasse,EuklResult]) :- 
    d(Klasse,Daten),
    eukl(Test, Daten, EuklResult).

%% Tests 
% ?- alleAbstaende([40,0,1],X).
% X = [top, 20.12461179749811] ;
% X = [top, 15.165750888103101] ;
% X = [top, 17.378147196982766] ;
% X = [ok, 20.09975124224178] ;
% X = [ok, 12.041594578792296] ;
% X = [ok, 40.19950248448356] ;
% X = [ok, 15.066519173319364] ;
% X = [ok, 2.23606797749979] ;
% X = [flop, 35.02855977627399] ;
% X = [flop, 40.01249804748511] ;
% X = [flop, 27.03701166919155] ;
% X = [flop, 40.0].

% ?- alleAbstaende([100,2,0],X).
% X = [top, 40.049968789001575] ;
% X = [top, 45.0] ;
% X = [top, 43.37049688440288] ;
% X = [ok, 80.00624975587844] ;
% X = [ok, 48.104053883222775] ;
% X = [ok, 20.71231517720798] ;
% X = [ok, 45.09988913511872] ;
% X = [ok, 60.13318551349163] ;
% X = [flop, 95.00526301210897] ;
% X = [flop, 20.09975124224178] ;
% X = [flop, 33.13608305156178] ;
% X = [flop, 20.12461179749811].


%%%% 4)
% findet den naechsten Nachbar zum Testbeispiel
% direkter_Nachbar(+Test, -[Klasse, Min])
direkter_Nachbar(Test, [Klasse,Min]) :-
    % packe alle gefundenen Abstaende in eine List
    findall(A, alleAbstaende(Test, [_,A]), B),
    % finde das minimum dieser Liste
    min_list(B, Min),
    % finde die Klasse fuer das Minimum
    alleAbstaende(Test, [Klasse,Min]).

%% Tests
% ?- direkter_Nachbar([40,0,1],X).
% X = [ok, 2.23606797749979] ;
% false.

% ?- direkter_Nachbar([100,2,0],X).
% X = [flop, 20.09975124224178] ;
% false.


%%%%% Aufgabe 2
%%%% 1)
% k_naechste_nachbarn(+Beobachtung, +K, -Nachbarn)
% Findet die nächsten K Nachbarn zur gegebenen Beobachtung in der Datenbasis.
% Nachbarn unifiziert zu einer Liste mit K Elementen der Form [Klasse, Merkmale].
% Das erste Listenelement ist dabei der am weitesten entfernte der K Nachbarn,
% das letzte Element der nächste Nachbar.
k_naechste_nachbarn(Beobachtung, K, Nachbarn) :-
    % finde alle potentiellen Nachbarn
    findall([Klasse, Merkmale], d(Klasse, Merkmale), AlleFakten),
    % starte das eigentliche Finden
    knn(Beobachtung, K, AlleFakten, [], NachbarnMitAbstand),
    % "formatiere" das Ergebnis. Siehe Kommentar des nächsten Prädikats
    findall(Nachbar, member([Nachbar,_], NachbarnMitAbstand), Nachbarn),
    !.

% Tests:
/*
?- k_naechste_nachbarn([20,2,3], 3, R).
R = [[ok, [40, -2, 0]], [flop, [5, 1, 0]], [ok, [20, 2, 1]]].

?- k_naechste_nachbarn([40,2,3], 3, R).
R = [[top, [55, 2, 0]], [ok, [52, -1, 1]], [ok, [40, -2, 0]]].

?- k_naechste_nachbarn([40,2,3], 4, R).
R = [[ok, [55, -1, 0]], [top, [55, 2, 0]], [ok, [52, -1, 1]], [ok, [40, -2, 0]]].
*/
% Diese Tests sind implizit auch Tests für das Unterprädikat knn/5.

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
    eukl(Beobachtung, Merkmale, Abstand),
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
    eukl(Beobachtung, Merkmale, Abstand),
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

%%%%% Aufgabe 3
%%%% 1)

ztransform(Wert, Varianz, Mittelwert, Z) :-
    Z is (Wert - Mittelwert) / Varianz.

normalize_plakat([A,B,C],[An,Bn,Cn]) :-
    ztransform(A,50,50,An),
    ztransform(B,2,0,Bn),
    ztransform(C,3,3,Cn).

normalize_plakat_beispiele([Klasse,Result]) :-
    d(Klasse,Werte),
    normalize_plakat(Werte,Result).

%% Tests
% ?- ztransform(75, 50, 50,X).
% X = 0.5.
% 
% ?- ztransform(60, 50, 50,X).
% X = 0.2.
% 
% ?- ztransform(10, 50, 50,X).
% X = -0.8.
% 
% ?- ztransform(10, 50, 100,X).
% X = -1.8.

% ?- normalize_plakat([60,2,2],A).
% A = [0.2, 1, -0.3333333333333333].

% ?- normalize_plakat_beispiele(Result).
% Result = [top, [0.2, 1, -0.3333333333333333]] ;
% Result = [top, [0.1, 1, -1]] ;
% Result = [top, [0.14, -1, 0.3333333333333333]] ;
% Result = [ok, [-0.6, 1, -0.6666666666666666]] ;
% Result = [ok, [0.04, -0.5, -0.6666666666666666]] ;
% Result = [ok, [0.6, 0, 0.6666666666666666]] ;
% Result = [ok, [0.1, -0.5, -1]] ;
% Result = [ok, [-0.2, -1, -1]] ;
% Result = [flop, [-0.9, 0.5, -1]] ;
% Result = [flop, [0.6, 0, -1]] ;
% Result = [flop, [0.34, -0.5, -1]] ;
% Result = [flop, [0.6, 0, -0.6666666666666666]].
