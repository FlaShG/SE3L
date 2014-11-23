%%%%%% Sascha Graeff, Frederik Wille

%%%%% Aufgabe 1

%n(F, g)       n(k, G)
%n/2 = n/2
%F = k, G = g
%n(k, g)       n(k, g)
%unifikation erfolgreich

%p(B, B)       p(i, j)
%p/2 = p/2
%B = i
%unifizieren schlägt fehl
%Grund: B wird mit i belegt und kann dann nicht noch mit j belegt werden.


%r(r(d, D), r(D, d))         r(r(E, e), r(e, E)
%r/2 = r/2
%r(r/2, r/2) = r(r/2, r/2)
%n(F, g)       n(k, G)
%n/2 = n/2
%F = k, G = g
%n(k, g)       n(k, g)
%unifikation erfolgreich

%p(B, B)       p(i, j)
%p/2 = p/2
%B = i
%unifizieren schlägt fehl
%Grund: B wird mit i belegt und kann dann nicht noch mit j belegt werden.


%r(r(d, D), r(D, d))         r(r(E, e), r(e, E)
%r/2 = r/2
%r(r/2, r/2) = r(r/2, r/2)
%D = e, E = d
%r(r(d, e), r(e, d) = r(r(d, e), r(e, d))
%unifizieren läuft


%m(t(X, Y), X, c(g), h(Y))        m(t(r, s), r, h(g(T)))
%m/4 =/= m/3
%unifizieren schlägt fehl
%Grund: m/4 und m/3 passen nicht zusammen


%false    not(true)
%not(true) = false
%false = false
%läuft


%False     not(true)
%False = false, not(true) = false
%false = false
%läuft

%%%%% Aufgabe 2
% 0 ist eine Peano Zahl
peano(0).

% Der Nachfolger einer Peano Zahl ist eine Peano Zahl
peano(s(P)) :- peano(P).

% Der Vorgaenger einer Peano Zahl ist gegeben, wenn die Peano Zahl der Nachfolger des Vorgaengers ist.
p(P, Vorgaenger) :- P = s(Vorgaenger).
% Vorgaenger von s(s(0)):
% ?- p(s(s(0)),X). 
% X = s(0).

% Prueft ob, Peano2 das Minimum der beiden Zahlen ist.
% groessergleich(Peano1, Peano2)
groessergleich(Peano1, Peano2) :- once(grg(Peano1, Peano2)).
grg(P,P).
grg(s(_), 0).
grg(s(X), s(Y)) :- once(grg(X, Y)).

%2>=1?
% ?- groessergleich(s(s(0)),s(0)). 
% true.

%2>=2?
% ?- groessergleich(s(s(0)),s(s(0))). 
% true.

%2>=3?
% ?- groessergleich(s(s(0)),s(s(s(0)))). 
% false.


% min(+Peano1, +Peano2, -PeanoMin)
% Die in der Aufgabe gegebene Instanziierungsvariante mit drei ? erachten wir als nicht sonderlich sinnvoll, da
% min(+X, -E, +X) ein beliebiges E > X ausgeben könnte,
% min(+s(X), -E, +X) einfach E = X ausgibt und
% min(+X, -E, +s(X)) ungültig wäre.
% Die Aufteilung in min und minp (Hilfsprädikat) mit Benutzung von once/1 ermöglicht es,
% nur ein einzelnes Ergebnis auszugeben.
min(Peano1, Peano2, PeanoMin) :- once(pmin(Peano1, Peano2, PeanoMin)).
pmin(0, _, 0). %Wenn eine von beiden Zahlen 0 ist, ist sie immer die kleinere
pmin(_, 0, 0). %Wenn eine von beiden Zahlen 0 ist, ist sie immer die kleinere
pmin(Peano, Peano, Peano). %Wenn beide Zahlen gleich sind, ist die kleinere Trivial
pmin(s(Peano1), s(Peano2), s(PeanoMin)) :- 
    pmin(Peano1, Peano2, PeanoMin).

% Was ist das Minimum von s(s(0)) und s(0)
% ?- min(s(s(0)),s(0), X).
% X = s(0).

% Was ist das Minimum von s(0) und s(s(0))
% ?- min(s(0),s(s(0)), X).
% X = s(0).

% Ist s(0) das Minimum von s(s(0)) und s(0)
% ?- min(s(s(0)),s(0), s(0)).
% true.

%between(+PeanoMin, +PeanoMax, ?PeanoBetween)
%bei gegebenem PeanoBetween wird ermittelt, ob dieses zwischen PeanoMax und PeanoMin liegt.
%wenn PeanoBetween eine Variable ist, werden alle Peanozahlen zwischen den Grenzen ausgegeben
between(PeanoMin, PeanoMax, PeanoBetween) :-
    groessergleich(PeanoMax, PeanoMin),%Abbruch falls PeanoMin groesser ist als PeanoMax
    (
        PeanoBetween = PeanoMin;%unifiziert den gesuchten Wert mit der aktuell unteren Grenze
        between(s(PeanoMin), PeanoMax, PeanoBetween)%Rekursionsschritt mit inkrementiertem PeanoMin
    ).

% Alle Zahlen zwischen 0 und s(s(s(0)))
% ?- between(0, s(s(s((0)))), X).
% X = 0 ;
% X = s(0) ;
% X = s(s(0)) ;
% X = s(s(s(0))) ;
% false.

% Ist s(0) zwischen 0 und s(s(s(0)))
% ?- between(0, s(s(s((0)))), s(0)).
% true ;
% false.


% 2.2
lt(0, s(_)).
lt(s(X), s(Y)) :-
    peano(X),
    peano(Y),
    lt(X, Y).

% bei der Instanziierung mit zwei Werten ändert sich gar nichts, da immer nur 0 oder s(X) übergeben werden kann.
% sollte X dabei keine Peano-Zahl sein, wird X irgendwann an lt übergeben, sodass lt zu false evaluiert.
% Einzig ein schnellerer Rekursionsabbruch kann vorkommen. Die Ergebnisse bleiben gleich.
%
% Übergibt man allerdings eine Variable (z.B. lt(P, s(s(0))) ), so versucht Prolog, ALLE Peano-Zahlen, die er finden kann,
% mit s(s(0)) zu vergleichen.
% Ist der Aufruf anders herum, ist das Ergebnis mit Typtest besser als das ohne.
% lt(s(s(0)), P) ohne Typtest: P = s(s(s(_G227))).
% lt(s(s(0)), P) mit Typtest:
% P = s(s(s(0)));
% P = s(s(s(s(0))));
% usw.
%
% Das Ergebnis eines Aufrufs mit zwei Variablen ändert sich ebenfalls.
% Ohne Typtest findet Prolog alle Paare s(X) und X, also alle nebeneinander liegenden Zahlenpaare.
% Mit Typtest findet Prolog "erst einmal" alle Zahlen, die größer sind als s(0), gepaart mit s(0).

add(0, X, X).
add(s(X), Y, s(R)) :- 
    peano(X),
    peano(Y),
    peano(R),
    add(X, Y, R).

% Hier sieht es ähnlich aus. Grundlegend gesagt: Prolog probiert alle Peano-Zahlen, die es finden kann, durch.
% Sinnvoller wäre für einen Typtest daher:
% add(0, X, X).
% add(s(X), Y, s(R)) :- 
%    add(X, Y, R),
%    peano(X),
%    peano(Y),
%    peano(R).


%%%%% Aufgabe 3

% erste Version (nach dem Hinweis in der Aufgabe)
% uebergeordnet(+Kategorie, -Ueberkategorie)

uebergeordnet(Kategorie, Ueberkategorie) :- sub(Kategorie, _, Ueberkategorie).
uebergeordnet(Kategorie, Ueberkategorie) :-
    sub(Kategorie, _, X),
    uebergeordnet(X, Ueberkategorie).
    
    
% zweite Version
% ebene_von(?Ebene, ?Kategorie)
ebene_von(Ebene, Kategorie) :- sub(Kategorie, Ebene, _). 
ebene_von(Ebene, Kategorie) :-
    reich(Kategorie),
    Ebene = reich.

uebergeordnet(Kategorie, Ebene, Ueberkategorie) :-
    (
        sub(Kategorie, _, Ueberkategorie);
        (
            sub(Kategorie, _, X),
            uebergeordnet(X, _, Ueberkategorie)
        )
    ),
    ebene_von(Ebene, Ueberkategorie).
    
% ?- uebergeordnet(menschenfloh, Ebene, Ist).
% Ebene = gattung,
% Ist = pulex ;
% Ebene = familie,
% Ist = pulicidae ;
% Ebene = ordnung,
% Ist = floehe ;
% Ebene = klasse,
% Ist = insekten ;
% Ebene = stamm,
% Ist = gliederfuesser ;
% Ebene = reich,
% Ist = vielzeller ;
% false.


%%%%% Aufgabe 4
% 4.1
% fertigungstiefen(?TeilA, ?TeilB, ?Tiefe)
fertigungstiefen(Teil, Teil, 0).
fertigungstiefen(TeilA, TeilB, 1) :-
    arbeitsschritt(TeilA, _, _, TeilB).
    
fertigungstiefen(TeilA, TeilB, Tiefe) :-
    arbeitsschritt(X, _, _, TeilB),
    TeilA \= X,
    fertigungstiefen(TeilA, X, BisDahin),
    Tiefe is BisDahin + 1.

% 4.3
% TeilA muss kein Zulieferteil sein, TeilB kein Endprodukt,
% da diese Vorgabe diese Prädikat ausschließlich eingeschränkt hätte.

% Dieses Prädikat ermittelt für jeden Fertigungspfad zwischen TeilA und TeilB
% die Anzahl der TeilA, die auf diesem Pfad gebraucht werden.
wird_benoetigt_fuer(TeilA, TeilB, Anzahl) :-
    arbeitsschritt(TeilA, Anzahl, _, TeilB).
    
wird_benoetigt_fuer(TeilA, TeilB, Anzahl) :-
    arbeitsschritt(TeilA, AnzahlAInX, _, X),
    wird_benoetigt_fuer(X, TeilB, AnzahlXInB),
    Anzahl is AnzahlAInX * AnzahlXInB.
    
benoetigte_Anzahl(TeilA, TeilB, Anzahl) :-
    findall(Anzahl1,
        wird_benoetigt_fuer(TeilA, TeilB, Anzahl1),
        Liste),
    sum_list(Liste, Anzahl).

% Dieses Prädikat bildet die Summer aller Ergebnisse von wird_benoetigt_fuer,
% also die Summe aller TeilA, die auf allen Pfaden zusammen in TeilB landen.