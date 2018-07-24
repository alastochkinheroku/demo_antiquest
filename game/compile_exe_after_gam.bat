REM Для склеивания набора строк в одну команду должен быть пробел и крышка на одной строке (без пробела на хвосте), на следующей сначала пробел.
..\\bin\\tadsrsc32 "antiquest.gam" -type html -add ^
 "../res/sounds/SaReGaMa_-_SaReGaMa_-_Fractal_Universe.ogg" ^
 "../res/sounds/bed-jumping.ogg" ^
 "../res/sounds/lostinspace.ogg" ^
 "../res/sounds/robotic-laugh.ogg" ^
 "../res/sounds/scifi-engine-startup.ogg" ^
 "../res/sounds/sportcars.ogg" ^
 "../res/sounds/destroy_enemy.ogg" ^
 "../res/sounds/hit_enemy.ogg" ^
 "../res/sounds/hit_mine.ogg" ^
 "../res/sounds/Capashen_-_Departure__Electro_.ogg"^
 "../res/sounds/bed-jumping.ogg" ^
 "../res/sounds/lostinspace.ogg" ^
 "../res/sounds/robotic-laugh.ogg"

..\\bin\\maketrx32 ..\\bin\\htmlt2.exe "antiquest.gam" "antiquest.exe"
pause
