

dicti= dict()
fhand= open('romeo.txt')
for word in fhand:
    words= word.split()
    for word in words:
        if word not in dicti:
            dicti[word]= 1
        else:
            dicti[word] += 1
#print(dicti)


#for key in dicti:
    #if dicti[key]> 1:
        #print(key, dicti[key])

lst= list(dicti.keys())
print(lst)
lst.sort()
for key in lst:
    print(key, dicti[key])
