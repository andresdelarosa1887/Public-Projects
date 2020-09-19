

    numlist= list()
    while (True):
        number= input("Please enter a number: ")
        if number== "done": break
        number= float(number)
        numlist.append(number)
    print(sum(numlist)/ len(numlist))
