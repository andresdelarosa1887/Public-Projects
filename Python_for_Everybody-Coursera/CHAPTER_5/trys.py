

ad=0
count=0
while True:
    value=input("Enter a number:")
    if value=="done":
        break
    else:
        try:
            ad= ad+int(value)
            count= count + 1
            continue
        except:
            print("Invalid Data")
            continue
print(count, ad, ad/count)
