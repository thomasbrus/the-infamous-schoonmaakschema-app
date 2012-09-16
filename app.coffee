Mailer = require './lib/mailer'
TaskDivider = require './lib/task_divider'
CronJob = require('cron').CronJob

task_division = new TaskDivider
  ['Keuken', 'Woonkamer', 'Toilet'],
  [
    { name: 'Pieter', email: process.env.EMAIL_PIETER },
    { name: 'Bernard', email: process.env.EMAIL_BERNARD },
    { name: 'Thomas', email: process.env.EMAIL_THOMAS }
  ]

mailer = new Mailer 'Thomas Brus <thomasbrus92@gmail.com>'

(new CronJob '00 00 20 * * 5', ->
  console.log 'Running cronjob...'
  for division in task_division.run()
    [task, resident] = division
    mailer.send
      "#{resident.name} <#{resident.email}>",
      """
        #{resident.name},

        Klusje van deze week is: #{task}.

      """, (err, message) -> console.log(err || message)
).start()
