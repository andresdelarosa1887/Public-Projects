
fhand = open('mbox-short.txt')
count = 0
for line in fhand:
    line= line.rstrip()
    words= line.split()
    if line.startswith("From"):
        if words[0]== "From":
            count += 1
            print(words[2], count)
