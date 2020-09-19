print("Hello World")

count=0
xfile= open("stuff.rtf")
for lcd in xfile:
    count= count+1
    print(lcd)
print("Line count:", count)


fhand= open('mbox-short.txt')
inp= fhand.read()
print(len(inp))
print(inp[:20])

fhand= open('stuff.rtf')
for line in fhand:
    line= line.line.rstrip()
    if not line.startswith("From:"):
        continue
        print(line)

fhand= open('words.txt')
for line in fhand:
    line= line.rstrip()
print(line)


fname= input('enter the file name:')
try:
    fhand= open(fname)
except:
    print('File cannot be opened:', fname)
    quit()
count=0
for line in fhand:
    if line.startswith('Subject:'):
        count= count+1
print('There were', count, 'subject lines in', fname)
