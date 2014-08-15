extends HBoxContainer

func _ready():
	pass

func _draw():
	#VS.canvas_item_set_clip(get_canvas_item(), true)
	pass

func _on_flee_pressed():
	get_node("/root/global").quitGame()

func _on_highScore_pressed():
	get_node("/root/global").popupHighScore()

func _on_1_pressed():
	get_node("/root/global").startRound(1)

func _on_2_pressed():
	get_node("/root/global").startRound(2)

func _on_3_pressed():
	get_node("/root/global").startRound(3)

func _on_4_pressed():
	get_node("/root/global").startRound(4)

func _on_donate_pressed():
	get_node("/root/global").popupDonation()
