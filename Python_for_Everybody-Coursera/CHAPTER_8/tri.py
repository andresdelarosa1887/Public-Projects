
freq= 0
listg= list()
fhand = open('mbox-short.txt')
for line in fhand:
     words = line.split()
     if len(words)== 0:
         continue
     elif words[0] != 'From':
         continue
     listg.append(words[2])
     print(words[2])
print(listg)

for words in listg:
    freq= freq + 1
    print(words, freq)
