word= 'there are no rules anymore'
d= dict()
for words in word:
    if words not in d:
        d[words]= 1
    else:
        d[words] += 1
print(d)
