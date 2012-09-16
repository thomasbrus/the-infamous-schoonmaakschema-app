class TaskDivider

  constructor: (@tasks, @residents) ->

  run: ->
    for resident, i in @residents
      [@tasks[(@week_offset() + i) % 3], resident]

  week_offset: ->
    Math.round((new Date()).getTime() / (60 * 60 * 24 * 7)) % 3

module.exports = TaskDivider