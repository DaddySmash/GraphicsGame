extends HBoxContainer

var highArray = null
var highScoreTomb = null

func _ready():
	if get_node("/root/global").enteringOS:
		get_node("/root/global").enterOS()
	print("WORKS")
	highArray = get_node("/root/global").highArray
	highScoreTomb = get_node("highScore")
	var difficulty = 3
	var rank = 0
	if highArray[difficulty][rank][get_node("/root/global").STAT_NEW]:
		highScoreTomb.set_normal_texture(load("res://visual/atlasBloodyTomb.xatex"))
	highScoreTomb.get_child(0).get_node("name").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_NAME]))
	highScoreTomb.get_child(0).get_node("score").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_SCORE]))
	highScoreTomb.get_child(0).get_node("time").set_text(str(highArray[difficulty][rank][get_node("/root/global").STAT_TIME]))
	print(str(highArray[difficulty][rank][get_node("/root/global").STAT_NAME]))
	print(str(highArray[difficulty][rank][get_node("/root/global").STAT_SCORE]))
	print(str(highArray[difficulty][rank][get_node("/root/global").STAT_TIME]))
	

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
