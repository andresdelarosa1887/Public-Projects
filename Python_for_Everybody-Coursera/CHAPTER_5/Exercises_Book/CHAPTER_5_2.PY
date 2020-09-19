
ad=0
count=0
mins= None
maxs=None
while True:
    value=input("Enter a number:")
    if value=="done":
        break
    try:
        if mins is None:
            mins=int(value)
        elif int(value)<mins:
            mins=int(value)
        if maxs is None:
            maxs=int(value)
        elif int(value)>maxs:
            maxs=int(value)
        ad= ad+int(value)
        count= count + 1
        continue
    except:
        print("Invalid Data")
        continue
print(count, ad, ad/count, mins, maxs)
