import re
numlist= list()
fhand= open('regex_sum.txt')
for line in fhand:
    line= line.rstrip()
    y=  re.findall('([0-9]+)', line)
    if len(y)>=1:
        numlist.append(y)
#print(numlist)
numlast= list()
for num in numlist:
    if len(num)>=1:
        for numi in num:
            ya= float(numi)
            numlast.append(ya)
print(sum(numlast))
