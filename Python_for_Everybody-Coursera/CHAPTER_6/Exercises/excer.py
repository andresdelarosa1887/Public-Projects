text = "X-DSPAM-Confidence:    0.8475";
x= text.find(":")
y= text.find("5",x)
z= (text[x+1:y+1])
z= z.strip()
z=float(z)
print(z)
