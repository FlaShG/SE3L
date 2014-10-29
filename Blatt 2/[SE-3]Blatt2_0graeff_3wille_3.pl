
%%%%% Aufgabe 3

%% 1. + 3.
:- dynamic user/3, game/2, highscore/2.

% user(UserID, Name, Email)
user(4712, 'JohannDerGrosse', 'bigj@gmail.com').
user(20, 'XxXPussySlayerXxX', 'nina.wolf@gmx.de').
user(833, 'spaceninja2000', 'gates@microsoft.com').
user(3209, 'cr4zyH4xx0r', 'baumann@informatik.uni-hamburg.de').

% game(GameID, Name)
game(1, 'Space Invaders Online').
game(42, 'Handtuch-Simulator 2013').

% highscore(UserID, GameID, Highscore)
highscore(4712, 1, 41123).
highscore(833, 1, 20001).
highscore(20, 42, 10).
highscore(833, 42, 17).
highscore(4712, 42, 9).
highscore(3209, 42, 99999).


%% 2.
% user und game haben IDs, um Benutzer und Spiele in anderen Relationen identifizieren zu können.
% Hinzu kommen Name und beim Benutzer E-Mail-Adresse. Sie verraten mehr über Nutzer bzw. Spiel.
% highscore enthält die IDs von je einem Benutzer und einem Spiel, sowie die maximale
% Punktzahl dieses Benutzers in diesem Spiel.