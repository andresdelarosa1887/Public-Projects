
Hours= input("PLease enter the hours worked")
Rate= input("Please enter the hourly rate")
try:
    Pay= int(Hours)*int(Rate)
    print("Your pay is", Pay)
except:
    print ("Error, please enter numeric input")
