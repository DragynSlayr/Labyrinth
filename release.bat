rm "./../release/Mac.zip"
rm "./../release/Windows.zip"
rm "./../release/Tower Defense.zip"
call build-mac.bat
call build-windows.bat
cd ./../release
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -x\Mac -x\Windows -afzip "Tower Defense"
cd "./../Tower Defense"