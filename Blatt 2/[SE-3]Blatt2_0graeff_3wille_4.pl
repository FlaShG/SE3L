
%%%%% Aufgabe 3

%% 3. (cont.)

['[SE-3]Blatt2_0graeff_3wille_3.pl'].

% Welche E-Mail-Adresse hat "JohannDerGrosse"?
?- user(_, 'JohannDerGrosse', EMail).

% Wer hat noch keinen Highscore in 'Space Invaders Online' erzielt
% (damit man es als Empfehlung um die Ohren gehauen kriegen kann)?
?- game(GameID, 'Space Invaders Online'),
   user(UserID, _, _),
   not(highscore(UserID, GameID, _)).

% Wie heißen die Verfügbaren Spiele?
?- game(_, Name).

% Welche IDs haben die Spieler, die in "Handtuch-Simulator 2013" geschummelt haben?
% Man kann im Spiel ohne Cheats maximal 20 Punkte erreichen.
?- game(GameID, 'Handtuch-Simulator 2013'),
   highscore(CheaterID, GameID, Score),
   Score > 20.

% Wie lautet die E-Mail-Adresse des Spielers mit dem weltweiten
% Highscore im Spiel "Space Invaders Online"?
?- game(GameID, 'Space Invaders Online'),
   highscore(UserID, GameID, Score),
   not(
    (highscore(_,GameID,HigherScore),
    HigherScore > Score)
   ),
   user(UserID, _, Email).