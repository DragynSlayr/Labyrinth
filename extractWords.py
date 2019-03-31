import os
import string

num_lines = 0

files = []
ignore = [".git", "assets"]
key_words = {}
SPLIT_CHAR = "\\"
if os.uname()[0] == "Linux":
    SPLIT_CHAR = "/"

brackets = [("[", "]"), ("{", "}"), ("(", ")"), ("\"", "\"")]

to_remove = string.digits + string.punctuation + string.whitespace


def removeChars(word, chars):
    s = ""
    for letter in word:
        if letter not in chars:
            s += letter
    return s


to_remove = removeChars(to_remove, ".")
to_remove = removeChars(to_remove, "_")
to_remove = removeChars(to_remove, "\\")


def parseDirs(arg, dirname, names):
    global files
    splitted = dirname.split(SPLIT_CHAR)
    if len(splitted) > 1:
        if not splitted[1] in ignore:
            for name in names:
                if name.split(".")[1] == "moon":
                    files.append(dirname + SPLIT_CHAR + name)


os.path.walk(".", parseDirs, "")


def readFile(name):
    global num_lines
    opened = open(name, "r")
    temp = opened.readlines()
    opened.close()
    num_lines += len(temp)
    lines = []
    for line in temp:
        line = line.strip()
        if len(line) > 0 and not line.startswith("--"):
            lines.append(line)
    return lines


def getLeftIndex(key, letter):
    for i in range(len(key)):
        if key[i] == letter:
            return i


def getRightIndex(key, letter):
    for i in range(len(key))[::-1]:
        if key[i] == letter:
            return i


def removeBrackets(key, left, right):
    while left in key and right in key:
        idx1 = getLeftIndex(key, left)
        idx2 = getRightIndex(key, right)
        key = key[:idx1] + key[idx2 + 1:]
    return key


def isInt(key):
    try:
        int(key)
        return True
    except ValueError:
        return False


def addKey(key):
    global key_words
    symbols = [
        "\\", "(", ")", "{", "}", "[", "]", "<", ">",
        "#", ".", "!", "=", "-", "+", "*", "%", "/"
    ]
    for symbol in symbols:
        key = key.replace(symbol, " ")
    removable = ["!", ",", "~", "@", ":"]
    for k in key.split(" "):
        for r in removable:
            k = k.replace(r, "")
        if len(k) > 0 and not isInt(k):
            key_words[k] = 0


for i in range(len(files)):
    file_name = files[i]
    lines = readFile(file_name)
    for line in lines:
        if line.startswith("@"):
            key = removeChars(line.split(" ")[0], "@")
            for b_type in brackets:
                b_l, b_r = b_type
                key = removeBrackets(key, b_l, b_r)
            addKey(key)
        if line.startswith("export"):
            key = line
            for b_type in brackets:
                b_l, b_r = b_type
                key = removeBrackets(key, b_l, b_r)
            addKey(key)
        if "." in line:
            key = line
            for b_type in brackets:
                b_l, b_r = b_type
                key = removeBrackets(key, b_l, b_r)
            addKey(key)
        if ":" in line:
            key = line
            for b_type in brackets:
                b_l, b_r = b_type
                key = removeBrackets(key, b_l, b_r)
            addKey(key)

print("Words: " + str(len(key_words.keys())))
opened = open("words.txt", "w")
keys = sorted(key_words.iterkeys())
for i in range(len(keys)):
    key = keys[i]
    opened.write(key)
    if not i == len(keys) - 1:
        opened.write("\n")
opened.close()
key_words = {}
print("Lines: " + str(num_lines))
