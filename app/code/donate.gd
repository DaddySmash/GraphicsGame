extends Node

func _ready():
	get_scene().set_auto_accept_quit(false) #Enables: _notification(what) to recieve MainLoop.NOTIFICATION_WM_QUIT_REQUEST
	set_process(true)

func _notification(what):
	if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		get_node("/root/global").enteringOS = true
		get_node("/root/global").enterOS()

func _process(delta):
	#This is ran every frame.
	#get_node("/root/global").timeString(time)
	pass

func _on_backGround_pressed():
	get_node("/root/global").enteringMenu = true
	get_node("/root/global").enterMenu()

func _on_frontGround_pressed():
	get_node("/root/global").enteringMenu = true
	get_node("/root/global").enterMenu()