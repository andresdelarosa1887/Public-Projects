biggest= 0
fhand= open('mbox-short.txt')
lista= list()
dicta= dict()
for line in fhand:
    line.rstrip()
    words= line.split()
    if len(words)==0 : continue
    if words[0]== 'From':
        lista.append(words[1])
for email in lista:
    if email not in dicta:
        dicta[email] = 1
    else:
        dicta[email] += 1
liste= list()
for key, value in list(dicta.items()):
    liste.append((value,key))
    if value> biggest:
        biggest= value
        email= key
liste.sort(reverse=True)
print(email, biggest)
