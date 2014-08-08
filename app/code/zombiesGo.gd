
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initalization here
	 set_process_input(true)

func _input(inputEvent):

	#if (!inputEvent.is_pressed()):
	#	return

	if (inputEvent.is_pressed()):
		get_node("/root/global").end_match()
