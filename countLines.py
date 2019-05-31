import os

lines = 0

for path, dir, files in os.walk('.'):
    if not path.startswith('.\\.git'):
        for file in files:
            if file.endswith('.moon'):
                with open(path + '\\' + file, 'r') as f:
                    print("Counting %s" % (path + '\\' + file))
                    for line in f:
                        if len(line.strip()) > 0:
                            lines += 1

print("%d lines counted" % lines)
