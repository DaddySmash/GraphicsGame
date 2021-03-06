extends Node

#This is used by global.gd for changing scenes.
var currentScene = null
var currentDifficulty = 1
var currentName = "RIP"
var currentScore = "0"
var currentTime = "12:00"
var errorHighArray = false
var enteringOS = false
var enteringMenu = false
var enteringRound = false
var enteringDonate = false
var disableInputTilTime = OS.get_ticks_msec()
const defaultDisableInputLength = 500;
# func disableInputForXMs(x = defaultDisableInputLength)
# func isInputEnabled()

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
	get_tree().set_auto_accept_quit(false) #Enables: _notification(what) to recieve MainLoop.NOTIFICATION_WM_QUIT_REQUEST
	randomize()
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	loadHighScore()

func _notification(what):
	if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		get_tree().quit() #default behavior

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
	if (errorHighArray == false):
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
		if (typeof(highArray[0][0][STAT_SCORE]) != TYPE_STRING):
			print("LOAD ERROR: highScores.zombie is using an outdated or incorrect format. ID08")
			errorHighArray = true
		if (typeof(highArray[0][0][STAT_TIME]) != TYPE_STRING):
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
	for difficultyTemp in range(SIZE_DIFFICULTY):
		for rankTemp in range(SIZE_RANK):
			highArray[difficultyTemp][rankTemp][STAT_NEW] = false
	
	if score <= 0:
		enterHighScore()
	elif time <= 0:
		enterHighScore()
	else:
		currentName = "RIP"
		currentScore = str(floor(score))
		currentTime = timeString(time)
		var i = highArray[currentDifficulty]
		i[SIZE_RANK - 1][STAT_NAME] = currentName
		i[SIZE_RANK - 1][STAT_SCORE] = currentScore
		i[SIZE_RANK - 1][STAT_TIME] = currentTime
		i[SIZE_RANK - 1][STAT_NEW] = true
		
		#sorting highArray:
		i.sort_custom(get_node("/root/global"), "sortLogic")
		
		#Only if the new score was sorted into the top 9!:
		if i[SIZE_RANK - 1][STAT_NEW] == false:
			enterGetName()
		else:
			enterHighScore()

func updateHighScorePart2():
	#The last index of highArray is never displayed and is overridden with any new score before sorting.
	
	#Highscores that are saved to disk.
	#  highArray[difficulty][rank][stat] = value
	#  difficulty: range(SIZE_DIFFICULTY)
	#  rank:       range(SIZE_RANK)
	#  stat:       STAT_NAME, STAT_SCORE, STAT_TIME, STAT_NEW
	
	#highArray[currentDifficulty][SIZE_RANK - 1][STAT_NAME] = currentName WILL THROW AN ERROR MESSAGE OF "INVALID GET INDREX '0' (on base: 'int')" INCORRECTLY USING "var i = highArray[currentDifficulty]" as a workaround.
	print("updateHighScorePart2 " + currentTime + " " + currentName + " " + currentScore)
	for rankTemp in range(SIZE_RANK):
		if highArray[currentDifficulty][rankTemp][STAT_NEW] == true:
			highArray[currentDifficulty][rankTemp][STAT_NAME] = currentName
	saveHighScore()
	enterHighScore()

func sortLogic(first, second):
	if second[STAT_SCORE] < first[STAT_SCORE]:
		return true
	else:
		return false

func timeString(time):
	time = int(floor(time))
	if time < 10:
		return "12:0" + str(time)
	elif time < 60:
		return "12:" + str(time)
	elif time % 60 < 10:
		return str(floor(time / 60)) + ":0" + str(time % 60)
	else:
		return str(floor(time / 60)) + ":" + str(time % 60)

func disableInputForXMs(x = defaultDisableInputLength):
	disableInputTilTime = OS.get_ticks_msec() + x

func isInputEnabled():
	return (OS.get_ticks_msec() >= disableInputTilTime)

func enterOS():
	get_tree().quit()

func enterGetName():
	#Make sure you call get_node("/root/global").currentName = "INITAlS" AND get_node("/root/global").updateHighScorePart2()
	if !errorHighArray:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var s = ResourceLoader.load("res://scene/getName.xscn")
		currentScene.queue_free()
		currentScene = s.instance()
		get_tree().get_root().add_child(currentScene)
		disableInputForXMs()

func enterHighScore():
	#Only display the top 9 of each difficulty.
	if !errorHighArray:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var s = ResourceLoader.load("res://scene/highScore.xscn")
		currentScene.queue_free()
		currentScene = s.instance()
		get_tree().get_root().add_child(currentScene)
		disableInputForXMs()

func enterDonate():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	OS.shell_open("https://github.com/DaddySmash/GraphicsGame")
	#var s = ResourceLoader.load("res://scene/donate.xscn")
	#currentScene.queue_free()
	#currentScene = s.instance()
	#get_tree().get_root().add_child(currentScene)
	enteringDonate = false
	disableInputForXMs()

func enterRound(difficulty):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	currentDifficulty = difficulty #currentDifficulty should be accessed by zombiesGo.gd
	
	var s = ResourceLoader.load("res://scene/zombiesGo.xscn")
	currentScene.queue_free()
	currentScene = s.instance()
	get_tree().get_root().add_child(currentScene)
	enteringRound = false
	disableInputForXMs(1000)

func enterMenu():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var s = ResourceLoader.load("res://scene/menu.xscn")
	currentScene.queue_free()
	currentScene = s.instance()
	get_tree().get_root().add_child(currentScene)
	enteringMenu = false
	disableInputForXMs()