import os

lines = 0

counts = []

for path, dir, files in os.walk('.'):
    if not path.startswith('.\\.git'):
        for file in files:
            if file.endswith('.moon'):
                with open(path + '\\' + file, 'r') as f:
                    num_lines = 0
                    for line in f:
                        if len(line.strip()) > 0:
                            lines += 1
                            num_lines += 1
                    counts.append((num_lines, path + '\\' + file))

s = "%d lines in total" % lines
print(s)
print(len(s) * '~')
for (num, f) in sorted(counts, key = lambda x: x[0], reverse=True):
    print("%d\t%.2f%%\t%s" % (num, (num * 100.0) / lines, f))
