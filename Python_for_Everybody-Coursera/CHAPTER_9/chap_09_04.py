counts= dict()
print("Enter a line of text:")
line= input(" ")
words= line.split()
print("Words:", words)
for word in words:
    counts[word]= counts.get(word, 0) + 1
print("Counts", counts)

countsz= dict()
countsz['Chuck']= 1
countsz['fred']= 42
countsz['jan']= 100
for key in countsz:
    print(key, countsz[key])
