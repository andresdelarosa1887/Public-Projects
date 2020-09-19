
import urllib.request, urllib.parse, urllib.error
from bs4 import BeautifulSoup
import ssl
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

amigos= list()
friends = list()
url = input("Entrar url: ")
amigos.append(url)
repeticion=int(input("Entrar Repeticion:"))
posicion=int(input("Entrar Posicion:"))
while len(url)>0 and repeticion>0:
    repeticion= repeticion -1
    url= amigos.pop()
    html = urllib.request.urlopen(url, context=ctx).read()
    soup = BeautifulSoup(html, 'html.parser')
    tags = soup('a')
    tags= tags[posicion-1].get('href')
    amigos.append(tags)
    print("Retrieving:",url)
