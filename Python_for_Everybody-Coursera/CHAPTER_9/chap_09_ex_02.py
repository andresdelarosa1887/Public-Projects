
fhand= open('words.txt')
words= dict()
for word in fhand:
    wordi= word.split()
    for word in wordi:
        if word not in words:
            words[word]= 1
        else:
            words[word] += 1
print(words)
