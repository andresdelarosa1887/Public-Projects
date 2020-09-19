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
domaina= list()
domaine= dict()
for email in lst:
    indexa= email.find('@')
    domaina.append(email[indexa+1: 40])
for domaini in domaina:
    if domaini not in domaine:
        domaine[domaini]= 1
    else:
        domaine[domaini] += 1
print(domaine)
