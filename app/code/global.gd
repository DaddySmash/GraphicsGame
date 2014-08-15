extends Node

#This is used by global.gd for changing scenes.
var currentScene = null

#Highscores that are saved to disk.
var highDifficulty = null
var highName = null
var highScore = null
var highTime = null

func _ready():
	get_scene().set_auto_accept_quit(false) #Enables: _notification(what) to recieve MainLoop.NOTIFICATION_WM_QUIT_REQUEST
	var root = get_scene().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	loadHighScore()

func _notification(what):
	if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		get_scene().quit() #default behavior

func loadHighScore():
	#this function is to load the high scores for viewing.
	var f = File.new()
	if f.file_exists("user://highScores.zombie"):
		var err = f.open_encrypted_with_pass("user://highScores.zombie", File.READ, OS.get_unique_ID())
		if err:
			print("LOAD ERROR: " + str(err))
			clearHighScore()
		else:
			highDifficulty = f.get_var()
			highName = f.get_var()
			highScore = f.get_var()
			highTime = f.get_var()
	else:
		print("LOAD ERROR: highScores.zombie does not exist.")
		clearHighScore()
	f.close()

func clearHighScore():
	#
	# TODO: Add prompt to delete all highscores and create empty list!
	#
	for x in range(0, 9):
		highDifficulty[x][x] = 1;
		[1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4]
	highDifficulty = [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4]
	highName = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
	highScore = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	highTime = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	saveHighScore()

func saveHighScore():
	#This function is to save the high scores.
	var f = File.new()
	var err = f.open_encrypted_with_pass("user://highScores.zombie", File.WRITE, OS.get_unique_ID())
	if err:
		print("SAVE ERROR: " + str(err))
	else:
		f.store_var(highDifficulty)
		f.store_var(highName)        
		f.store_var(highScore)
		f.store_var(highTime)
	f.close()

func updateHighScore(difficulty, name, score, time):
	#This needs to called at the end of the game.
	#Check to see if the player is in the top 10 high scores.  If so, then add to high score.
	#Then trim any high scores past the tenth entry.
	sortHighScore()

func sortHighScore():
	#This function is to sort the high scores before a save.
	pass

func quitGame():
	get_scene().quit()

func popupHighScore():
	pass

func popupDonation():
	pass

func startRound(difficulty):
	set_process_input(false)
	
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
	
	var s = ResourceLoader.load("res://scene/zombiesGo.xscn")
	
	#get_node("exitScene").active(true)
	
	currentScene.queue_free()
	currentScene = s.instance()
	get_scene().get_root().add_child(currentScene)

func endRound():
    var s = ResourceLoader.load("res://scene/intro.xscn")
    currentScene.queue_free()
    currentScene = s.instance()
    get_scene().get_root().add_child(currentScene)


#####################################################

#Time based variables.
#var eclipseRatio = null

#Player stuff.
#var playerScore = null
#var playerTime = null
#var playerDifficulty = null
#var playerHealth = null
#var specialAbilityAmmo = null
