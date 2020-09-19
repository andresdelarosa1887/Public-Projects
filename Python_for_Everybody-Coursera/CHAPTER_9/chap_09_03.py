counts= dict()
names= ['csev', 'cwen', 'csev', 'zqian', 'cwen','zhu','zhu']
for name in names:
    if name not in counts:
        counts[name]= 1
    else:
        counts[name] += 1
print(counts)

#other efficient way to do the same thing

counts= dict()
names= ['csev', 'cwen', 'csev', 'zqian', 'cwen', 'zhu', 'zhu']
for name in names:
    counts[name]= counts.get(name,0) + 1
print(counts)
