
count=0
total=0
while True:
    inp=input("please enter a number:")
    if  inp=="done": break
    value=float(inp)
    total= total + value
    count= count + 1
print("the average is= ",total/count)

numlist= list()
while True:
    inp=input("please enter a number:")
    if  inp=="done": break
    value=float(inp)
    numlist.append(value)
print("The average is:",sum(numlist)/ len(numlist))

abc= "Something useful brother"
stuff= abc.split()
for words in abc:
    print(words)


lint= "A lot of          spaces"
lont= lint.split()
print(lont)
print(len(lont))

len= "no;delimiter;indicated;here"
tun= len.split(";")
print(tun)

fhand= open("mbox-short.txt")
for line in fhand:
    line=line.rstrip()
    if not line.startswith("From "): continue
    words= line.split()
    print(words[2])

line= "From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008"
some= line.split()
email= some[1]
name= email.split("@")
print(name[0])
