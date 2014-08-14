extends HBoxContainer

func _ready():
	pass

func _draw():
	#VS.canvas_item_set_clip(get_canvas_item(), true)
	pass

func _on_flee_pressed():
	get_node("/root/global").exitGame()

func _on_1_pressed():
	get_node("/root/global").start_round(1)

func _on_2_pressed():
	get_node("/root/global").start_round(2)

func _on_3_pressed():
	get_node("/root/global").start_round(3)

func _on_4_pressed():
	get_node("/root/global").start_round(4)

func _on_donate_pressed():
	pass
