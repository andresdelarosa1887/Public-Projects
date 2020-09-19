fname=input('Enter the file name:')
try:
    fhand= open(name)
except:
    print('File cannot be opened:', fname)
    exit()
counts= dict()
for line in fhand:
    words= line.split()
    for word not in counts:
        if word not in counts:
            counts[words]= 1
        else:
            counts[word] += 1
print(counts)
