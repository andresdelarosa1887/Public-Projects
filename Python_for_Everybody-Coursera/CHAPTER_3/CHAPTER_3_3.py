
score = input("Enter Score: ")
try:
    scores= float(score)
    if scores>=0.0 and scores<=1.0:
        if scores>=0.90:
            print("A")
        elif scores>=0.80:
            print("B")
        elif scores>=0.70:
            print("C")
        elif scores >= 0.60:
            print("D")
        elif scores<0.60:
            print("F")
    else:
        print("Please enter a number between 0.0 and 1.0, Thank You!")
except:
    print("Hello bro, check your code!")
