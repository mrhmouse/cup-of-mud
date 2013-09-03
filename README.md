cup-of-mud
===

A simple template framework written in pure CoffeeScript. Intended to be small and simple, not featureful.

Example
-------

```coffeescript
Mud = require 'cup-of-mud'

Mud -> [
	@raw '<!DOCTYPE html>'
	@html -> [
		@head ->
			@title 'Hello, world!'
		@body ->
			@p '''
				This is an example of the
				Cup of Mud template framework.
			'''
	]
]
```

Output
------

```html
<!DOCTYPE html>
<html>

	<head>

		<title>
			Hello, world!
		</title>

	</head>

	<body>

		<p>
			This is an example of the
			Cup of Mud template framework.
		</p>

	</body>

</html>
```
