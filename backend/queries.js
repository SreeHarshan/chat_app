
const pgp = require('pg-promise')()

const db2 = pgp("postgres://izjwxjys:Y0Pky9Xhpdq5Yd_Ajhyg3d6onKhFIJbf@tiny.db.elephantsql.com/izjwxjys")

const login = (request, response) => {
    const output = db2.any("Select * from credentials")
    response.status(200).json(output)
}


