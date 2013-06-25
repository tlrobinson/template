http = require "http"
path = require "path"

express = require "express"
stylus = require "stylus"
coffeeify = require "coffeeify"
browserify = require "browserify-middleware"
browserify.settings "transform", [coffeeify]

routes = require "./routes"
user = require "./routes/user"

PUBLIC_PATH = path.join(__dirname, "public")

app = express()

app.configure ->
  app.set "port", process.env["PORT"] or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"

  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser("your secret here")
  app.use express.session()

  app.use app.router

  app.use stylus.middleware(PUBLIC_PATH)
  app.use express.static(PUBLIC_PATH)

  app.use "/javascripts/index.js", browserify("client/index.coffee")

app.configure "development", ->
  app.use express.errorHandler()

app.configure "production", ->


app.get "/", routes.index
app.get "/users", user.list

app.listen app.get("port")

console.log "Listening on port " + app.get("port")
