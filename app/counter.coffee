Roast = require('./roast')

{div, button} = Roast.elements


reduce = (model, action, data) ->
  switch action
    when 'INCREMENT'
      model + 1
    when 'DECREMENT'
      model - 1
    else
      model


view = (go, value) ->
  div 
    className: 'item'
    [
      button 
        onclick: -> go 'DECREMENT'
        '-'
      value
      button 
        onclick: -> go 'INCREMENT'
        '+'
    ]


initialModel = 1


Roast.start(initialModel, reduce, view)