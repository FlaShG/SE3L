
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
  verkauft(PID, 2013, _, VorjahrVerkauft),
  Bestand > 2 * VorjahrVerkauft.

% ladenhueter(-PID, -Kategorie, -Titel, -Autor, -Verlag, -Erscheinungsjahr)


%%%%% Aufgabe 3

% 1.
% Dieses Hilfsprädikat sucht die Id von je einem Produkt unter 10 Euro.
% "Kostet aktuell 10 euro" setzen wir gleich mit "kostete 2013 unter 10 euro",
% da alles andere mit dieser Datenbasis relativ wenig Sinn ergibt.
produkt_unter_10_euro(PID) :-
  produkt(PID, _, _, _, _, _, _),
  verkauft(PID, 2013, Preis, _),
  Preis < 10.
  
% produkt_unter_10_euro(-PID)
  
anzahl_produkte_unter_10_euro(Anzahl) :-
  aggregate_all(count, produkt_unter_10_euro(_), Anzahl).

% anzahl_produkte_unter_10_euro(-Anzahl)

% 2.
% Dieses Hilfsprädikat findet lediglich dem Umsatz eines Produkts zu einem besitmmten
% Jahr. Es könnte auch anderweitig benutzt werden, um weitere Daten zu erhalten,
% wie "in welchem Jahr hatte Produkt PID den Umsatz Umsatz?".
jahresumsatz(PID, Jahr, Umsatz) :-
  verkauft(PID, Jahr, Preis, Verkauft),
  Umsatz is Preis * Verkauft.
  
% jahresumsatz(?PID, ?Jahr, ?Umsatz)

gesamtumsatz_unter_500_euro(PID, Kategorie, Titel, Autor, Verlag, Erscheinungsjahr) :-
  produkt(PID, Kategorie, Titel, Autor, Verlag, Erscheinungsjahr, _),
  aggregate_all(sum(Umsatz), jahresumsatz(PID, _, Umsatz), Gesamtumsatz),
  Gesamtumsatz < 500.
  
% gesamtumsatz_unter_500_euro(-PID, -Kategorie, -Titel, -Autor, -Verlag, -Erscheinungsjahr)


% 3.
anzahl_ladenhueter(Anzahl) :-
  aggregate_all(count, ladenhueter(_, _, _, _, _, _), Anzahl).
  
% anzahl_ladenhueter(-Anzahl)


%%%%% Aufgabe 4


