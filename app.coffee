express = require 'express'
CronJob = require('cron').CronJob

app = module.exports = express.createServer();

# Configuration
app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')
  app.set 'views', __dirname + '/views'

app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

# Cronjobs
(new CronJob '00 00 20 * * 5', ->
  console.log 'Hello world!'
).start()

app.listen (process.env.PORT or 3000)
