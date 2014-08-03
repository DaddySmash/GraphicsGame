
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initalization here
	#var value = get_node("/root/global").getSavedHighScore()
	get_node("/root/global").saveHighScore()
	
	get_node("/root/global").savedHighScore = "NO NO NO"
	get_node("/root/global").savedHighTime = "NO NO NO"
	get_node("/root/global").savedHighDifficulty = "NO NO NO"
	get_node("/root/global").savedHighName = "NO NO NO"
	
	get_node("/root/global").loadHighScore()
	
	get_node("Panel").get_node("Label 1").set_text(get_node("/root/global").savedHighScore)
	get_node("Panel").get_node("Label 2").set_text(get_node("/root/global").savedHighTime)
	get_node("Panel").get_node("Label 3").set_text(get_node("/root/global").savedHighDifficulty)
	get_node("Panel").get_node("Label 4").set_text(get_node("/root/global").savedHighName)