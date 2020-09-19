import urllib.request, urllib.parse, urllib.error

Fhand= urllib.request.urlopen(‘http://www.dr-chuck.com/page.htm’)
For line in fhand:
	Print(line.decode().strip())
