
import urllib.request, urllib.parse, urllib.error
from bs4 import BeautifulSoup
import ssl
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

amigos= list()
friends = list()
url = 'http://py4e-data.dr-chuck.net/known_by_Fikret.html'
amigos.append(url)
repeticion= 5
posicion=3
while len(url)>0 and repeticion>0:
    repeticion= repeticion -1
    url= amigos.pop()
    html = urllib.request.urlopen(url, context=ctx).read()
    soup = BeautifulSoup(html, 'html.parser')
    tags = soup('a')
    tags= tags[posicion-1].get('href')
    amigos.append(tags)
    print("Retrieving:",url)
