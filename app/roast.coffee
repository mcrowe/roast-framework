h = require 'virtual-dom/h'
diff = require 'virtual-dom/diff'
patch = require 'virtual-dom/patch'
createElement = require 'virtual-dom/create-element'

Roast = {}

addClassList = (props) ->
  className = props.className

  if props.classList
    for klass, enabled of props.classList when enabled
      className += ' ' + klass

  props.className = className

node = (tag) ->
  (props, children) ->
    addClassList(props)
    h(tag, props, children)

Roast.elements = {}

TAGS = "div span header footer main section p br hr a ul li dl dt dd table tr td th tbody thead h1 h2 h3 h4 h5 h6 em strong form button label input select".split(' ')

for tag in TAGS
  Roast.elements[tag] = node tag

NOOP_ACTION = ['NOOP']

Roast.start = (initialModel, reduce, view) ->
  
  model = initialModel

  tree = h('div', {}, 'Loading...')
  rootNode = createElement(tree)
  document.body.appendChild(rootNode)

  go = (action, data) ->
    model = reduce(model, action, data)
    console.log('Roast Action: ', action, data, model)
    newTree = view(go, model)
    patches = diff(tree, newTree)
    rootNode = patch(rootNode, patches)
    tree = newTree

  go(NOOP_ACTION)

module.exports = Roast