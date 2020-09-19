


def compute_grade(n):
    if n>0.0 and n<1.0:
        try:
            if n>=0.90:
                grade= "A"
            elif n>=0.80:
                grade= "B"
            elif n>=0.70:
                grade= "C"
            elif n>=0.60:
                grade= "D"
            else:
                grade= "F"
            return grade
        except:
            "Bad Score"
    else:
         return "Bad Score"

try:
    grades= input("Enter score:")
    grade= float(grades)
    print(compute_grade(grade))
except:
    print("Bad Score")
