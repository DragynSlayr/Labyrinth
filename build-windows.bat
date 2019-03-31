call build.bat
cp "Labyrinth.love" "./../build/Labyrinth.love"
cd ./../build
mv "Labyrinth.love" TD.love
cp ../love.exe love.exe
copy /b love.exe + TD.love TD.exe
mv TD.exe "Labyrinth.exe"
rm TD.love
rm love.exe
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -afzip "Labyrinth"
mv "Labyrinth.zip" ./../release/Windows.zip
cd "./../Labyrinth"