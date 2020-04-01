import pymysql

db = pymysql.connect(host='127.0.0.1',
                     user='root',
                     passwd='root',
                     database='project2',
                     port=8889)

cursor = db.cursor()

print(db)
