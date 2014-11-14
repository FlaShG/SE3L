%%%%% Aufgabe 1

%% A ist das Geburtsdatum von B
%

%% A ist im Turnier gegen B angetreten
% symmetrisch

%% A ist älter als B
% transitiv

%% A und B sind Geschwister
% symmetrisch
% transitiv

%% A ist eine (echte oder unechte) Teilmenge von B
% transitiv

%% A und B sind in der gleichen Straße
% symmetrisch
% reflexiv
% transitiv


%%%%% Aufgabe 2
%Findet alle Vorfahren einer Person.
%Es ist richtungsunabhängig, da auch ein Vorfahre oder nur Variablen eigegeben werden können und das Prädikat auch dafür die richtigen Ergebnisse liefert
%Es ist terminierungssicher, solang sich in der Datenbank keine Schleifen befinden, die in dieser Datenbank nicht auftreten sollten.

direkter_vorfahre_von(Vorfahre, Nachkommender) :-
mutter_von(Vorfahre,Nachkommender);
vater_von(Vorfahre,Nachkommender).

ist_vorfahre(Vorfahre, Nachkommende) :- 
direkter_vorfahre_von(Vorfahre, Nachkommende);
(
direkter_vorfahre_von(X, Nachkommende),
ist_vorfahre(Vorfahre, X)
).


%%%%% Aufgabe 3
%%%% 1)
voraussetzung(Produkt1,Produkt2) :-
arbeitsschritt(Produkt1,_,_,Produkt2);
(
arbeitsschritt(X,_,_,Produkt2),
voraussetzung(Produkt1,X)
).

%%%% 2)
% wird_benoetigt_von gibt die benoetigten Teile fuer ein endprodukt
% kann dazu benutzt werden, um bei nicht mehr lieferbaren Teilen betroffenen Endprodukte zu finden
wird_benoetigt_von(Teil,Produkt) :-
voraussetzung(Teil,Produkt),
endprodukt(Produkt).

%%%% 3)
% vorraussetzung/2 terminiert genau dann sicher, wenn es keinen Fall vorraussetzung(X, _, _ X) gibt,
% also vorraussetzung/2 nicht reflexiv ist.
% vorraussetzung/2 könnte so abgeändert werden, um dies zu testen:
voraussetzung_safe(Produkt1,Produkt2) :-
voraussetzung_safe_helper(Produkt1,Produkt2,Produkt2).

voraussetzung_safe_helper(Produkt1,Produkt2,ProduktZwei) :-
arbeitsschritt(Produkt1,_,_,Produkt2);
(
    arbeitsschritt(X,_,_,Produkt2),
    not(X = ProduktZwei),
    voraussetzung_safe_helper(Produkt1,X,ProduktZwei)
).

% Zum Testen bitte einkommentieren:
% arbeitsschritt(galaxy2004,1,recycling,hyper_squeezer).

%%%% 4)
