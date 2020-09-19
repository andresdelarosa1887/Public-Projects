
import re
fhand= open('mbox-short.txt')
for line in fhand:
    line= line.rstrip()
    if re.search('From:', line):
        count+=1
        print(line,count)

fhand= open('mbox-short.txt')
for line in fhand:
    line= line.rstrip()
    if re.search(^'From:', line):
        count+=1
        print(line,count)

        
