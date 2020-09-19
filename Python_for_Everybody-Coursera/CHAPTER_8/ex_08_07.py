
numlist= list()
while True:
    value= input("Please enter a number:")
    if value== "done": break
    value= int(value)
    numlist.append(value)
print("The minimun number in this list is: ", min(numlist),"The maximun number in this list is:", max(numlist))
