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
                ACTCM25, ACTCM75, SAT_AVG_ALL FROM education_mega WHERE INSTNM = %s", (name.upper(),))
        row = self.cursor.fetchone()
        json = {
            'school_name': name,
            'city': row[0],
            'state': row[1],
            'zip': row[2],
            'ugds': row[3],
            'url': row[4],
            'admit_rate': row[5],
            'act_25': row[6],
            'act_75': row[7],
            'sat_avg': row[8]
        }
        if row is not None:
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


@app.route("/location/data", methods=["POST"])
def get_data():
    data = request.json
    city = data['city']
    state = data['state']
    zip_code = data['zip']
    if (city == '' and state == '' and zip_code == ''):
        return "No input", 404

    query = ("SELECT INSTNM, CITY, STABBR, ZIP, UGDS, INSTURL, ADM_RATE_ALL,"
             "ACTCM25, ACTCM75, SAT_AVG_ALL FROM education_mega WHERE ")
    if city != '':
        query += "CITY = '" + city + "'"
    if state != '':
        if city != '':
            query += " AND STABBR = '" + state + "'"
        else:
            query += "STABBR = '" + state + "'"
    if zip_code != '':
        if city != '' or state != '':
            query += " AND ZIP = " + zip_code
        else:
            query += "ZIP = " + zip_code

    db = Database()
    db.cursor.execute(query)
    records = db.cursor.fetchall()
    result = []
    for row in records:
        result.append({
            'school_name': row[0],
            'city': row[1],
            'state': row[2],
            'zip_code': row[3],
            'ugds': row[4],
            'url': row[5],
            'admit_rate': str(row[6]),
            'act_25': row[7],
            'act_75': row[8],
            'sat_avg': row[9]
        })
    return jsonify(result)


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
