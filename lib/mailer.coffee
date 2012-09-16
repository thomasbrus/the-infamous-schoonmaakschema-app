email = require 'emailjs'

class Mailer

  constructor: (@sender) ->
    @server = email.server.connect
      user:     process.env.GMAIL_USERNAME, 
      password: process.env.GMAIL_PASSWORD, 
      host:     'smtp.gmail.com', 
      ssl:      true

  send: (recipient, subject, body, callback) ->
    @server.send
      from:     @sender,
      to:       recipient,
      subject:  subject,
      text:     body,
      callback

module.exports = Mailer