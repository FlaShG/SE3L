
%%%%% Aufgabe 1

?- mutter_von(P1,X),vater_von(X,P2).
% P1 ist die Großmutter väterlicherseits von P2.

?- mutter_von(X,P1),mutter_von(X,P2),P1\=P2.
% P1 und P2 haben dieselbe Mutter, sind aber nicht dieselbe Person.
% Sie sind also (Halb-)Geschwister.

?- mutter_von(X,P1),mutter_von(Y,X),mutter_von(Y,P2), X\=P2.
% X und P2 (Halb)-Geschwister und X ist die Mutter von P1.
% P2 ist also Tante/Onkel von P1 - mütterlicherseits.

?- vater_von(X,P1),mutter_von(Y,X),mutter_von(Y,Z),mutter_von(Z,P2),X\=Z.
% P1 ist Cousin von P2.
% Sie haben dieselbe Großmutter - P1 väterlicher-, P2 mütterlicherseits.

?- mutter_von(X,P1),mutter_von(Y,P2),vater_von(Z,P1)
|  ,vater_von(Z,P2),P1\=P2,X\=Y.
% P1 und P2 sind Halbgeschwister, da sie denselben Vater haben, die Mutter
% allerdings jeweils eine andere ist. Z ist bekannt als "der Stecher".

