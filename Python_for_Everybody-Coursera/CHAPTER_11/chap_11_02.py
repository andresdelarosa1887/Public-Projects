
import re
x= 'My 2 favorite numbers are 19 and 42'
y= re.findall('[0-9]',x)
print(y)


import re
x= 'My 2 favorite numbers are 19 and 42'
y= re.findall('[aeiou]+',x)
print(y)

import re
x= 'From: Using the: character'
y= re.findall('^F.+:', x)
print(y)
