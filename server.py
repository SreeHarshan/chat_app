from flask import Flask,request,session
from flask_socketio import SocketIO
import psycopg2 as psy


# Flask app
app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)

# db connection
con = psy.connect("postgres://izjwxjys:Y0Pky9Xhpdq5Yd_Ajhyg3d6onKhFIJbf@tiny.db.elephantsql.com/izjwxjys")

# Clients
clients = {}

# Login by the user
socketio.on("login")
def login():
    print("Login accessed")
    args = request.args.to_dict()
   
    # check if args are in api
    if(args["uname"] and args["pass"]):
        # check in db
        cur = con.cursor()
        cur.execute("Select * from credentials where id='{}' AND pass='{}'".format(args["uname"],args["pass"]))
        val = cur.fetchone()

        if(cur.rowcount!=0):
            cur.close()
            c_id = args["uname"]

            # Return the queued up messages 
            cur.execute("Select * from msg where receive='{}'".format(c_id))
            vals = cur.fetchall()
            if(cur.rowcount>0):
                # send the values as messages
                for row in vals:
                    # TODO change this
                    data = row
                    clients[c_id].emit(data)

            socketio.emit("login",{"login":True})
        cur.close()
        socketio.emit("login",{"login":True})
    print("args not present")

@socketio.on_error_default
def default_error_handler(e):
    print("Error")
    print(request.event["message"]) 
    print(request.event["args"])    

@app.route("/check")
def check():
    args = request.args.to_dict()
    
    # check if arg is passed in api
    if(args["uname"]):
        # check if it is in the db
        cur = con.cursor()
        cur.execute("Select * from credentials where id='{}'".format(args["uname"]))
        cur.fetchone()

        if(cur.rowcount!=0):
            return {"Value":True}
        return {"Value":False}

    return {"Output":"arg not present in api"}

# Adding new users to database
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
            # TODO add values in db 2
            cur.execute("INSERT INTO ")
            con.commit()
            cur.close()
            return {"Output":"Value was added"}
        return {"Output":"Value already exists"}
    return {"Output":"args not present"}

# Receive a text message from the user
# TODO test this
@socketio.on("message")
def handle_message(data):
    # Find the receiptent id and bounce back the message  
    print(data)
    recid = data["rec_id"]

    #TODO change this
    data2 = data

    # Check if the receiptent is connected to the server rn
    if(recid in clients.keys()):
        clients[recid].emit(data2)
    else:
        # add the message to queue
        cur = con.cursor()
        cur.execute("INSERT INTO msg(send,receive,content,time) VALUES('{}','{}','{}',{}')".format(data['send_id'],data['rec_id'],data["content"],data["time"]))
        cur.commit()
        cur.close()
    

# Temp one
#@app.route("/")
#def hello_world():
#    return {"test":"works"}

# Main function
if __name__ == "__main__":
    socketio.run(app,debug=True)
