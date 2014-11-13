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
%Es ist richtungsunabhängig und 

ist_vorfahre(Vorfahre, Nachkommender) :-
mutter_von(Vorfahre,Nachkommender);
vater_von(Vorfahre,Nachkommender).

vorfahren_von(Vorfahre, Nachkommende) :- 
ist_vorfahre(Vorfahre, Nachkommende);
vorfahren_von(X, Nachkommende),
ist_vorfahre(X, Nachkommende).