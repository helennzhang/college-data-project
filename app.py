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
            "SELECT * FROM profile WHERE INSTNM = %s", (name.upper(),))
        row = self.cursor.fetchone()
        if row is None:
            return None
        json = {
            'school_name': row[0],
            'city': row[1],
            'state': row[2],
            'zip': row[3],
            'ugds': row[4],
            'url': row[5],
            'admit_rate': str(row[6]*100)[:5] + '%',
            'act_25': row[7],
            'act_75': row[8],
            'sat_avg': row[10]
        }
        return json

    def return_results(self, query):
        self.cursor.execute(query)
        records = self.cursor.fetchall()
        result = []
        for row in records:
            result.append({
                'school_name': row[0],
                'city': row[1],
                'state': row[2],
                'zip_code': row[3],
                'ugds': row[4],
                'url': row[5],
                'admit_rate': str(row[6] * 100)[:5] + '%',
                'act_25': row[7],
                'act_75': row[8],
                'sat_avg': row[10]
            })
        return result[:100]

    def return_cost_results(self, query):
        self.cursor.execute(query)
        records = self.cursor.fetchall()
        result = []
        for row in records:
            result.append({
                'school_name': row[0],
                'men': str(row[1]*100) + '%',
                'women': str(row[2]*100) + '%',
                'tuition_in': '$' + str(row[3]),
                'tuition_out': '$' + str(row[4])
            })
        return result


@app.route("/")
def main():
    db = Database()
    return render_template("index.html")


@app.route('/score/data', methods=["POST"])
def get_score_data():
    data = request.json
    act_low = data['act_low']
    act_high = data['act_high']
    act = data['act']
    sat_low = data['sat_low']
    sat_high = data['sat_high']
    sat = data['sat']
    both = data['both']

    query = ''

    if (act_low == act_high or sat_low == sat_high):
        return "Score range cannot be 0", 404

    if act == 1:
        query = "CALL filter_act(" + act_low + ", " + act_high + ")"
    elif sat == 1:
        query = "CALL filter_sat(" + sat_low + ", " + sat_high + ")"
    else:
        query = ('CALL filter_test(' + act_low + ", " + act_high + ", " +
                 sat_low + ", " + sat_high + ")")
    db = Database()
    results = db.return_results(query)
    return jsonify(results)


@app.route('/cost/data/', methods=["POST"])
def get_cost_data():
    data = request.json
    cost_min = data['cost_min']
    cost_max = data['cost_max']
    limit = data['limit']

    query = 'CALL filter_cost(' + cost_min + ', ' + \
        cost_max + ', ' + limit + ')'

    db = Database()
    results = db.return_cost_results(query)
    return jsonify(results)


@app.route("/location/data", methods=["POST"])
def get_data():
    data = request.json
    city = '"' + data['city'] + '"'
    state = '"' + data['state'] + '"'
    zip_code = '"' + data['zip'] + '"'
    if (city == '' and state == '' and zip_code == ''):
        return "No input", 404

    query = "CALL filter_location(" + city + \
        ", " + state + ", " + zip_code + ")"

    db = Database()
    result = db.return_results(query)
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
