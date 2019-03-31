rm "Tower Defense.love"
moonc .
zip "Tower Defense.love" . -r -x .git/\* -x \*.bat -x \*.moon -x \*.py -x \*.sh -x changes.txt
