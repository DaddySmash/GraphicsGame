extends Node2D

func _ready():
	 set_process_input(true)

func _input(inputEvent):

	#if (!inputEvent.is_pressed()):
	#	return
	if (inputEvent.is_pressed()):
		get_node("/root/global").start_round("")