fhand= open('mbox-short.txt')
lista= list()
liste= list()
listi= list()
dicta= dict()
for line in fhand:
    line.rstrip()
    words= line.split()
    if len(words)==0 : continue
    if words[0]== 'From':
        lista.append(words[5])
for time in lista:
    separated= time.split(':')
    liste.append(separated[0])
for hour in liste:
    if hour not in dicta:
         dicta[hour]= 1
    else:
        dicta[hour] += 1
for k,v in list(dicta.items()):
    listi.append((k,v))
    listi.sort()
for k,v in listi:
    print(k,v)
