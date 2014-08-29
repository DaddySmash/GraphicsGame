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
	set_process_input(true)
	highArray = get_node("/root/global").highArray
	#root.get_child(root.get_child_count() - 1)
	highNode = get_node("highNode")
	for difficulty in range(highNode.get_child_count() - 1): # NO IDEA WHY THERE IS AN INVISIBLE NODE
		diffNode = highNode.get_child(difficulty)
		for rank in range(diffNode.get_child_count()):
			rankNode = diffNode.get_child(rank).get_child(0)
			rankNode.get_node("name").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_NAME]))
			rankNode.get_node("score").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_SCORE]))
			rankNode.get_node("time").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_TIME]))

func _input(inputEvent):
	if (inputEvent.is_pressed()):
		get_node("/root/global").endRound()