


largest = None
smallest = None
while True:
    num = input("Enter a number: ")
    if num == "done" : break
    if largest is None:
        largest=int(num)
    elif int(num)>largest:
        largest=int(num)
    if smallest is None:
        smallest=int(num)
    elif smallest>int(num):
        smallest=int(num)
print("Maximum is", largest)
print("Minimun is", smallest)
