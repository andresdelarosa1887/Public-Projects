
import string
fhand= open('romeo.txt')
counts= dict()
for line in fhand:
    line= line.translate(str.maketrans('','', string.punctuation))
    line= line.lower()
    words= line.split()
    for word in words:
        if word not in counts:
            counts[word]= 1
        else:
            counts[word] += 1
lst= list()
for key,val in list(counts.items()):
    lst.append((val,key))
print(lst)
lst.sort(reverse=True)
for val,key in lst[:10]:
    print(key,val)
