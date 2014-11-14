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
ist_vorfahre(Vorfahre, X),
direkter_vorfahre_von(X, Nachkommende).