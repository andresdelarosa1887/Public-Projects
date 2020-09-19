

def compute_pay(h,r):
    if h> 40:
        pay= (r*40) + (1.5*(r*(h-40)))
    else:
        pay=r*h
    return pay

hour= input("Please enter the hours that you have worked as a dog")
ratez= input("Please enter the miserable rate you are paid")
hours= float(hour)
rate= float(ratez)

x=compute_pay(hours,rate)
print("Your weekly pay is",x)
