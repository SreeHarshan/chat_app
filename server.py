from flask import Flask

import psycopg2 as psy


# Flask app
app = Flask(__name__)

# db connection
con = psy.connect("postgres://izjwxjys:Y0Pky9Xhpdq5Yd_Ajhyg3d6onKhFIJbf@tiny.db.elephantsql.com/izjwxjys")


# Temp one
@app.route("/")
def hello_world():
    return {"test":"works"}

# Main function
if __name__ == "__main__":
    app.secret_key = 'super secret key'
    app.run(host = '0.0.0.0',port = 5080)
