call build.bat
cp "Tower Defense.love" "./../build/Tower Defense.love"
cd ./../build
mv "Tower Defense.love" TD.love
cp ../love.exe love.exe
copy /b love.exe + TD.love TD.exe
mv TD.exe "Tower Defense.exe"
rm TD.love
rm love.exe
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -afzip "Tower Defense"
mv "Tower Defense.zip" ./../release/Windows.zip
cd "./../Tower Defense"