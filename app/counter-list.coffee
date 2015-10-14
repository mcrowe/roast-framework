{map} = require('lodash')
Roast = require('./roast')
{tweak} = require('./util')

{div, button} = Roast.elements


# Model --------------------------

initialModel = {counters: [1..30]}


# Reduce -------------------------

incrementAt = (array, idx, amount) ->
  tweak array, idx, (e) ->
    e + amount


reduce = (model, action, data) ->
  switch action
    when 'INCREMENT'    
      idx = data
      { counters: incrementAt(model.counters, idx, 1) }
    when 'DECREMENT'
      idx = data
      { counters: incrementAt(model.counters, idx, -1) }
    else
      model


# View --------------------------

counter = (go, index, value) ->
  div 
    className: 'item'
    id: 'item'
    [
      button 
        onclick: -> go 'DECREMENT', index
        '-'
      value
      button 
        onclick: -> go 'INCREMENT', index
        '+'
    ]


view = (go, model) ->
  div map model.counters, (val, idx) -> 
    counter go, idx, val


# Glue --------------------------

Roast.start(initialModel, reduce, view)