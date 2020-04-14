# college-data-project

CS 3265 Project 2  
Michelle Lin + Helen Zhang


### To setup the database:
1. Go to db directory and run **database_creation_UPDATED** to
create the database and all associated tables.
2. In the same directory run **insertion.sql** to insert all the
data into the database tables. If load data from file
statement throw an error, set `sql_safe_updates = 0` or if
load data is disabled on your computer run the insertion
statement in the terminal.
3. Run **analytics.sql** to create all procedures necessary for
the backend.


### To set up local environment:
1. Create a new Python 3 environment. Install Flask in that envrionment by running `pip install flask` and install flask-mysql by running `pip install flask-mysqldb`
2. Configure the database configurations in **app.py** to match your server details.

### To run app:
Navigate to college-data-project/application. Run `flask run` in the terminal then go to [localhost:5000] on your computer. Easy!
