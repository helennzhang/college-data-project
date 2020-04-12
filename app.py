from flask import Flask, render_template, request, abort, jsonify
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

    def query_profile(self, name):
        self.cursor.execute(
            "SELECT CITY, STABBR, ZIP, UGDS, INSTURL, ADM_RATE_ALL,\
                ACTCM25, ACTCM75, SAT_AVG_ALL FROM education_mega WHERE INSTNM = %s", (name,))
        result = self.cursor.fetchone()
        json = {
            'school_name': name,
            'city': result[0],
            'state': result[1],
            'zip': result[2],
            'ugds': result[3],
            'url': result[4],
            'admit_rate': result[5],
            'act_25': result[6],
            'act_75': result[7],
            'sat_avg': result[8]
        }
        if result is not None:
            return json
        else:
            return None

    def query_2(self):
        # write some more queries here. yay!
        return ''


@app.route("/")
def main():
    db = Database()
    return render_template("index.html")


@app.route('/location')
def location():
    return render_template('location.html')


@app.route('/profile', methods=['POST'])
def profile():
    name = request.form['school_name']
    db = Database()
    school_data = db.query_profile(name)
    if school_data is None:
        abort(404)
    else:
        return render_template('profile.html', data=school_data)


@app.route('/score')
def score():
    return render_template('score.html')


@app.route('/cost')
def cost():
    return render_template('cost.html')


if __name__ == "__main__":
    app.run()
