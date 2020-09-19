fhand=open("mbox-short.txt")
lst= list()
lsta= list()
hours= dict()
for line in fhand:
    line= line.rstrip()
    words= line.split()
    if len(words)== 0: continue
    if words[0]== 'From':
        inter= words[5]
        lst.append(inter)
for time in lst:
    #print(time)
    sull= time.split(":")
    hour= sull[0]
    lsta.append(hour)
#print(lsta)
for hour in lsta:
    hours[hour]= hours.get(hour,0) + 1
#print(hours)
for k,v in sorted(hours.items()):
    print(k,v)
