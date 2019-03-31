call build.bat
cp "Tower Defense.love" "./../release/Mac/Tower Defense.love"
cd ./../release/Mac
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -afzip "Tower Defense"
mv "Tower Defense.zip" ./../Mac.zip
cd "./../../Tower Defense"