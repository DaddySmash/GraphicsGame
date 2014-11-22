extends Node

#get_node("/root/global").enteringOS   <--This is the proper method to quit to desktop.
#get_node("/root/global").enteringMenu  <--This is the proper method to get to the main menu.
#get_node("/root/global").currentDifficulty  <--This is the proper method to get the difficulty.

#Time based variables.
#var eclipseRatio = null

#Player stuff.
var playerScore = null
var playerTime = null
var playerDifficulty = null #This has to be between 0 and 3 to match the size of xSizeArray and ySizeArray.
var playerHealth = null
#var specialAbilityAmmo = null
var tombArray = []
var tombOrigen = null
var tombs = null
var tombNumberTotal = 0
var xSizeArray = [3, 3, 4, 6] #[Easy, Normal, Hard, Insane]
var ySizeArray = [1, 2, 3, 3] #[Easy, Normal, Hard, Insane]
var howDiedTombCount = 3 #this is a count of the number of different flavor texts that go on tombstones.
var xTombSpacing = null
var yTombSpacing = null
var tombStyle = null
var tombList = []

#var tombArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ",", ".", "_", "-"]

func _ready():
	get_scene().set_auto_accept_quit(false) #Enables: _notification(what) to recieve MainLoop.NOTIFICATION_WM_QUIT_REQUEST
	set_process(true) #Enables: _process(delta) to run every frame.
	playerDifficulty = get_node("/root/global").currentDifficulty
	
	tombs = get_node("tombs")
	xTombSpacing = 200
	yTombSpacing = 175

	#for g in range(glyphArray.size()):
	#	n = load("res://scene/getNameGlyph.xscn").instance()
	#	glyph.add_child(n)
	
	tombArray.resize(0)
	for x in range(xSizeArray[playerDifficulty]):
		tombArray.append([])
		for y in range(ySizeArray[playerDifficulty]):
			tombArray[x].append(load("res://scene/zombiesGoTomb.xscn").instance())
			#print("Hello World " + str(x) + ", " + str(y))
			#MARGIN_LEFT, MARGIN_TOP, MARGIN_RIGHT, MARGIN_BOTTOM
			tombArray[x][y].set_margin(MARGIN_LEFT, 1280/2 - xSizeArray[playerDifficulty]*xTombSpacing/2 + x * xTombSpacing + floor(rand_range( -xTombSpacing*.2, xTombSpacing*.2)))
			tombArray[x][y].set_margin(MARGIN_TOP, 720/2 - ySizeArray[playerDifficulty]*yTombSpacing/2  + y * yTombSpacing)
			tombs.add_child(tombArray[x][y])
			
	
	#Init settings for round.
	#eclipseRatio = (difficulty - 1) * 0.2
	playerScore = 0
	playerTime = 0
	#specialAbilityAmmo = 0
	if playerDifficulty == 0:
		playerHealth = 3
	if playerDifficulty == 1:
		playerHealth = 3
	if playerDifficulty == 2:
		playerHealth = 3
	if playerDifficulty == 3:
		playerHealth = 3
	
	#Create List
	tombList.resize(0)
	for x in range(xSizeArray[playerDifficulty]):
		for y in range(ySizeArray[playerDifficulty]):
			tombList.append(tombArray[x][y])
			
			
			#tombStyle = floor(rand_range( 0, 3)) #If floor ever returns the high value, it will be a bug on this line.
			#tombArray[x][y].get_node("normalTomb").show()
			#tombArray[x][y].get_node("backHole").show()
			#tombArray[x][y].get_node("frontHole").show()
	
	for c in range(playerHealth):
		if tombList.empty():
			continue
		var i = floor(rand_range(0, tombList.size()))
		tombList[i].get_node("normalTomb").show()
		tombList.remove(i)
	
	for i in range(tombList.size()):
		var r = floor(rand_range(0, 3))
		if r == 1:
			tombList[i].get_node("brokenTomb").show()
		elif r == 2:
			tombList[i].get_node("missingTomb").show()
		else:
			pass

func _notification(what):
	if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		#Submit current game and save highArray before exiting.
		get_node("/root/global").enteringOS = true
		get_node("/root/global").updateHighScore(rand_range(0, 9999), rand_range(0, 59))

func _process(delta):
	#This is ran every frame.
	#get_node("/root/global").timeString(time)
	playerTime = playerTime + delta
	get_node("displayPlayerTimeOnScreen").set_text(get_node("/root/global").timeString(playerTime))
	

func _on_backGround_pressed():
	#Submit current game and save highArray before ending round.
	#updateHighScore(score, time)
	get_node("/root/global").enteringMenu = true
	get_node("/root/global").updateHighScore(rand_range(0, 9999), rand_range(0, 59))

func _on_frontGround_pressed():
	#Submit current game and save highArray before ending round.
	#updateHighScore(score, time)
	get_node("/root/global").enteringMenu = true
	get_node("/root/global").updateHighScore(rand_range(0, 9999), rand_range(0, 59))