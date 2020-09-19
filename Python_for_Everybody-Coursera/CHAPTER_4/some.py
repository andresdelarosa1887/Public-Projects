




hrs = input("Enter Hours:")
rate=input("Enter Rate:")
hrss= float(hrs)
ratess= float(rate)
def computepay(h,r):
    if h>40:
        pay= (r*40)+ (h-40)*(1.5*r)
    return pay
    if h<=40:
        pay= r*h
        return pay
p = computepay(hrss,ratess)
print("Pay",p)
