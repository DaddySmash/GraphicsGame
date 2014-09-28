extends Node

var glyph = null
var glyphArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ",", ".", "_", "-"]
var g = 0
var n = null #g's node
var x = 0
var y = (-340 / 3)

func _ready():
	get_scene().set_auto_accept_quit(false) #Enables: _notification(what) to recieve MainLoop.NOTIFICATION_WM_QUIT_REQUEST
	glyph = get_node("glyph")
	for g in range(glyphArray.size()): # NO IDEA WHY THERE IS AN INVISIBLE NODE
		n = load("res://scene/getNameGlyph.xscn").instance()
		n.get_child(0).get_node("name").set_text(glyphArray[g])
		glyph.add_child(n)
		
		#do stuff with node n here:
		
		if g % 10 == 0: #do not randomize first or last tombs position.
			x = 0
			y = y + (340 / 3)
		elif g % 10 == 9: #do not randomize first or last tombs position.
			x = 9 * (100 + 175 / 9)
		else:
			x = (g % 10) * (100 + 175 / 9) + (rand_range(-175 / 18, 175 / 18))
		#MARGIN_LEFT, MARGIN_TOP, MARGIN_RIGHT, MARGIN_BOTTOM
		n.set_margin(0, x)
		n.set_margin(1, y)
		n.set_size(Vector2(100, 130))
		
		get_node("/root/global").currentName = ""

func _notification(what):
	if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST): # DO NOT ENTER OS YET, WAIT TIL THEY GIVE NAME.
		get_node("/root/global").enteringOS = true