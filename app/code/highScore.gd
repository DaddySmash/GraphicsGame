extends Node

func _ready():
	 set_process_input(true)

func _input(inputEvent):
	if (inputEvent.is_pressed()):
		get_node("/root/global").endRound()