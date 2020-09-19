largest = None
smallest = None
while True:
    num = input("Enter a number: ")
    if num == "done" : break
    try:
        if largest is None:
            largest=int(num)
        elif int(num)>largest:
            largest=int(num)
        if smallest is None:
            smallest=int(num)
        elif smallest>int(num):
            smallest=int(num)
    except:
        print("Invalid input")
        continue
print("Maximum is", largest)
print("Minimum is", smallest)

# Enter 7, 2, bob, 10, and 4 and match the output below.
