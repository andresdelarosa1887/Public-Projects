import sqlite3
conn = sqlite3.connect('andresdb.sqlite')
cur = conn.cursor()

cur.execute('DROP TABLE IF EXISTS adjudicaciones')
cur.execute('''
CREATE TABLE Counts (email TEXT, total_adjudicado INTEGER, cantidad_contratos INTEGER)''')
