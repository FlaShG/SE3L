
%%%%% Aufgabe 2

[medien].

%% 1.
?- produkt(PId, Kategorie, Titel, Autor, Verlag, Erscheinungsjahr, 0).
% "Blutrache" von Michael Wolf scheint nicht mehr vorrätig zu sein.

%% 2.
?- produkt(PId, buch, Titel, Autor, Verlag, Erscheinungsjahr, _),
   verkauft(PId, Jahr, _, _),
   2014 - Jahr > 10.
% Offenbar ist nur "Winterzeit" von Michael Wolf seit mehr als 10 Jahren verfügbar.

%% 3.
?- produkt(PId, buch, Titel, Autor, Verlag, Erscheinungsjahr, _),
   verkauft(PId, 2013, _, Verkauf2013),
   verkauft(PId, 2012, _, Verkauf2012),
   Verkauf2013 > Verkauf2012.
% "Winterzeit" von Michael Wolf und "Hoffnung" von Molly Sand erlebten 2013
% eine Verkaufssteigerung gegenüber dem Vorjahr.

%% 4.
?- produkt(PId, buch, Titel, Autor, Verlag1, _, _),
   produkt(PId, buch, Titel, Autor, Verlag2, _, _),
   Verlag1 \= Verlag2.
% Keines der gelisteten Bücher scheint im Verlauf der Zeit von einem anderen Verlag
% übernommen worden zu sein.

%% 5.
?-     produkt(PId, buch, Titel, Autor, Verlag, _, _),
   not(produkt(_, hoerbuch, Titel, Autor, _, _, _)).
% "Sonnenuntergang" von Sunsanne Hoffmann und "Blutrache" von Michael Wolf hatten noch nicht das Glück,
% für die Zielgruppe der Analphabeten zugänglich gemacht worden zu sein.
% Schreib' dich nicht ab. Lern' lesen und schreiben.

%% 6.
?- bagof(Lagerbestand, produkt(PId, Kategorie, Titel, Autor, Verlag, Erscheinungsjahr, Lagerbestand), Bestaende).