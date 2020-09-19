import json
import urllib.request, urllib.parse, urllib.error

url = 'http://py4e-data.dr-chuck.net/comments_48117.json'
print('Retrieving', url)
uh = urllib.request.urlopen(url)
data = uh.read().decode()
print('Retrieved', len(data), 'characters')
try:
    js = json.loads(data)
except:
    js = None
#print(js)
index=0
total= len(js['comments'])
number=0
while index<total:
    numbert= js['comments'][index]['count']
    number= number + int(numbert)
    index = index + 1
    #print(index, numbert)
print('Count:', total)
print('The total number of comments is:', number)
