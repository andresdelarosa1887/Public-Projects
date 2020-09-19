
greet= "Hello Señor Bob"
nstr= greet.replace("Bob", "Jane")
print(nstr)
nstr= greet.replace("o","X")
print(nstr)

# Stripping white space
greet= "  Hello Bob  "
greet.lstrip() #to remove white space from the left
greet.hstrip() #to remove white space from the right
greet.strip() #to remove all white space
print(greet)

#Prefixes
line= "Please have a nice day"
line.startswith("Please") #returns true 
line.startwith("please") #is false because in the line it starts with a upcase
