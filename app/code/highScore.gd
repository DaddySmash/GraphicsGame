extends Node

#Highscores that are saved to disk.
#  highArray[difficulty][rank][stat] = value
#  difficulty: range(SIZE_DIFFICULTY)
#  rank:       range(SIZE_RANK)
#  stat:       STAT_NAME, STAT_SCORE, STAT_TIME, STAT_NEW

var highArray
var highNode
var diffNode
var rankNode

func _ready():
	get_scene().set_auto_accept_quit(false) #Enables: _notification(what) to recieve MainLoop.NOTIFICATION_WM_QUIT_REQUEST
	highArray = get_node("/root/global").highArray
	#root.get_child(root.get_child_count() - 1)
	highNode = get_node("highNode")
	for difficulty in range(highNode.get_child_count() - 1): # NO IDEA WHY THERE IS AN INVISIBLE NODE
		diffNode = highNode.get_child(difficulty)
		var i = 0
		for rank in range(diffNode.get_child_count()):
			rankNode = diffNode.get_child(rank)
			if highArray[difficulty][rank][get_node("/root/global").STAT_NEW]:
				rankNode.set_texture(load("res://visual/atlasBloodyTomb.xatex"))
			
			if i == diffNode.get_child_count() - 1: # do not randomize last tombs position.
				i = (rank + 1) * (100 + 175 / 9)
			else:
				i = (rank + 1) * (100 + 175 / 9) + (rand_range(-175 / 18, 175 / 18))
			
			rankNode.set_margin(0, i)
			rankNode.set_size(Vector2(100, 130))
			rankNode.get_child(0).get_node("name").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_NAME]))
			rankNode.get_child(0).get_node("score").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_SCORE]))
			rankNode.get_child(0).get_node("time").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_TIME]))

func _notification(what):
	if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST): #User demanding to enterOS()
		get_node("/root/global").enteringOS = true
		get_node("/root/global").enterOS()

func _on_frontGround_pressed():
	if get_node("/root/global").enteringOS:
		get_node("/root/global").enterOS()
	else:
		get_node("/root/global").enterMenu()

func _on_backGround_pressed():
	if get_node("/root/global").enteringOS:
		get_node("/root/global").enterOS()
	else:
		get_node("/root/global").enterMenu()
