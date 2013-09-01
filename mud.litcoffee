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

Mud is the collection of all tags. It is also a function that,
when passed a callback, calls that callback with itself as the
context.

	Mud = ( callback ) -> callback.call Mud

The `Tag` class describes an HTML tag.

	class Tag
		constructor: ( @name, @void = false ) ->

		render: ( args... ) ->
			body = []
			attributes = {}

			for arg in args
				switch typeof arg
					when 'string', 'number', 'function'
						body.push arg
					when 'object'
						attributes[name] = value for own name, value of arg

			result = "<#{ @name }"
			attributes = ( for own name, value of attributes
				"#{ ESCAPE.attribute name }='#{ ESCAPE.attribute value }'" )
			if attributes.length isnt 0
				result += ' '
				result += attributes.join ' '

			if @void
				result += '/>'
			else
				result += '>'
				result += ESCAPE.html item for item in body
				result += "</#{ @name }>"

			result

	ESCAPE =
		html: ( value ) ->
			switch typeof value
				when 'object' then JSON.stringify object
				when 'function' then value.call Mud
				else
					value
						.replace( /</g, '&lt;' )
						.replace( /&/g, '&amp;' )
		attribute: ( value ) ->
			switch typeof value
				when 'object' then JSON.stringify object
				when 'function' then value.call Mud
				else
					value
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
				when 'function' then arg.call Mud )
		result.join ''

	module.exports = Mud
