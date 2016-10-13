class EM

	@listeners = {}
	@debug = false

	@on: (eventName, fn) ->
		if typeof @listeners[eventName] == "undefined"
			@listeners[eventName] = []

		@listeners[eventName].push(fn)
		@

	@off: (eventName, fnToRemove) ->
		@listeners[eventName].remove(fn)
		@

	@emit: (eventName, data) ->
		if typeof @listeners[eventName] == "undefined"
			return console.error("Unknown event '#{eventName}'")
		if typeof data == 'string'
			dataToRender = data.wrap()
		else
			dataToRender = data

		console.info 'fire', eventName.wrap(), 'with', dataToRender if @debug

		for fn in @listeners[eventName]
			fn(data)
		@

	@fire: ->
		@emit(arguments...)