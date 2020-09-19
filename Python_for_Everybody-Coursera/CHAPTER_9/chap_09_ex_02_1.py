
fhand= open('mbox-short.txt')
lst= list()
dicti= dict()
for line in fhand:
    line.rstrip()
    words= line.split()
    if line.startswith('From'):
        if words[0]== 'From':
            lst.append(words[2])
for day in lst:
    if day not in dicti:
        dicti[day]=1
    else:
        dicti[day] += 1
print(dicti)
