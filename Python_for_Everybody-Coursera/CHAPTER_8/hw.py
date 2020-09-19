
fname= input("Please enter the name of the document: ")
fhand= open(fname)
listname= list()
for line in fhand:
    words= line.strip()
    for word in words:
        listname.append(word)
    print(listname)
    listname.sort()
print(listname)
