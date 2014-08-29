extends Node

#This is used by global.gd for changing scenes.
var currentScene = null
var currentDifficulty = 1
var currentName = "RIP"
var currentScore = "0"
var currentTime = "12:00"
var errorHighArray = false

#Highscores that are saved to disk.
#  highArray[difficulty][rank][stat] = value
#  difficulty: range(SIZE_DIFFICULTY)
#  rank:       range(SIZE_RANK)
#  stat:       STAT_NAME, STAT_SCORE, STAT_TIME, STAT_NEW
const FIVE = 5

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
		else:
			highArray = f.get_var()
	else:
		print("LOAD ERROR: highScores.zombie does not exist.")
		errorHighArray = true
	if (typeof(highArray) != TYPE_ARRAY):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID01")
		errorHighArray = true
	if (highArray.size() + 1 == SIZE_DIFFICULTY):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID02")
		errorHighArray = true
	if (typeof(highArray[0]) != TYPE_ARRAY):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID03")
		errorHighArray = true
	if (highArray[0].size() + 1 == SIZE_RANK):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID04")
		errorHighArray = true
	if (typeof(highArray[0][0]) != TYPE_ARRAY):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID05")
		errorHighArray = true
	if (highArray[0][0].size() + 1 == SIZE_STAT):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID06")
		errorHighArray = true
	if (typeof(highArray[0][0][STAT_NAME]) != TYPE_STRING):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID07")
		errorHighArray = true
	if (typeof(highArray[0][0][STAT_SCORE]) != TYPE_INT):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID08")
		errorHighArray = true
	if (typeof(highArray[0][0][STAT_TIME]) != TYPE_INT):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID09")
		errorHighArray = true
	if (typeof(highArray[0][0][STAT_NEW]) != TYPE_BOOL):
		print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID10")
		errorHighArray = true
	if errorHighArray:
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
			highArray[difficulty].append([])
			highArray[difficulty][rank].append("RIP")
			highArray[difficulty][rank].append("0")
			highArray[difficulty][rank].append("12:00")
			highArray[difficulty][rank].append(false)
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
			f.seek(0)
			f.store_var(highArray)
			print("SAVE DONE")
		f.close()

func updateHighScore(score, time):
	if score < 0:
		return
	if time < 0:
		return
	currentScore = str(floor(score))
	currentTime = timeString(time)
	popupGetName()

func updateHighScorePart2():
	#The last index of highArray is never displayed and is overridden with any new score before sorting.
	
	#Highscores that are saved to disk.
	#  highArray[difficulty][rank][stat] = value
	#  difficulty: range(SIZE_DIFFICULTY)
	#  rank:       range(SIZE_RANK)
	#  stat:       STAT_NAME, STAT_SCORE, STAT_TIME, STAT_NEW
	
	# highArray[currentDifficulty][SIZE_RANK - 1][STAT_NAME] = currentName WILL THROW AN ERROR MESSAGE OF "INVALID GET INDREX '0' (on base: 'int')" INCORRECTLY USING "var i = highArray[currentDifficulty]" as a workaround.
	var i = highArray[currentDifficulty]
	i[SIZE_RANK - 1][STAT_NAME] = currentName
	i[SIZE_RANK - 1][STAT_SCORE] = currentScore
	i[SIZE_RANK - 1][STAT_TIME] = currentTime
	i[SIZE_RANK - 1][STAT_NEW] = true
	
	#sorting highArray:
	i.sort_custom(get_node("/root/global"), "sortLogic")
	
	#Only if there is a change:
	saveHighScore()

func sortLogic(first, second):
	if second[STAT_SCORE] < first[STAT_SCORE]:
		return true
	else:
		return false

func timeString(time):
	time = floor(time)
	if time < 10:
		return "12:0" + str(time)
	elif time < 60:
		return "12:" + str(time)
	elif time % 60 < 10:
		return str(floor(time / 60)) + ":0" + str(time % 60)
	else:
		return str(floor(time / 60)) + ":" + str(time % 60)

func quitGame():
	get_scene().quit()

func popupGetName():
	currentName = "Bob"
	updateHighScorePart2()
	pass

func popupHighScore():
	#Only display the top 9 of each difficulty.
	if !errorHighArray:
		var s = ResourceLoader.load("res://scene/highScore.xscn")
		currentScene.queue_free()
		currentScene = s.instance()
		get_scene().get_root().add_child(currentScene)

func popupDonation():
	pass

func startRound(difficulty):
	currentDifficulty = difficulty #currentDifficulty should be accessed by zombiesGo.gd
	
	#Highscores that are saved to disk.
	#  highArray[difficulty][rank][stat] = value
	#  difficulty: range(SIZE_DIFFICULTY)
	#  rank:       range(SIZE_RANK)
	#  stat:       STAT_NAME, STAT_SCORE, STAT_TIME, STAT_NEW
	for difficultyTemp in range(SIZE_DIFFICULTY):
		for rankTemp in range(SIZE_RANK):
			highArray[difficultyTemp][rankTemp][STAT_NEW] = false
	
	var s = ResourceLoader.load("res://scene/zombiesGo.xscn")
	currentScene.queue_free()
	currentScene = s.instance()
	get_scene().get_root().add_child(currentScene)

func endRound():
	var s = ResourceLoader.load("res://scene/intro.xscn")
	currentScene.queue_free()
	currentScene = s.instance()
	get_scene().get_root().add_child(currentScene)