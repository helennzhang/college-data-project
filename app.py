from flask import Flask, render_template
from flask_mysqldb import MySQL

app = Flask(__name__)
mysql = MySQL(app)


class Database:
    def __init__(self):

        app.config['MYSQL_HOST'] = '127.0.0.1'
        app.config['MYSQL_USER'] = 'root'
        app.config['MYSQL_PASSWORD'] = 'root'
        app.config['MYSQL_DB'] = 'project2'
        app.config['MYSQL_PORT'] = 8889
        mysql.init_app(app)
        self.conn = mysql.connect
        self.cursor = self.conn.cursor()

    def query_1(self):
        # write queries here!!!
        return 'HELLO'

    def query_2(self):
        # write some more queries here. yay!
        return ''


@app.route("/")
def main():
    db = Database()
    result1 = db.query_1()
    return render_template("index.html")


if __name__ == "__main__":
    app.run()
