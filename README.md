# hubot-zendesk

Queries Zendesk for information about support tickets

See [`src/zendesk.coffee`](src/zendesk.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-zendesk --save`

Then add **hubot-zendesk** to your `external-scripts.json`:

```json
["hubot-zendesk"]
```

# Configuration:
```
HUBOT_ZENDESK_USER
HUBOT_ZENDESK_PASSWORD
HUBOT_ZENDESK_SUBDOMAIN
```

# Commands:
```
hubot zendesk (all) tickets - returns the total count of all unsolved tickets. The 'all' keyword is optional.
hubot zendesk new tickets - returns the count of all new (unassigned) tickets
hubot zendesk open tickets - returns the count of all open tickets
hubot zendesk escalated tickets - returns a count of tickets with escalated tag that are open or pending
hubot zendesk pending tickets - returns a count of tickets that are pending
hubot zendesk list (all) tickets - returns a list of all unsolved tickets. The 'all' keyword is optional.
hubot zendesk list new tickets - returns a list of all new tickets
hubot zendesk list open tickets - returns a list of all open tickets
hubot zendesk list pending tickets - returns a list of pending tickets
hubot zendesk list escalated tickets - returns a list of escalated tickets
hubot zendesk ticket <ID> - returns information about the specified ticket
```
