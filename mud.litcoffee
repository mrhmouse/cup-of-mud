Mud
===

Mud is a simple template framework for HTML documents
(primarily HTML5) written in pure CoffeeScript.

Tags
----

This section defines all of the supported tags in `Mud`.
Each tag is listed as either _void_ or _normal_.
_Void_ tags are those that are self-closing,
while _normal_ tags require a closing tag.

An example of a void tag would be the break tag,
`<br>`, while an example of a normal tag would be
the paragraph tag, `<p></p>`.

	TAGS =

- Void tags

		void: '''
		area base br col command embed hr img input
		keygen link meta param source track wbr
		'''.split /\s+/

- Normal tags

		normal: '''
		script style textarea title html head body
		nav header footer aside article section
		h1 h2 h3 h4 h5 h6 hgroup div p pre blockquote
		hr ul ol li dl dt dd span a em strong b i u
		s mark small del ins sup sub dfn code var samp
		kbd q cite ruby rp rt br wbr bdo bdi table caption
		tr td th thead tfoot tbody colgroup col img
		figcaption figure map area video audio source track
		noscript object param embed iframe canvas abbr address
		meter progress time form button input textarea select
		option optgroup label fieldset legend datalist menu
		output details summary
		'''.split /\s+/

The `STRINGIFY` function is a helper that
converts a function, object, or string into
a string that is safe for HTML display.

	STRINGIFY = ( item ) ->
		switch typeof item
			when 'function'
				item()
			when 'object'
				JSON.stringify item
			else
				ESCAPE item.toString()

The `ESCAPE` function is a helper that
makes a string safe for HTML display.

	ESCAPE = ( text ) ->
		text
			.replace( />/g, '&gt;' )
			.replace( /</g, '&lt;' )
			.replace( /"/g, '&quot;' )

Tag
===

The `Tag` class represents a single tag.
It's used internally to print the opening,
closing, and content sections of an HTML
element.

	class Tag
		constructor: ( @name, @void = no ) ->

		open: ( attributes ) ->

All tags open the same way.

			result = "<#{ @name }"

To write the attributes of a tag, we
stringify each value and create an HTML-safe
map to insert into the opening section.

			if typeof attributes is 'object'
				map = do -> for own name, value of attributes
					"#{ name }='#{ STRINGIFY( value )
						.replace( /\\/g, '\\\\' )
						.replace( /'/g, '\\\'' )}'"
				result += ' ' + map.join ' '

All opening tags close the same way.

			result += '>'

Unless a tag is _void_ (and therefore doesn't need
to be closed), this writes the closing tag.

		close: ->
			unless @void
				"</#{ @name }>"

The content section is written by stringifying
the given content into an HTML-safe string.

		content: ( attributes, content ) ->
			unless typeof attributes is 'object'
				content = attributes

			unless @void
				"#{ STRINGIFY content }"
			else
				''

The doctype is a special type of tag
with the format `<!DOCTYPE html>`.

	class DocType extends Tag
		constructor: ->
			@name = 'doctype'
			@void = yes

		open: ( args... ) -> "<!DOCTYPE #{ args.join ' ' }>"

		content: -> ''

		close: -> ''

Template
========

The `Template` is the main class of `Mud` and what users
will receive as the module. It defines one function,
`render`, which accepts a callback that it uses to generate
a string.

	class Template
		level = 0

		constructor: ->
			@tags = [ new DocType() ]
			@tags.push new Tag tag, yes for tag in TAGS.void
			@tags.push new Tag tag for tag in TAGS.normal

`render` accepts a callback and a model. The callback
is invoked in the context of all of `Mud`'s helper
functions, so they are available bound to `this` or `@`.

		render: ( action, model ) ->
			writers = { model }
			result = []
			content = no

Some helper functions for pretty printing our tags.

			add = ( arg ) -> result.push arg

			newline = -> add '\n'

			tab = -> add '\t'

			indent = ->
				tab() for i in [0...level]

A function is bound for each tag that
creates properly indented markup.

			for tag in @tags
				do ( tag ) ->
					writers[tag.name] = ( args... ) ->
						newline() unless content or level is 0
						indent() unless content
						add tag.open args...

						newline()
						level += 1
						indent()
						content = yes
						result.push tag.content args...
						content = no

						newline()
						level -= 1
						indent()
						result.push tag.close args...
						''

			action.call writers
			result.join ''

	Mud = new Template()

If we're running in the browser, our `exports` object
should be `window`.

	if window?
		window.Mud = Mud
	else
		module.exports = Mud
