extends HBoxContainer

func _ready():
	if get_node("/root/global").enteringOS:
		get_node("/root/global").enterOS()

func _draw():
	#VS.canvas_item_set_clip(get_canvas_item(), true)
	pass

func _on_flee_pressed():
	get_node("/root/global").enterOS()

func _on_highScore_pressed():
	get_node("/root/global").enterHighScore()

func _on_1_pressed():
	get_node("/root/global").enterRound(0)

func _on_2_pressed():
	get_node("/root/global").enterRound(1)

func _on_3_pressed():
	get_node("/root/global").enterRound(2)

func _on_4_pressed():
	get_node("/root/global").enterRound(3)

func _on_donate_pressed():
	get_node("/root/global").enterDonation()