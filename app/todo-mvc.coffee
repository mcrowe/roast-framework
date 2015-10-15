Roast = require './roast'

{map, partial, extend, filter} = require 'lodash'

{h1, ul, li, label, input, form, button, div, footer, span} = Roast.elements

{tweak, count} = require './util' 



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
    extend todo, done: !todo.done


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
      extend model, todos: toggleTodo model.todos, idx

    when 'ADD_TODO'
      newTodo = buildTodo model.field

      extend model,
        todos: model.todos.concat newTodo
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
        remainingCount model
      '/'
      span
        class: 'total-count'
        totalCount model
    ]

  ]


# Glue --------------------------

Roast.start initialModel, reduce, view