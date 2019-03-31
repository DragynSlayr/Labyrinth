del "Labyrinth.love"
call compile.bat
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -x\.git -x\*.bat -x\*.moon -x\*.py -x\changes.txt -afzip "Labyrinth"
move "Labyrinth.zip" "Labyrinth.love"