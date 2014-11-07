
%%%%% Aufgabe 1

% Variablen sind Paare aus Bezeichnern und einem gebundenen Wert.
% Dieser Wert kann sich im Verlauf z.B. einer Suche beliebig oft ändern.
% Eine Suche ist in der Logikprogrammierung eine Aktion, die bestimmte Informationen aus einer Datenbasis extrahiert. Diese Daten werden als Werte an Variablen gebunden.
% Dieses Binden der Werte wird als "Instanziieren" bezeichnet.


%%%%% Aufgabe 2

% Wir geben das aktuelle Jahr bei der Benutzung des Prädikats an.
% Der Parameter "Jahr" kriegt also aktuell den Wert 2014.

% 1.
produkte_mit_preissteigerung(Jahr, PID, Kategorie, Titel, Autor, Verlag, Erscheinungsjahr) :-
  produkt(PID, Kategorie, Titel, Autor, Verlag, Erscheinungsjahr, _),
  verkauft(PID, Jahr, Preis, _),
  verkauft(PID, Vorjahr, VorjahresPreis, _),
  VorjahresPreis < Preis,
  Vorjahr =:= Jahr - 1.

% produkte_mit_preissteigerung(?Jahr, -PID, -Kategorie, -Titel, -Autor, -Verlag, -Erscheinungsjahr)

  
% 2.
erstmals_im_katalog(PID, ErstesJahr) :-
  produkt(PID, _, _, _, _, _, _),
  verkauft(PID, ErstesJahr, _, _),
  not((verkauft(PID, JahrDavor, _, _),
      JahrDavor < ErstesJahr)).

% erstmals_im_katalog(+PID, -ErstesJahr)

% Hier ist das aktuelle Jahr "2014" hardcoded.
% Grund ist die Formulierung der Aufgabe.

% 3.
ladenhueter(PID, Kategorie, Titel, Autor, Verlag, Erscheinungsjahr) :-
  produkt(PID, Kategorie, Titel, Autor, Verlag, Erscheinungsjahr, Bestand),
  not((verkauft(PID, VorZweiJahren, _, _),
      VorZweiJahren < 2013)),
  verkauft(PID, 2013, _, VorjahrVerkauft),,
  Bestand > 2 * VorjahrVerkauft.

% ladenhueter(-PID, -Kategorie, -Titel, -Autor, -Verlag, -Erscheinungsjahr)


%%%%% Aufgabe 3

