class TaskDivider

  TASKS = ['Keuken', 'Toilet', 'Woonkamer']
  RESIDENTS = [
    { name: 'Thomas', email: process.env.EMAIL_THOMAS },
    { name: 'Bernard', email: process.env.EMAIL_BERNARD },
    { name: 'Pieter', email: process.env.EMAIL_PIETER }
  ]

  constructor: (@tasks = TASKS, @residents = RESIDENTS) ->

  run: (now = new Date()) ->
    for resident, i in @residents
      [@tasks[(@.weeks_passed(now) + i) % 3], resident]

  weeks_passed: (now) ->
    Math.floor(now.getTime() / (60 * 60 * 24 * 7 * 1000))

module.exports = TaskDivider