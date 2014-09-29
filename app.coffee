path = require 'path' 
express = require 'express' 
stylus = require 'stylus' 
nib = require 'nib'

app = express()
app.use stylus.middleware
  src: "#{__dirname}/stylesheets"
  dest: "#{__dirname}/public"
  compile: (str, path) ->
    stylus str
    .set 'filename', path
    .set 'compress', true
    .use nib()

app.set 'view engine', 'jade'
app.set 'views', "#{__dirname}/views"
app.use express.static "#{__dirname}/public"
app.get '/', (req, res) ->
  res.render 'index'
  return

port = Number(process.env.PORT or 8080)
app.listen port

((msg) -> console.log "Hello from #{msg} ! Listening on port #{port}") 'Node'