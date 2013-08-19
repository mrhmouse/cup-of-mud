mud
===

A simple template framework written in pure CoffeeScript. Intended to be small and simple, not featureful.

Example
-------

```coffeescript
Mud = require 'mud'

template = ->
  @doctype 'html'
  @html =>
    @head =>
      @title 'Hello World'
    @body =>
      @p class: 'intro', "Hi there from #{ @model.name }!"
      
model =
	name: 'Mud'
	
Mud.render template, model
```

Output
------

```html
<!DOCTYPE html>
	
<html>
	<head>
		<title>
			Hello World
		</title>
	</head>
	<body>
		<p class='intro'>
			Hi there from Mud!
		</p>
	</body>
</html>
```
