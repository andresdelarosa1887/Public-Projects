
fname = input("Enter a file name:")
fhand= open(fname)
count= 0
for line in fhand:
    words = line.split()
    if len(words)== 0: continue
    if words[0] != 'From' : continue
    print(words[1])
    count+= 1
print("They were ", count, "lines in the file with From as the first word")
