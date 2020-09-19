
ad=0
count=0
while True:
    value=input("Enter a number:")
    if value=="done":
        break
    elif value[0]== "b":
        print("Invalid Input")
        continue
    else:
        ad= ad+int(value)
        count= count + 1
        continue
print(count, ad, ad/count)
