
largest= None
for value in [9,31,12,3,74,15]:
    if largest is None:
        largest=value
    elif largest<value:
        largest=value
    print(value,largest)
print("The Largest value here is:", largest)
