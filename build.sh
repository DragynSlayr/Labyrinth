rm "Labyrinth.love"
moonc .
zip "Labyrinth.love" . -r -x .git/\* -x \*.bat -x \*.moon -x \*.py -x \*.sh -x changes.txt
