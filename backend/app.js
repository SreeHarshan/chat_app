
const express = require('express')
const bodyParser = require('body-parser')
const cors = require("cors");
const pgp = require('pg-promise')()
const app = express()
const port = 3000
const socketPort = 8000;
const { emit } = require("process");
const server = require("http").createServer(app);
const io = require("socket.io")(server, {
    cors : {
        origin: "http://localhost:3001",
         methods: ["GET", "POST"],
    }
});

app.use(cors())

// DB connection
const db = pgp("postgres://izjwxjys:Y0Pky9Xhpdq5Yd_Ajhyg3d6onKhFIJbf@tiny.db.elephantsql.com/izjwxjys")

app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

io.on('connection',function(client){
    console.log('client connected')

    client.on('join',function(data){
        console.log(data)
    })
})




app.listen(port, () => {
  console.log(`App running on ${port}.`)
})
