
#Excercise number 5
stuff= "X-DSPAM-Confidence:0.8475"
numb= stuff.find(":")
numbtw= stuff.find("5",numb)
final= stuff[numb+1:numbtw+1]
print(final)
final= float(final)
