x,y= ('glen', 'sophia')
print(y)

d= dict()
d['csev']= 2
d['swen']=4
for (k,v) in d.items():
    print(k,v)

d= {'a':10, 'b':1, 'c':22}
d.items()
print(sorted(d.items()))

d= {'a':10, 'b':1, 'c':22}
t= sorted(d.items())
for k,v in sorted(d.items()):
    print(k,v)

c= {'a':10, 'b':1, 'c':22}
tmp= list()
for k,v in c.items():
    tmp.append((v,k))

print(tmp)
temp= sorted(tmp, reverse=True)
print(temp)
