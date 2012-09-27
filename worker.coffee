Mailer = require './lib/mailer'
TaskDivider = require './lib/task_divider'
CronJob = require('cron').CronJob

task_division = new TaskDivider()

mailer = new Mailer 'Thomas Brus <thomasbrus92@gmail.com>'

remindResidents = ->
  for division in task_division.run()
    [task, resident] = division
    mailer.send(
      "#{resident.name} <#{resident.email}>",
      'Herinnering',
      """
        #{resident.name},

        Klusje van deze week is: #{task}.

      """, (err, message) -> console.log(err || message)
    )

(new CronJob '00 * * * * *', ->
  console.log 'Still up...'
, null, true, 'Europe/Amsterdam').start()  

(new CronJob '00 45 17 * * 4', ->
  console.log 'Running cronjob...'
  remindResidents()
, null, true, 'Europe/Amsterdam').start()

console.log 'App started!'

module.exports = remindResidents
