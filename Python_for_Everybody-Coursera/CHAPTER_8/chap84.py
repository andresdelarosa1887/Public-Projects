fhand= open("romeo.txt")
ulist=list()
for line in fhand:
    ulist= line.rstrip()
    ulist=line.split()
    ulist= ulist.append(ulist)
    print(ulist)
