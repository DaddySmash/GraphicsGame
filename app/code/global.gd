extends Node

#This is used by global.gd for changing scenes.
var currentScene = null
var errorHighArray = false

#Highscores that are saved to disk.
#  highArray[difficulty][rank][stat] = value
#  difficulty: range(SIZE_DIFFICULTY)
#  rank:       range(SIZE_RANK)
#  stat:       STAT_NAME, STAT_SCORE, STAT_TIME, STAT_NEW
const SIZE_DIFFICULTY = 4
const SIZE_RANK = 10
const SIZE_STAT = 4

const STAT_NAME = 0
const STAT_SCORE = 1
const STAT_TIME = 2
const STAT_NEW = 3
var highArray = []

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
			errorHighArray = true
			clearHighScore()
		else:
			highArray = f.get_var()
	else:
		print("LOAD ERROR: highScores.zombie does not exist.")
		errorHighArray = true
		clearHighScore()
	if (typeof(highArray) != TYPE_ARRAY) or (highArray.size() == SIZE_DIFFICULTY) or (typeof(highArray[0]) != TYPE_ARRAY) or (highArray[0].size() == SIZE_RANK) or (typeof(highArray[0][0]) != TYPE_ARRAY) or (highArray[0][0].size() == SIZE_STAT) or (typeof(highArray[0][0][STAT_NAME]) != TYPE_STRING) or (typeof(highArray[0][0][STAT_SCORE]) != TYPE_INT) or (typeof(highArray[0][0][STAT_TIME]) != TYPE_INT) or (typeof(highArray[0][0][STAT_NEW]) != TYPE_BOOL):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format.")
		errorHighArray = true
		clearHighScore()
	for difficulty in range(SIZE_DIFFICULTY):
		for rank in range(SIZE_RANK):
			highArray[difficulty][rank][STAT_NEW] = false
	f.close()

func clearHighScore():
	#
	# TODO: Add prompt to delete all highscores and create empty list!
	#
	#Highscores that are saved to disk.
	#  highArray[difficulty][rank][stat] = value
	#  difficulty: range(SIZE_DIFFICULTY)
	#  rank:       range(SIZE_RANK)
	#  stat:       STAT_NAME, STAT_SCORE, STAT_TIME, STAT_NEW
	highArray = []
	for difficulty in range(SIZE_DIFFICULTY):
		highArray.append([])
		for rank in range(SIZE_RANK):
			highArray[difficulty].append(["", 0, 0, false])
	#highDifficulty.sort()
	errorHighArray = false
	saveHighScore()

func saveHighScore():
	#This function is to save the high scores.
	if !errorHighArray:
		var f = File.new()
		var err = f.open_encrypted_with_pass("user://highScores.zombie", File.WRITE, OS.get_unique_ID())
		if err:
			print("SAVE ERROR: " + str(err))
			#
			# TODO: Add prompt to try and save again!
			#
		else:
			f.store_var(highArray)
		f.close()

func updateHighScore(difficulty, name, score, time):
	#remember that new = true
	#This needs to called at the end of the game.
	#Check to see if the player is in the top 10 high scores.  If so, then add to high score.
	#Then trim any high scores past the tenth entry.
	
	sortHighScore()

func sortHighScore():
	#Change currentLastHighScore from its old index to its new one!
	#This function is to sort the high scores before a save.
	pass

func quitGame():
	currentScene.queue_free()
	get_scene().quit()

func popupHighScore():
	#Only display the top 9 of each difficulty.
	if !errorHighArray:
		pass

func popupDonation():
	pass

func startRound(difficulty):
	set_process_input(false)
	#Highscores that are saved to disk.
	#  highArray[difficulty][rank][stat] = value
	#  difficulty: range(SIZE_DIFFICULTY)
	#  rank:       range(SIZE_RANK)
	#  stat:       STAT_NAME, STAT_SCORE, STAT_TIME, STAT_NEW
	for difficulty in range(SIZE_DIFFICULTY):
		for rank in range(SIZE_RANK):
			highArray[difficulty][rank][STAT_NEW] = false
	
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

