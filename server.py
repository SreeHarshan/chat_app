from flask import Flask,request,session
import psycopg2 as psy


# Flask app
app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'

# db connection
con = psy.connect("postgres://izjwxjys:Y0Pky9Xhpdq5Yd_Ajhyg3d6onKhFIJbf@tiny.db.elephantsql.com/izjwxjys")

@app.route("/login")
def login():
    args = request.args.to_dict()

    # check if args are in api
    if(args["uname"] and args["pass"]):
        # check in db
        cur = con.cursor()
        cur.execute("Select * from credentials where id='{}' AND pass='{}'".format(args["uname"],args["pass"]))
        val = cur.fetchone()

        if(cur.rowcount!=0):
            cur.close()
            return {"login":True}
        return {"login":False}
    return {"Output":"args not present"}

@app.route("/adduser",methods=["GET"])
def adduser():
    args = request.args.to_dict()

    # check if args are in api
    if(args["uname"] and args["pass"]):
        # Check if the user already exists
        cur = con.cursor()
        cur.execute("Select * from credentials where id='{}' AND pass='{}'".format(args["uname"],args["pass"]))

        if(cur.rowcount==0):
            # add the values in db
            cur.execute("INSERT INTO credentials(id,pass) VALUES('{}','{}')".format(args["uname"],args["pass"]))
            con.commit()
            return {"Output":"Value was added","Value":True}
        return {"Output":"Value already exists","Value":False}
    return {"Output":"args not present","Value":False}

@app.route("/check")
def check():
    args = request.args.to_dict()

    if(args["uname"]):
        cur = con.cursor()
        cur.execute("Select * from credentials where id='{}'".format(args["uname"]))

        if(cur.rowcount!=0):
            return {"Value":True}

        return{"Value":False}
    return {"Value":False}

# Main function
if __name__ == "__main__":
    app.secret_key = 'super secret key'
    app.run(host = '0.0.0.0',port = 5080)
