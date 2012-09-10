express = require 'express'
CronJob = require('cron').CronJob
email = require 'emailjs'
app = module.exports = express.createServer()

# Configuration
app.configure ->
  app.use express.methodOverride()

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

# Mailer
mailServer = email.server.connect
  user:     process.env.GMAIL_USERNAME, 
  password: process.env.GMAIL_PASSWORD, 
  host:     "smtp.gmail.com", 
  ssl:      true

# Cronjobs
(new CronJob '00 00 20 * * 5', ->
  week_offset = Math.round((new Date()).getTime() / (60 * 60 * 24 * 7)) % 3
  
  for resident, i in RESIDENTS
    task = TASKS[(week_offset + i) % 3]
  
    mailServer.send
      from:     "Thomas Brus <thomasbrus92@gmail.com>", 
      to:       "#{resident.name} <#{resident.email}>",
      subject:  "Herinnering",
      text:     """
        #{resident.name},

        Klusje van deze week is: #{task}.

      """,
      (err, message) -> console.log(err || message)

).start()

app.listen (process.env.PORT or 3000)
