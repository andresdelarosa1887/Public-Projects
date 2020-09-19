


ad=0
count=0
while True:
    value=input("Enter a number:")
    if type(value)=str:
        ad= ad+int(value)
        count= count + 1
        continue
    elif value=="done":
        break
    else:
        print("Invalid Input")
        continue
print(count, ad, ad/count)
