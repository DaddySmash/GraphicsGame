extends Node

func _ready():
	get_scene().set_auto_accept_quit(false) #Enables: _notification(what) to recieve MainLoop.NOTIFICATION_WM_QUIT_REQUEST

func _notification(what):
	if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST): #User demanding to enterOS()
		get_node("/root/global").enteringOS = true
		get_node("/root/global").enterOS()