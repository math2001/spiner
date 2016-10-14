percentage = (per, value) ->
	(per / 100) * value

log =  ->
	console.log.apply console, arguments

rnd = (min, max, integer=true) ->
	if not integer
		return Math.random() * (max - min) + min
	else
		return Math.floor(Math.random() * (max - min + 1) + min)

forEach = (obj, func) ->
	# function (key, value, obj, nb_key) { /* do stuff */ }
	if typeof obj != 'object'
		console.error "forEach(...) needs an OBJECT (not a '#{typeof obj}' and a function"

	keys = Object.keys(obj);

	for key, i in keys
		if 'stop' == func(key, obj[key], obj, i)
			return obj

	obj

copyObject = (obj) -> $.extend({}, obj)

copyText = (text) ->
	$el = $('<input type="text">')
	.val(text)
	.css({
		position: 'absolute'
		left: '-100%'
		top: '-100%'
		opacity: 0
	})
	.appendTo(document.body)
	$el[0].select()
	if not document.execCommand('copy')
		console.warn 'Unable to copy.'
		return false
	$el.remove()
	text

code = (letter) ->
	return 17 if letter == 'ctrl'
	return 18 if letter == 'alt'
	return 27 if letter == 'escape'
	return 13 if letter in ['enter', 'return']

	if letter.length != 1
		return console.error "code: unknow abrv '#{letter}'"

	return letter.charCodeAt(0) - 32

openInNewTab = (url) ->
	$el = $('<a>a link</a>').attr(
		target: '_blank'
		href: url
	).css(
		position: 'absolute'
		left: '-100%'
		top: '-100%'
		width: 0
		height: 0
		opacity: 0
	)
		.appendTo(document.body)
	$el[0].click()
	$el.remove()

any = (arr) ->
	for el in arr
		if el
			return true
	return false

all = (arr) ->
	for el in arr
		if not el
			return false
	return true

globMatch = (pattern, elements) ->
	pattern = pattern.replace(/[\-\[\]\/\{\}\(\)\+\.\^\$]/g, "\\$&")
	pattern = pattern.replace(/([^\\]?)\*/g, '$1.*')

	regex = new RegExp('^' + pattern + '$')

	if typeof elements == 'object'
		match = []
		for element in elements
			match.push element if regex.test(element)
		return match
	else if typeof elements == 'string'
		return regex.test(elements)
	else
		return console.error "Does not support #{typeof elements}"

Array::__update = (arr) ->
	# this = arr
	while this.length > 0
		this.pop()

	for val in arr
		this.push(val)
	this

Array::remove = (valToRemove, times=-1) ->
	# remove <times> times `valToRemove` from this
	# if <times> == -1 then it removes all of them
	arr = []
	for val in this
		if times == 0 or val != valToRemove
			arr.push(val)
		else if val == valToRemove
			times -= 1
	this.__update(arr)

Array::get = (index) ->
	index = this.length + index if index < 0
	this[index]

String::strip = (charToRemove=' ') ->
	start = 0
	end = @length
	cont = true
	for char, i in @
		if cont == true and char == charToRemove
			start++
		else
			cont = false

	cont = true

	for char, i in @split('').reverse()
		if cont == true and char == charToRemove
			end--
		else
			cont = false

	return @slice(start, end)

String::wrap = (char='"') ->
	return char + this + char

String::capitalize = ->
	return this[0].toUpperCase() + this.slice(1)


$.fn.exists = (nice=false) ->
	return this.length > 0

$.arrayDiff = (arr1, arr2) ->
	arr = []
	for val, i in arr1
		arr.push val if arr2.indexOf(val) == -1
	return arr

$.fn.outerHTML = (html) ->
	if html
		if typeof html == typeof alert
			html = html.bind(this)()
		this.each(->
			@outerHTML = html
		)
	else
		this.outerHTML

keys =
	left: 39
	right: 37
	escape: 27

round = (number, precision) ->
    factor = Math.pow(10, precision)
    roundedTempNumber = Math.round(number * factor) / factor

randomColor = (alpha=false)->
	colors = [rnd(0, 255), rnd(0, 255), rnd(0, 255)]
	colors.push round(rnd(0, 1, false), 2) if alpha
	colors = '(' + colors.join(', ') + ')'
	colors = 'rgb' + (if alpha then 'a' else '') + colors
	colors

bool = (el) ->
	return not not el