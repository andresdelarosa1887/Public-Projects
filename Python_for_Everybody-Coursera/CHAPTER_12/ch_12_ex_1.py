
import urllib.request, urllib.parse, urllib.error
from bs4 import BeautifulSoup
import ssl
import re
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

url = input('Enter - ')
html = urllib.request.urlopen(url, context=ctx).read()
soup = BeautifulSoup(html, 'html.parser')

sum= 0
tags = soup('tr')
for thing in tags:
    tags=thing.decode()
    links = re.findall('[0-9]+', tags)
    for link in links:
        if len (link)>0:
            linki= float(link)
            sum= linki + sum
            print("COMMENTS: ",linki,"ACUMULATED SUM: ", sum)

#for tag in tags:
    #print('TAG:', tag)
    #print('Contents:', tag.contents[0])
