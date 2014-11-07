
%%%%% Aufgabe 1

% Variablen sind Paare aus Bezeichnern und einem gebundenen Wert.
% Dieser Wert kann sich im Verlauf z.B. einer Suche beliebig oft ändern.
% Eine Suche ist in der Logikprogrammierung eine Aktion, die bestimmte Informationen aus einer Datenbasis extrahiert. Diese Daten werden als Werte an Variablen gebunden.
% Dieses Binden der Werte wird als "Instanziieren" bezeichnet.


%%%%% Aufgabe 2

[medien].

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