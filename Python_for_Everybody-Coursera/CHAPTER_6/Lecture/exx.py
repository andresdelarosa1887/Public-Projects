#Parsing and Extracting
data= "From Stephen.marquard@uct.ac.za Sat Jan 5 09:14:16 2008"
atpos= data.find("@")
print(atpos)
atss= data.find(" ",atpos) #here it starts at 21 and then goes and find the next space
print(atss)

host= data[atpos+1: atss] #Now we are extracting the part that we are interested in
print(host)
#this prints uct.ac.za
