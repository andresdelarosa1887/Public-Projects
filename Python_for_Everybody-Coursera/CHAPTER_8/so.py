
fh= open("romeo.txt")
lst= list()
for line in fh:
    wds= line.split()
    for word in wds:
        if word not in lst:
            lst.append(word)
    lst.sort()
print(lst)
