

def greet(lang):
    if lang=="es":
        return "Hola"
    if lang=="fr":
        return  "Bonjour"
    else:
        return "Hello"

print(greet("es"), "Gleen")


def addtwo(a,b):
    added= a+b
    return added

x= addtwo(3,5)
print(x)
