fhand= open('words.txt')
words= dict()
for word in fhand:
    wordi= word.split()
    for word in wordi:
        words[word]= 'something'
print(words)
