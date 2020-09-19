
import sqlite3

conn= sqlite3.connect('music.sqlite')
cur = conn.cursor()
cur.execute("DROP TABLE IF EXISTS someghing")
cur.execute("DROP TABLE IF EXISTS something")
cur.execute("CREATE TABLE something (title TEXT, plays INTEGER)")
cur.execute("SELECT * FROM something")
cur.execute("INSERT INTO something(title,plays) VALUES(?, ?)", ("My Way",15))
cur.execute("INSERT INTO something(title,plays) VALUES(?, ?)", ("Hello",111))
conn.commit()
print("Tracks:")
cur.execute("SELECT title,plays FROM something")
for song in cur:
    print(song)
conn.close()
