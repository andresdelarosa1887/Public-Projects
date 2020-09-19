fh= open("mbox-short.txt")
for line in fh:
    line=line.rstrip()
    if not line.startswith("From "): continue
    words= line.split()
    print(words[1])
print("There were 27 lines in the file with From as the first word")
