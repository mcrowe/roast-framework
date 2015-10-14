{filter, map} = require('lodash')

Util = {}


Util.tweak = (array, idx, fn) ->
  map array, (e, i) -> if i == idx then fn(e) else e


Util.count = (array, fn) ->
  filter(array, fn).length


module.exports = Util