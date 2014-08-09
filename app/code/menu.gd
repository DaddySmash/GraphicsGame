extends Container

func _ready():
	get_node("menu").connect("button_selected", self, "_event")

func _event(button):
	if button == 0:
		get_node("/root/global").exitGame()
	if button == 1:
		get_node("/root/global").start_round(1)
	if button == 2:
		get_node("/root/global").start_round(2)
	if button == 3:
		get_node("/root/global").start_round(3)
	if button == 4:
		get_node("/root/global").start_round(4)
	if button == 5:
		pass
