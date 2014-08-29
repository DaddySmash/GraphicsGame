extends Node

#get_node("/root/global").enteringOS
#get_node("/root/global").enteringMenu
#get_node("/root/global").currentDifficulty

#Time based variables.
#var eclipseRatio = null

#Player stuff.
#var playerScore = null
#var playerTime = null
#var playerDifficulty = null
#var playerHealth = null
#var specialAbilityAmmo = null

func _ready():
	get_scene().set_auto_accept_quit(false) #Enables: _notification(what) to recieve MainLoop.NOTIFICATION_WM_QUIT_REQUEST
	set_process(true)
	set_process_input(true)
	
	#Init settings for round.
	#playerDifficulty = difficulty
	#eclipseRatio = (difficulty - 1) * 0.2
	#playerScore = 0
	#playerTime = 0
	#specialAbilityAmmo = 0
	#if playerDifficulty == 1:
	#	playerHealth = 3
	#if playerDifficulty == 2:
	#	playerHealth = 6
	#if playerDifficulty == 3:
	#	playerHealth = 5
	#if playerDifficulty == 4:
	#	playerHealth = 4

func _notification(what):
	if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		#Submit current game and save highArray before exiting.
		get_node("/root/global").enteringOS = true
		get_node("/root/global").updateHighScore(rand_range(0, 9999), rand_range(0, 59))

func _process(delta):
	#This is ran every frame.
	#get_node("/root/global").timeString(time)
	pass

func _input(inputEvent):
	#This is ran every input.
	if (inputEvent.is_pressed()):
		#Submit current game and save highArray before ending round.
		#updateHighScore(score, time)
		get_node("/root/global").enteringMenu = true
		get_node("/root/global").updateHighScore(rand_range(0, 9999), rand_range(0, 59))