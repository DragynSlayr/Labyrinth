rm "./../release/Mac.zip"
rm "./../release/Windows.zip"
rm "./../release/Labyrinth.zip"
call build-mac.bat
call build-windows.bat
cd ./../release
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -x\Mac -x\Windows -afzip "Labyrinth"
cd "./../Labyrinth"