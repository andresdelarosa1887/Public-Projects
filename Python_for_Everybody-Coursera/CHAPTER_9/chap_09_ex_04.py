fhand= open('mbox-short.txt')
lst= list()
dicti= dict()
largest= 0
for line in fhand:
    line.rstrip()
    words= line.split()
    if line.startswith('From'):
        if words[0]== 'From':
            lst.append(words[1])
for day in lst:
    if day not in dicti:
        dicti[day]=1
    else:
        dicti[day] += 1
print(dicti)

for key in dicti:
    if dicti[key]> largest:
        largest= (dicti[key])
        email= key
print(email, largest)
