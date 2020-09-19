
count=0
fhand= open("mbox-short.txt")
emails= list()
solving= dict()
for line in fhand:
    line= line.rstrip()
    if line.startswith("From:"):
        word= line.split()
        email= word[1]
        count += 1
        emails.append(email)
for mail in emails:
    solving[mail]= solving.get(mail,0) + 1

biggestword= None
biggestnum= None
for k,v in solving.items():
    if biggestnum is None or v>biggestnum:
        biggestnum= v
        biggestword=k
print(biggestword, biggestnum)
