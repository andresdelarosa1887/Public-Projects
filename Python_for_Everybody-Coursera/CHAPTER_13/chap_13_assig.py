import urllib.request, urllib.parse, urllib.error
import xml.etree.ElementTree as ET

url = 'http://py4e-data.dr-chuck.net/comments_48116.xml'

suma=0
print('Retrieving', url)
uh = urllib.request.urlopen(url)
data = uh.read()
tree = ET.fromstring(data)
counts = tree.findall('.//comment')
for item in counts:
    results = item.find('count').text
    numero= int(results)
    suma= suma + numero
print('La suma total es:', suma)
    #print(results)
    #item.find('count').text
