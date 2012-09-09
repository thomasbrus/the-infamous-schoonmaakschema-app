express = require 'express'
CronJob = require('cron').CronJob
mail = require('mail').Mail
  host: 'thomasbrus92@gmail.com',
  username: process.env.GMAIL_USERNAME,
  password: process.env.GMAIL_PASSWORD

app = module.exports = express.createServer()

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

# Settings
TASKS = ['Keuken', 'Woonkamer', 'Toilet']
RESIDENTS = [
  { name: 'Pieter', email: process.env.EMAIL_PIETER },
  { name: 'Bernard', email: process.env.EMAIL_BERNARD },
  { name: 'Thomas', email: process.env.EMAIL_THOMAS }
]

# Cronjobs
(new CronJob '00 00 20 * * 5', ->
  week_offset = Math.round((new Date()).getTime() / (60 * 60 * 24 * 7)) % 3
  for resident, i in RESIDENTS
    task = TASKS[(week_offset + i) % 3]
    mail.message(
      from: 'thomasbrus92@gmail.com',
      to: [resident.email],
      subject: 'Herinnering'
    )
    .body("
      #{resident.name},

      Klusje van deze week is: #{task}.

    ")
    .send((err) ->
      throw err if err
      console.log "Reminder sent! (#{resident.name} -> #{task})"
    )
).start()

app.listen (process.env.PORT or 3000)
