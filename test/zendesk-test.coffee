chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'zendesk', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/zendesk')(@robot)

  it 'registers a respond listener for all ticket count', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) (all )?tickets$/i)

  it 'registers a respond listener for pending ticket count', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) pending tickets$/i)

  it 'registers a respond listener for new ticket count', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) new tickets$/i)

  it 'registers a respond listener for escalated ticket count', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) escalated tickets$/i)

  it 'registers a respond listener for open ticket count', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) open tickets$/i)

  it 'registers a respond listener for new ticket list', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) list new tickets$/i)

  it 'registers a respond listener for pending ticket list', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) list pending tickets$/i)

  it 'registers a respond listener for escalated ticket list', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) list escalated tickets$/i)

  it 'registers a respond listener for open tickets list', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) list open tickets$/i)

  it 'registers a respond listener for ticket view', ->
    expect(@robot.respond).to.have.been.calledWith(/(?:zendesk|zd) ticket ([\d]+)$/i)