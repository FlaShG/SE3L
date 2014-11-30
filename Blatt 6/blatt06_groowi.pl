%%%%%% Sascha Graeff, Frederik Wille

%%%%% Aufgabe 1
%%%% 1)

%% goldener_schnitt_aufsteigend(+Rekursionen, Resultat?)
% Rekursionsabbruch: Bei null Rekursionen ist das Resultat 2.
goldener_schnitt_aufsteigend(0, 2).
% Rekursionsschritt
goldener_schnitt_aufsteigend(Rekursionen, Resultat) :-
    Rekursionen >= 1, %abbruch, sonst unendliche Rekursion
    Rekursionen2 is Rekursionen -1, 
    goldener_schnitt_aufsteigend(Rekursionen2,Resultat1), 
    Resultat is 1+(1/Resultat1).

%% goldener_schnitt_absteigend(+Rekursionen, Resultat?)
%Rekursionsabbruch:
goldener_schnitt_absteigend_helper(0, X, X).
%Rekursionsschritt:
goldener_schnitt_absteigend_helper(Rekursionen, Zwischenresultat, Resultat) :-
    Rekursionen >= 1,
    Rekursionen2 is Rekursionen -1,
    Zwischenresultat2 is 1 + (1 / Zwischenresultat),
    goldener_schnitt_absteigend_helper(Rekursionen2, Zwischenresultat2, Resultat).
%Ruft rekursives Prädikat mit 2 als erstes Zwischenresultat auf
goldener_schnitt_absteigend(Rekursionen, Resultat) :-
    goldener_schnitt_absteigend_helper(Rekursionen, 2, Resultat).

%% Als guter Startwert hat sich 2 ergeben, dieser wird in Zeilen 7 und 25 benutzt.
%%der Abstieg ist endrekursiv, da das Prädikat als letztes sich selbst aufruft.

%Tests

%% ?- goldener_schnitt_aufsteigend(10, X).
%% X = 1.6180555555555556 ;
%% false.

%% ?- goldener_schnitt_absteigend(10, X).
%% X = 1.6180555555555556 ;
%% false.

%%%% 2)
/*
Die aufsteigende Loesung braucht bei 1 inference weniger, viel mehr Zeit als die absteigende loesung
Bei 1.000.000 Rekursionen braucht aufsteigend ueber eine Minute und absteigend weniger als eine Sekunde.
Von der Verstaendlichkeit aehneln sich die beiden Loesungen. Absteigend hat noch das Zwischenresultat, welches evtl nicht direkt klar ist
*/

%%%% 3)
% Es werden 24 Schritte benoetigt, um die ersten 10 Nachkommastellen genau zuberechnen.

%%%%% Aufgabe 2
%%%% 1)
% Gibt alle natuerlichen Zahlen aus.
% Wenn eine natuerliche Zahl als Resultat uebergebn wird, muss nach dem true mit . abgebrochen werden.
% nat_zahl(?Resultat)
nat_zahl(Resultat) :-
    nat_zahl_helper(0, Resultat).
nat_zahl_helper(Resultat, Resultat).
nat_zahl_helper(Zwischenresultat, Resultat) :-
    Zwischenresultat2 is Zwischenresultat + 1,
    nat_zahl_helper(Zwischenresultat2, Resultat).
    
%%%% 2)
% nat_zahl(?Resultat, +Grenze)
nat_zahl(Resultat, Grenze) :-
    nat_zahl_helper(0, Resultat, Grenze).
nat_zahl_helper(Resultat, Resultat, _).
nat_zahl_helper(Zwischenresultat, Resultat, Grenze) :-
    Zwischenresultat < Grenze,
    Zwischenresultat2 is% endrekursiv mit Integern:
%% etiefe2(Baum, Tiefe) :-
%%     etiefe2_rek(Baum, 1, Tiefe).
%% etiefe2_rek(Atom, Tiefe, Tiefe) :-
%%     atom(Atom).
%% etiefe2_rek(s(Links, _),Zwischenergebnis, Tiefe) :-
%%     Tiefe2 is Zwischenergebnis +1,
%%     etiefe(Links, Tiefe).
%% etiefe2_rek(s(_, Rechts),Zwischenergebnis, Tiefe) :-
%%     Tiefe2 is Tiefe +1,
%%     etiefe(Rechts, Tiefe). Zwischenresultat + 1,
    nat_zahl_helper(Zwischenresultat2, Resultat, Grenze). 

%%%% 3)

% goldener_schnitt_incr(+Rekursionen, -R)
goldener_schnitt_incr(Rekursionen,R) :-
    nat_zahl(Resultat, Rekursionen),
    goldener_schnitt_absteigend(Resultat, R).


%%%% 4)
/*
Auch wenn es schlecht zu erkennen ist, sollte es nach 5 oder 6 Schritten unter die Darstellungsgenauigkeit sinken.
*/

%%%%% Aufgabe 3
%%%% 1)
%% Typtest
% Einzelner Knoten ist auch ein Baum
s(Atom) :-
    atom(Atom).
% Rechterzweig ist ein Atom und Links ist ein Baum
s(s(_), Rechts) :-
    atom(Rechts).
% Links ist ein Atom und Rechts ein gültiger Baum
s(Links, s(_)) :-
    atom(Links).
% Beide Seiten sind Bäume
s(s(_),s(_)).
% Beide Seiten sind Atome (Nicht ganz sicher, ob dies nötig ist)
s(Links, Rechts) :-
    atom(Links),
    atom(Rechts).

%Tests
/*

*/

%%%% 2)
% Nicht endrekursiv:
% tiefe(+Baum, ?Tiefe)
% Tiefe eines Atomes ist 0
tiefe(Atom, 0) :-
    atom(Atom).
tiefe(s(Links, _), Tiefe) :-
    tiefe(Links, Tiefe1),
    Tiefe is Tiefe1 + 1.
tiefe(s(_, Rechts), Tiefe) :-
    tiefe(Rechts, Tiefe1),
    Tiefe is Tiefe1 + 1.

% endrekursiv mit Peanozahlen:
% etiefe(+Baum, ?Tiefe)
etiefe(Atom, Tiefe) :-
    atom(Atom),
    Tiefe = 0.
etiefe(s(Links, _), s(Tiefe)) :-
    etiefe(Links, Tiefe).
etiefe(s(_, Rechts), s(Tiefe)) :-
    etiefe(Rechts, Tiefe).

% endrekursiv mit Integern:
% etiefe2(+Baum, ?Tiefe)
etiefe2(Baum, Tiefe) :-
    etiefe2_rek(Baum, 0, Tiefe).
etiefe2_rek(Atom, Tiefe, Tiefe) :-
    atom(Atom).
etiefe2_rek(s(Links, _),Zwischenergebnis, Tiefe) :-
    Zwischenergebnis2 is Zwischenergebnis +1,
    etiefe2_rek(Links,Zwischenergebnis2, Tiefe).
etiefe2_rek(s(_, Rechts),Zwischenergebnis, Tiefe) :-
    Zwischenergebnis2 is Zwischenergebnis +1,
    etiefe2_rek(Rechts,Zwischenergebnis2, Tiefe).

%%%% 3)
maxtiefe(Baum, Ergebnis) :-
    findall(Tiefe, etiefe2(Baum, Tiefe), Liste),
    max_list(Liste, Ergebnis).

%%%% 4)
% maxtiefe2(+Baum, ?Ergebnis)
maxtiefe2(Baum, Ergebnis) :-
    maxtiefe2_helper(Baum, Ergebnis, 0).
% Abbruch der Rekursion bei einem Atom
maxtiefe2_helper(Baum, Ergebnis, Ergebnis) :-
    atom(Baum).

maxtiefe2_helper(s(A, B), Ergebnis, Zwischenergebnis) :-
    Zwischenergebnis2 is Zwischenergebnis + 1,
    maxtiefe2_helper(A, ErgebnisLinks, Zwischenergebnis2),
    maxtiefe2_helper(B, ErgebnisRechts ,Zwischenergebnis2),
    Ergebnis is max(ErgebnisLinks, ErgebnisRechts).

%%%% 5)

% minmaxtiefe2(+Baum, ?Max, ?Min)
minmaxtiefe2(Baum, Max, Min) :-
    minmaxtiefe2_helper(Baum, Max, Min, 0).
% Abbruch der Rekursion bei einem Atom
minmaxtiefe2_helper(Atom, Ergebnis, Ergebnis, Ergebnis) :-
    atom(Atom).

minmaxtiefe2_helper(s(A, B), Max, Min, Zwischenergebnis) :-
    Zwischenergebnis2 is Zwischenergebnis + 1,
    minmaxtiefe2_helper(A, MaxLinks, MinLinks, Zwischenergebnis2),%linker Baum
    minmaxtiefe2_helper(B, MaxRechts, MinRechts, Zwischenergebnis2),%rechter Baum
    Max is max(MaxLinks, MaxRechts),
    Min is min(MinLinks, MinRechts).

% Falls es true ausgibt, muss mit . abgebrochen werden
% balanciert(+Baum)
balanciert(Baum) :-
    minmaxtiefe2(Baum, Max, Min),
    Differenz is (Max - Min),
    (
        Differenz = 1;
        Differenz = 0
    ).