gulp = require "gulp"
browserify = require "browserify"
source = require "vinyl-source-stream"
watchify = require "watchify"
coffeeify = require "coffeeify"
nodemon = require "gulp-nodemon"
livereload = require "gulp-livereload"

watchify.args.debug = true
watchify.args.extensions =
  '.coffee'

livereload.listen()

gulp.task "clientScripts", ->
  rebundle = ->
    bundler.bundle()
    .on "error", (error) ->
      console.error error.message
      return
    .pipe source "index.js"
    .pipe gulp.dest "./public"
    .pipe livereload()

  bundler = watchify browserify watchify.args
  .require __dirname + "/scripts/client/index.coffee", {entry: true}
  .transform coffeeify
  .on "update", rebundle 
  .on "log", (log) ->
    console.log "[watchify] " + log
    return
  
  rebundle()

gulp.task "serverScripts", ->
  nodemon
    script: "app.coffee"
    watch: [
      "scripts/server"
      "scripts/shared"
    ]
  .on "restart", ->
    livereload.changed()
    return

  return

gulp.task "stylesheets", ->
  gulp.watch "stylesheets/**/*", ["reload"]
  return

gulp.task "views", ->
  gulp.watch "views/**/*", ["reload"]
  return

gulp.task "reload", ->
  livereload.changed()
  return

gulp.task "dev", [
  "clientScripts"
  "serverScripts"
  "stylesheets"
  "views"
]
gulp.task "default", ["dev"]
