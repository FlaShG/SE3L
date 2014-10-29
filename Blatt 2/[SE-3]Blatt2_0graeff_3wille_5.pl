
%%%% Aufgabe 4

% Ein Fakt ist etwas, das einen Zustand ausdrückt, der der Wahrheit entspricht.
% In Prolog ist ein Fakt eine elementare Klausel, die von Prolog als Anlass genommen wird,
% den beschriebenen Sachverhalt als wahr zu betrachten.
% Beispiel:
assert(istBlau(schlumpfine)).

% Eine Regel ist etwas, das nach dem Schema "wenn x, dann y" faktisch beschreibt,
% dass y ein Fakt ist, wenn auch x einer ist.
% Beispiel:
istSchlumpf(Ding) :- istBlau(Ding), istKlein(Ding), hatSchwanz(Ding).

% Eine Anfrage ist etwas, das als Reaktion die Herausgabe von Fakten provozieren soll.
% Beispiel:
istSchlumpf(darthVader).

% In Prolog stehen hinter allen drei Begriffen elementare Klauseln.
% Während man mit Fakten und Regeln das Wissen des Systems über den Kontext erweitert,
% dienen Anfragen dazu, aus deren Kombination entsehendes, neues Wissen, an den Benutzer
% zurück zu geben.