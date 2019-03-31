call build.bat
cp "Labyrinth.love" "./../release/Mac/Labyrinth.love"
cd ./../release/Mac
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -afzip "Labyrinth"
mv "Labyrinth.zip" ./../Mac.zip
cd "./../../Labyrinth"
