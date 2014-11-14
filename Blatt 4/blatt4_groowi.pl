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

% Zum Testen bitte in galaxy.pl einfügen:
% arbeitsschritt(galaxy2004,1,recycling,hyper_squeezer).

%%%% 4)
voraussetzung_mit_maschine(Produkt1,Maschine,Produkt2) :-
arbeitsschritt(Produkt1,_,Maschine,Produkt2);
(
    (
        arbeitsschritt(X,_,Maschine,Produkt2),
        voraussetzung(Produkt1,X)
    );
    (
        arbeitsschritt(X,_,AndereMaschine,Produkt2),
        AndereMaschine \= Maschine,
        voraussetzung_mit_maschine(Produkt1,Maschine,X)
    )
).

% Dieses Prädikat ermittelt die in der Aufgabe gesuchten Ergebnisse:
maschinenausfall_beeinflusst_herstellung_von(Maschine, Endprodukte) :-
findall(Produkt,
        (endprodukt(Produkt),
         voraussetzung_mit_maschine(_, Maschine, Produkt)
        ),
        Liste),
sort(Liste, Endprodukte).

%%%% 5)
fertigungstiefe(Teil1, Teil2, 1) :-
    arbeitsschritt(Teil1, _, _, Teil2).
    
fertigungstiefe(Teil1, Teil2, Tiefe) :-
    not(arbeitsschritt(Teil1, _, _, Teil2)),
    arbeitsschritt(Teil1, _, _, X),
    fertigungstiefe(X, Teil2, TiefereTiefe),
    Tiefe is TiefereTiefe + 1.

% Mit diesen zusätzlichen Daten in galaxy.pl findet dieses Prädikat
% beim Aufruf mit fertigungstiefe(box0815, galaxy2004, Tiefe)
% mehrere Tiefen (3 und 4):
%
% arbeitsschritt(box0815,1,montagewurst,zwischending).
% arbeitsschritt(zwischending,1,montagewurst,box0816).

%%%% 6)
