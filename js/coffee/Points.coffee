class Points

	###
		This is just a helper. Most of the time, each action is called on both points, so this is what this class does.
	###

	@init: ->
		@normalRadius = 70
		@expandedRadius = 90

		@areExpaned = false


		# calling spin without any arguments makes the points get placed without being moved
		@red = new Point($('.point.red'), @normalRadius, 'red', false).spin().render()
		@blue = new Point($('.point.blue'), @normalRadius, 'blue', true).spin().render()
		@



	@render: ->
		@red.render()
		@blue.render()
		@

	@checkCollide: (wall)->
		@red.checkCollide(wall) or @blue.checkCollide(wall)

	@spin: (way) ->
		@red.spin(way)
		@blue.spin(way)
		@

	@changeColor: ->
		@red.changeColor()
		@blue.changeColor()
		@

	@resetColor: ->
		@red.resetColor()
		@blue.resetColor()
		@

	@reset: ->
		@blue.reset()
		@red.reset()
		@

	@expand: ->
		if @areExpaned
			return @
		@red.radius = @blue.radius = @expandedRadius
		@red.spin()
		@blue.spin()
		@areExpaned = true
		@

	@unexpand: ->

		if not @areExpaned
			return @
		@red.radius = @blue.radius = @normalRadius
		@red.spin()
		@blue.spin()
		@render()
		@areExpaned = false
		@




class Point

	constructor: (@$, @radius, @color, opposite) ->
		if opposite then @defaultAngle = 0 else @defaultAngle = -Math.PI
		@angle = @defaultAngle
		@width = @height = 20
		@spinCenter = [
			percentage(50, Game.width), 
			Game.height - @radius - 20
		]
		@angleSpeed = 0.1


		@$.css({
			width: @width
			height: @height
		})

	spin: (way) ->
		if way == 'left'
			@angle += @angleSpeed
		else if way == 'right'
			@angle -= @angleSpeed
		
		cos = Math.trunc(@radius * Math.cos(@angle))
		sin = Math.trunc(@radius * Math.sin(@angle))
		@x = @spinCenter[0] + cos
		@y = @spinCenter[1] + sin
		@

	render: ->
		@$.css('left', @x)
		@$.css('top', @y)
		@

	checkCollide: (wall) ->
		(
			# x
			# this.left > wall.left and this.left < wall.right
			(@x >= wall.x and @x < wall.x + wall.width) or
			# wall.left > this.left and wall.left < this.right
			(wall.x >= @x and wall.x < @x + @width)
			) and (
			# y
			(@y >= wall.y and @y < wall.y + wall.height) or
			(wall.y >= @y and wall.y < @y + @height)
		)

	changeColor: ->
		@$.css('background-color', randomColor())
		@

	resetColor: ->
		@$.css('background-color', '')
		@
	reset: ->
		@angle = @defaultAngle
		@spin()
		@
