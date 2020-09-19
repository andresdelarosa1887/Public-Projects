def print_lyrics():
    print("I'm a lumberjack, and I'm okay.")
    print("I Sleep all night and work all day.")


print("Yo")
print_lyrics()


def greet(lang):
    if lang=="es":
        print("Hola")
    if lang=="fr":
        print("Bonjour")
    else:
        print("Hello")
x= input("Please enter your language")
greet(x)

def hole():
    return "Brother"
print(hole(), "James")

def greet(lang):
    if lang=="es":
        return "Hola"
    if lang=="fr":
        return  "Bonjour"
    else:
        return "Hello"

print(greet("en"), "Gleen")
