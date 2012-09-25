class TaskDivider

  constructor: (@tasks, @residents) ->

  run: ->
    for resident, i in @residents
      [@tasks[(@week_offset() + i) % 3], resident]

  week_offset: ->
    WEEK_IN_SECONDS = 60 * 60 * 24 * 7
    Math.round((new Date()).getTime() / WEEK_IN_SECONDS) % 3

module.exports = TaskDivider