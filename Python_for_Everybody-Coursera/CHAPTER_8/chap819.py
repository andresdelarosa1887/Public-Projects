

fh= open("romeo.txt")
lst= list()
for line in fh:
    line= line.rstrip()
    wds= line.split()
    for x not in wds:
        

print(wds)
