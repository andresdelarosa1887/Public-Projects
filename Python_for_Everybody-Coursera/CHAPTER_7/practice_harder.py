fname = input("Enter file name: ")
fh = open(fname)

count=0
add=0
for line in fh:
    if line.startswith("X-DSPAM-Confidence:"):
        line= line.rstrip()
        x= line.find(":")
        z= (line[x+1:26])
        zi= float(z)
        add= add+zi
        count= count+1
print("Average spam confidence:", add/count)
