express         = require 'express'
eco             = require 'eco'
TaskDivider     = require './lib/task_divider'

app = module.exports = express.createServer();

# Configuration

app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'eco'
  app.register '.eco', eco

app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

task_divider = new TaskDivider()
task_divisions = for i in [2..0]
  now = new Date()
  now.setDate(now.getDate() + (5 - now.getDay()) - 7 * i)
  tasks = task_divider.run(now)
  [now.toString().split(' ')[1..3].join(' '), (tasks.map (task) -> task[0])...]

app.get '/', (req, res) -> res.render 'index',
  task_divisions: task_divisions,
  residents: task_divider.residents

app.listen (process.env.PORT or 3000)
console.log "Web server listening on port %d in %s mode", app.address().port, app.settings.env

# $ heroku ps:scale worker=1
# Scaling worker processes... failed
#  !    Please verify your account in order to change resources
#  !    For more information, see http://devcenter.heroku.com/categories/billing
#  !    Verify now at http://heroku.com/verify

require './worker'

