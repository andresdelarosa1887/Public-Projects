#String comparison
word= "hi"
if word=="banana":
	print("All right, bananas.")
if word< "banana":
	print("Your word " + word + ", comes before banana")
elif word> "banana":
	print("Your word " + word + ", comes after banana")
else:
	print("all right, bananas")

#String Library (changing to lower case)
greet= "Hello Bob"
zap= greet.lower()
print(zap)

print(greet)
print("Hi There".lower())

#String directory
stuff="Hello world"
type(stuff)
dir(stuff)

#Searching a String
fruit= "banana"
pos= fruit.find("na")
print(pos)

aa= fruit.find("z")
print(aa)
