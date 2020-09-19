

hour= input("Please enter the number of hours")
rate= input("PLease enter the rate")
hours= int(hour)
rates= int(rate)
if hours >= 40:
    pay=  40*rates+(hours-40)*(rates*1.5)
if hours < 40 :
    pay= hours*rates
print("The pay is", pay)
