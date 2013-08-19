TAGS =
	void: '''
	area base br col command embed hr img input
	keygen link meta param source track wbr
	'''.split /\s+/

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

STRINGIFY = ( item ) ->
	switch typeof item
		when 'function'
			item()
		when 'object'
			JSON.stringify item
		else
			ESCAPE item.toString()

ESCAPE = ( text ) ->
	text
		.replace( />/g, '&gt;' )
		.replace( /</g, '&lt;' )
		.replace( /"/g, '&quot;' )

class Tag
	constructor: ( @name, @void = no ) ->

	open: ( attributes ) ->
		result = "<#{ @name }"

		if typeof attributes is 'object'
			map = do -> for own name, value of attributes
				"#{ name }='#{ STRINGIFY( value )
					.replace( /\\/g, '\\\\' )
					.replace( /'/g, '\\\'' )}'"
			result += ' ' + map.join ' '

		result += '>'

	close: ->
		unless @void
			"</#{ @name }>"

	content: ( attributes, content ) ->
		unless typeof attributes is 'object'
			content = attributes

		unless @void
			"#{ STRINGIFY content }"
		else
			''

class DocType extends Tag
	constructor: ->
		@name = 'doctype'
		@void = yes

	open: ( args... ) -> "<!DOCTYPE #{ args.join ' ' }>"

	content: -> ''

	close: -> ''

class Template
	constructor: ->
		@tags = [ new DocType() ]
		@tags.push new Tag tag, yes for tag in TAGS.void
		@tags.push new Tag tag for tag in TAGS.normal

	render: ( action, model ) ->
		writers = { model }
		result = []
		level = 0
		content = no

		add = ( arg ) -> result.push arg
		newline = -> add '\n'
		tab = -> add '\t'
		indent = ->
			tab() for i in [0...level]
		comment = ( message... ) ->
			add "<!-- #{ message.join ' ' } -->"

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

if window?
	window.Mud = Mud
else
	module.exports = Mud
