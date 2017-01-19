# Description:
#   Queries Zendesk for information about support tickets
#
# Configuration:
#   HUBOT_ZENDESK_USER
#   HUBOT_ZENDESK_PASSWORD
#   HUBOT_ZENDESK_SUBDOMAIN
#
# Commands:
#   hubot zendesk (all) tickets - Returns the total count of all unsolved tickets. The 'all' keyword is optional.
#   hubot zendesk new tickets - Returns the count of all new (unassigned) tickets.
#   hubot zendesk open tickets - Returns the count of all open tickets.
#   hubot zendesk escalated tickets - Returns a count of tickets with escalated tag that are open or pending.
#   hubot zendesk pending tickets - Returns a count of tickets that are pending.
#   hubot zendesk list (all) tickets - Returns a list of all unsolved tickets. The 'all' keyword is optional.
#   hubot zendesk list new tickets - Returns a list of all new tickets.
#   hubot zendesk list open tickets - Returns a list of all open tickets.
#   hubot zendesk list pending tickets - Returns a list of pending tickets.
#   hubot zendesk list escalated tickets - Returns a list of escalated tickets.
#   hubot zendesk ticket <ID> - Returns information about the specified ticket.
#   hubot zd <comands> - 'zd' can be substituted for 'zendesk' in any of the above comands.
#   #<TicketNumber> - Listens for numbers following # and attempts to return information and a link to the Zendesk ticket. 

sys = require 'sys' # Used for debugging
tickets_url = "https://#{process.env.HUBOT_ZENDESK_SUBDOMAIN}.zendesk.com/tickets"
queries =
  unsolved: "search.json?query=status<solved+type:ticket"
  open: "search.json?query=status:open+type:ticket"
  new: "search.json?query=status:new+type:ticket"
  escalated: "search.json?query=tags:escalated+status:open+status:pending+type:ticket"
  pending: "search.json?query=status:pending+type:ticket"
  tickets: "tickets"
  users: "users"


zendesk_request = (msg, url, handler) ->
  zendesk_user = "#{process.env.HUBOT_ZENDESK_USER}"
  zendesk_password = "#{process.env.HUBOT_ZENDESK_PASSWORD}"
  auth = new Buffer("#{zendesk_user}:#{zendesk_password}").toString('base64')
  zendesk_url = "https://#{process.env.HUBOT_ZENDESK_SUBDOMAIN}.zendesk.com/api/v2"

  msg.http("#{zendesk_url}/#{url}")
    .headers(Authorization: "Basic #{auth}", Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "Zendesk says: #{err}"
          return

        content = JSON.parse(body)

        if content.error?
          if content.error?.title
            msg.send "Zendesk says: #{content.error.title}"
          else
            msg.send "Zendesk says: #{content.error}"
          return

        handler content

zendesk_request_hear = (msg, url, handler) ->
  zendesk_user = "#{process.env.HUBOT_ZENDESK_USER}"
  zendesk_password = "#{process.env.HUBOT_ZENDESK_PASSWORD}"
  auth = new Buffer("#{zendesk_user}:#{zendesk_password}").toString('base64')
  zendesk_url = "https://#{process.env.HUBOT_ZENDESK_SUBDOMAIN}.zendesk.com/api/v2"

  msg.http("#{zendesk_url}/#{url}")
    .headers(Authorization: "Basic #{auth}", Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "Hmmm. I thought you were talking about a zendesk ticket, but when I tried looking it up, I got an error: #{err}"
          return

        content = JSON.parse(body)

        if content.error?
          if content.error?.title
            msg.send "Hmmm. I thought you were talking about a Zendesk ticket, but when I tried looking it up, I got an error: #{content.error.title}"
          else
            msg.send "Hmmm. I thought you were talking about a Zendesk ticket, but when I tried looking it up, I got an error: #{content.error}"
          return

        handler content

# FIXME this works about as well as a brick floats
zendesk_user = (msg, user_id) ->
  zendesk_request msg, "#{queries.users}/#{user_id}.json", (result) ->
    if result.error
      msg.send result.description
      return
    result.user


module.exports = (robot) ->

  robot.respond /(?:zendesk|zd) (all )?tickets$/i, (msg) ->
    zendesk_request msg, queries.unsolved, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} unsolved tickets"

  robot.respond /(?:zendesk|zd) pending tickets$/i, (msg) ->
    zendesk_request msg, queries.pending, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} unsolved tickets"

  robot.respond /(?:zendesk|zd) new tickets$/i, (msg) ->
    zendesk_request msg, queries.new, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} new tickets"

  robot.respond /(?:zendesk|zd) escalated tickets$/i, (msg) ->
    zendesk_request msg, queries.escalated, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} escalated tickets"

  robot.respond /(?:zendesk|zd) open tickets$/i, (msg) ->
    zendesk_request msg, queries.open, (results) ->
      ticket_count = results.count
      msg.send "#{ticket_count} open tickets"

  robot.respond /(?:zendesk|zd) list (all )?tickets$/i, (msg) ->
    zendesk_request msg, queries.unsolved, (results) ->
      for result in results.results
        msg.send "Ticket #{result.id} is #{result.status}: #{tickets_url}/#{result.id}"

  robot.respond /(?:zendesk|zd) list new tickets$/i, (msg) ->
    zendesk_request msg, queries.new, (results) ->
      for result in results.results
        msg.send "Ticket #{result.id} is #{result.status}: #{tickets_url}/#{result.id}"

  robot.respond /(?:zendesk|zd) list pending tickets$/i, (msg) ->
    zendesk_request msg, queries.pending, (results) ->
      for result in results.results
        msg.send "Ticket #{result.id} is #{result.status}: #{tickets_url}/#{result.id}"

  robot.respond /(?:zendesk|zd) list escalated tickets$/i, (msg) ->
    zendesk_request msg, queries.escalated, (results) ->
      for result in results.results
        msg.send "Ticket #{result.id} is escalated and #{result.status}: #{tickets_url}/#{result.id}"

  robot.respond /(?:zendesk|zd) list open tickets$/i, (msg) ->
    zendesk_request msg, queries.open, (results) ->
      for result in results.results
        msg.send "Ticket #{result.id} is #{result.status}: #{tickets_url}/#{result.id}"

  robot.respond /(?:zendesk|zd) ticket ([\d]+)$/i, (msg) ->
    ticket_id = msg.match[1]
    zendesk_request msg, "#{queries.tickets}/#{ticket_id}.json", (result) ->
      if result.error
        msg.send result.description
        return
      message = "#{tickets_url}/#{result.ticket.id}"
      message += "\n>##{result.ticket.id} #(result.ticket.subject) (#{result.ticket.status.toUpperCase()})"
      message += "\n>Priority: #{result.ticket.priority}"
      message += "\n>Type: #{result.ticket.type}"
      message += "\n>Updated: #{result.ticket.updated_at}"
      message += "\n>Added: #{result.ticket.created_at}"
      message += "\n>Description:"
      message += "\n>-------"
      message += "\n>#{result.ticket.description}"
      msg.send message

  robot.hear /#([\d]+)/i, (msg) ->
    ticket_id = msg.match[1]
    zendesk_request_hear msg, "#{queries.tickets}/#{ticket_id}.json", (result) ->
      if result.error
        msg.send "Hmmm. I thought you were talking about a Zendesk ticket, but when I tried looking it up, I got an error: #{result.description}"
        return
      message = "It sounds like you're referencing a Zendesk ticket, let me look that up for you..."
      message += "\n##{result.ticket.id} #{result.ticket.subject} (#{result.ticket.status.toUpperCase()})"
      message += "\n#{tickets_url}/#{result.ticket.id}"
      msg.send message
