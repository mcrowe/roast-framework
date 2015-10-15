# Roast

An insanely simple, functional library for building user interfaces.

Roast is inspired by The Elm Architecture, and the Redux library. It provides a beautifully simple way to build user interfaces, using Coffeescript.

Roast is a Model, Reducer, View framework. The Model is any Javascript object, the View is a function, and the Reducer is a pure function.

# Examples

## A Counter

```coffeescript
Roast = require('./roast')

{div, button} = Roast.elements


# Model --------------

initialModel = 1


# Reduce --------------

reduce = (model, action, data) ->
  switch action
    when 'INCREMENT'
      model + 1
    when 'DECREMENT'
      model - 1
    else
      model


# View ---------------

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

# Glue ----------------

Roast.start(initialModel, reduce, view)
```

## A List of Counters

```coffeescript
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
```

## Todo MVC

```coffeescript
Roast = require('./roast')

{map, partial, extend, filter} = require('lodash')

{h1, ul, li, label, input, form, button, div, footer, span} = Roast.elements

{tweak, count} = require('./util')



# Model --------------------------

initialModel = {
  todos: [
    {title: 'Get some milk', done: false}
    {title: 'Walk the dog', done: true}
  ],
  field: ''
}


toggleTodo = (todos, idx) ->
  tweak todos, idx, (todo) ->
    extend(todo, done: !todo.done)


buildTodo = (title) ->
  {title, done: false}


totalCount = (model) ->
  model.todos.length


remainingCount = (model) ->
  count model.todos, (todo) ->
    !todo.done



# Reduce -------------------------


reduce = (model, action, data) ->
  switch action
    
    when 'TOGGLE'
      idx = data
      extend model, todos: toggleTodo(model.todos, idx)

    when 'ADD_TODO'
      newTodo = buildTodo(model.field)

      extend model,
        todos: model.todos.concat(newTodo)
        field: ''

    when 'UPDATE_FIELD'
      extend model, field: data

    else
      model


# View --------------------------

newTodo = (go, field) ->
  submit = (e) ->
    e.preventDefault()
    go 'ADD_TODO'

  updateField = (e) ->
    go 'UPDATE_FIELD', e.target.value

  form
    onsubmit: submit
    [
      input
        type: 'text'
        name: 'title'
        value: field
        onkeyup: updateField
      button 'Add'
    ]
  


todoItem = (go, todo, idx) ->
  li 
    classList: 
      done: todo.done
    [
      label [
        todo.title
        input
          type: 'checkbox'  
          checked: todo.done
          onchange: -> go 'TOGGLE', idx
      ]
    ]


todoList = (go, todos) ->
  ul map todos, partial(todoItem, go)


view = (go, model) ->
  div [
    h1 'Todos'
    newTodo go, model.field
    todoList go, model.todos
    footer [
      span
        class: 'remaining-count'
        remainingCount(model)
      '/'
      span
        class: 'total-count'
        totalCount(model)
    ]

  ]


# Glue --------------------------

Roast.start(initialModel, reduce, view)

```