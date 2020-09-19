
txt= 'but soft what light in yonder window breaks'
words= txt.split()
t= list()
for word in words:
    t.append((len(word),word))
t.sort(reverse=True)
res=list()
for lenght, word, in t:
    res.append(word)
print(res)
