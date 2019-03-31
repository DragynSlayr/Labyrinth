del "Tower Defense.love"
call compile.bat
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -x\.git -x\*.bat -x\*.moon -x\*.py -x\changes.txt -afzip "Tower Defense"
move "Tower Defense.zip" "Tower Defense.love"