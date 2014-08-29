extends Node

var glyph = null
var glyphArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var g = 0
var n = null #g's node
var x = 0
var y = 0

func _ready():
	set_process_input(true)
	glyph = get_node("glyph")
	for g in range(glyphArray.size()): # NO IDEA WHY THERE IS AN INVISIBLE NODE
		n = load("res://scene/getNameGlyph.xscn").instance()
		glyph.add_child(n)
		#do stuff with node n here:
		
		#rankNode.get_child(0).get_node("name").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_NAME]))
		if g == 0: #do not randomize first or last tombs position.
			x = 0
		elif g == glyphArray.size() - 1: #do not randomize first or last tombs position.
			x = g * (100 + 175 / 9)
		else:
			x = g * (100 + 175 / 9) + (rand_range(-175 / 18, 175 / 18))
		n.set_margin(0, x)
		n.set_size(Vector2(100, 130))

func _input(inputEvent):
	if (inputEvent.is_pressed()):
		print("getName done")
		get_node("/root/global").currentName = "YES"
		get_node("/root/global").updateHighScorePart2()