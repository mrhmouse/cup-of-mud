mud
===

A simple template framework written in pure CoffeeScript. Intended to be small and simple, not featureful.

Example
-------

```coffeescript
Mud = require 'mud'

Mud.render ->
  @doctype 'html'
  @html =>
    @head =>
      @title 'Hello World'
    @body =>
      @p class: 'intro', 'Hi there from Mud!'
```
