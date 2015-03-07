
import sqlite3

conn = sqlite3.connect(":memory:")

# Execute init script
init_sql = open('story.sql', 'r').read()
sqlite3.complete_statement(init_sql)
## print "sql = " + init_sql
c = conn.cursor()
c.executescript(init_sql)
conn.commit()

def exec_sql(sql):
    c.execute(sql)
    conn.commit()
    print "OK: " + sql

exec_sql("INSERT INTO person (id, disp_name) VALUES (1000, 'test')")


#
# Alternative
#

c.executemany("INSERT INTO person (id, disp_name) VALUES (?, ?)", [
    (1, 'slava'), (2, 'alice'), (3, 'lena'), (4, 'miku'),
    (5, 'ulyana'), (6, 'olga'), (7, 'semen')
])
conn.commit()

print "Rows in person:"
for row in c.execute('SELECT id, disp_name FROM person ORDER BY id'):
    print row

c.close()

print "DONE."

conn.close()


