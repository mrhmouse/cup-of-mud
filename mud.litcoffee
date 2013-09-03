Toggle this for debug mode.

	DEBUG = off

All available HTML tags are listed below.

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

This is a helper method to properly indent a section.

	INDENT = do ->
		line = /^/gm
		( item ) ->
			indentation = ''
			indentation += '\t' for i in [0...Mud.INDENTATION] if Mud.INDENTATION > 0
			item.replace line, indentation

Mud is the collection of all tags. It is also a function that,
when passed a callback, calls that callback with itself as the
context.

	Mud = ( args... ) ->
		result = ''
		if args?
			for arg in args when arg?
				if Array.isArray arg
					result += Mud arg...
				else
					result += switch typeof arg
						when 'string' then arg
						when 'number' then arg.toString()
						when 'object' then JSON.stringify arg
						when 'function' then Mud arg.call Mud
						else ''
			result

	Mud.INDENTATION = 0

The `Tag` class describes an HTML tag.

	class Tag
		constructor: ( @name, @void = false ) ->

		render: ( args... ) ->
			console.log INDENT @name if DEBUG
			body = []
			attributes = {}

			for arg in args
				switch typeof arg
					when 'string', 'number', 'function'
						body.push arg
					when 'object'
						attributes[name] = value for own name, value of arg

			result = '\n' + INDENT "<#{ @name }"
			attributes = ( for own name, value of attributes
				"#{ ESCAPE.attribute name }='#{ ESCAPE.attribute value }'" )
			if attributes.length isnt 0
				result += ' ' + attributes.join ' '

			if @void
				result += '/>\n'
			else
				result += '>\n'
				Mud.INDENTATION += 1
				console.log INDENT "#{ @name }::body" if DEBUG
				result += Mud ESCAPE.html item for item in body
				Mud.INDENTATION -= 1
				result += '\n' + INDENT Mud "</#{ @name }>\n"

			result

	ESCAPE =
		html: do ->
			replace = ( value ) -> value
				.replace( /</g, '&lt;' )
				.replace( /&/g, '&amp;' )

			( value ) -> switch typeof value
				when 'string', 'number'
					INDENT replace value.toString()
				when 'object'
					INDENT JSON.stringify value
				else
					value
		attribute: ( value ) ->
			switch typeof value
				when 'object' then JSON.stringify object
				when 'function' then Mud value
				else
					value
						.toString()
						.replace( /</g, '&lt;' )
						.replace( /&/g, '&amp;' )
						.replace( /\\/g, '\\\\' )
						.replace( /'/g, '\\\'' )

Here we add all of the tags to the Mud collection.

	for name in TAGS.normal
		do ( name ) ->
			tag = new Tag name
			Mud[name] = ( args... ) -> tag.render args...

	for name in TAGS.void
		do ( name ) ->
			tag = new Tag name, yes
			Mud[name] = ( args... ) -> tag.render args...

	Mud.text = ( args... ) ->
		result = ( ESCAPE.html arg for arg in args )
		result.join ''

	Mud.raw = ( args... ) ->
		result = ( for arg in args
			switch typeof arg
				when 'string', 'number' then arg
				when 'object' then JSON.stringify arg
				when 'function' then Mud arg )
		result.join ''

	module.exports = Mud
