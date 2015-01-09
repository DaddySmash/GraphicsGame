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
#var specialAbilityAmmo = null
var tombArray = []
var tombOrigen = null
var tombs = null
var tombNumberTotal = 0 
var zombieData = [] #[{"node":tomb, "zombieTime":time, "zombieStart":rand_range(0, 4)}, {...}, ...]
#zombieData[0] = {"node":tomb, "zombieTime":time}
#zombieData[1].node = tomb
const xTombSpacing = 200
const yTombSpacing = 175
var tombStyle = null
var tombList = []
var time = null

var xSizeArray = [3, 3, 4, 6] #[Easy, Normal, Hard, Insane]
var ySizeArray = [1, 2, 3, 3] #[Easy, Normal, Hard, Insane]
var playerHealth = [3, 3, 3, 3] #[Easy, Normal, Hard, Insane]
var voidTombs = [0, 1, 2, 3] #[Easy, Normal, Hard, Insane] These tomb placeholders do not have any zombies coming up.
var howDiedTombCount = 3 #this is a count of the number of different flavor texts that go on tombstones.
#var tombArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ",", ".", "_", "-"]

func zombieStart(index):
	zombieData[index].zombieTime = rand_range(1.85, 2.15)
	zombieData[index].zombieStart = rand_range(0, 4)

func zombieDataInit():
	zombieData.resize(0)
	for x in range(xSizeArray[playerDifficulty]):
		for y in range(ySizeArray[playerDifficulty]):
			zombieData.append({"node":tombArray[x][y], "zombieTime":0, "zombieStart":0})
	for c in range(zombieData.size()):
		if zombieData.empty():
			continue
		zombieStart(c)

func getIndexFromNode(node): #When passed a node, find that node's index inside of zombieData.
	for c in range(zombieData.size()):
		if zombieData.empty():
			continue
		if zombieData[c].node == node:
			return c
	return null

func _ready():
	get_tree().set_auto_accept_quit(false) #Enables: _notification(what) to recieve MainLoop.NOTIFICATION_WM_QUIT_REQUEST
	set_process(true) #Enables: _process(delta) to run every frame.
	playerDifficulty = get_node("/root/global").currentDifficulty
	
	tombs = get_node("tombs")
	
	#for g in range(glyphArray.size()):
	#	n = load("res://scene/getNameGlyph.xscn").instance()
	#	glyph.add_child(n)
	
	tombArray.resize(0) #This initiallizes the tombArray to empty before we start adding to it.
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
	
	createTombList()
	
	for c in range(playerHealth[playerDifficulty]): #Make normal tombs for player health.
		if tombList.empty():
			continue
		var i = floor(rand_range(0, tombList.size()))
		tombList[i].get_node("normalTomb").show()
		tombList[i].get_node("frontHole").show()
		tombList[i].get_node("backHole").show()
		#tombList[i].get_node("rubbleHole").show()
		tombList.remove(i)
		
	for c in range(voidTombs[playerDifficulty]): #Make void tombs.
		if tombList.empty():
			continue
		var i = floor(rand_range(0, tombList.size()))
		tombList[i].get_node("rubbleHole").show()
		tombList.remove(i)
	
	for i in range(tombList.size()): #Make the rest of the tombs.
		if tombList.empty():
			continue
		var r = floor(rand_range(0, 2))
		if r == 0:
			tombList[i].get_node("brokenTomb").show()
			tombList[i].get_node("frontHole").show()
			tombList[i].get_node("backHole").show()
			#tombList[i].get_node("rubbleHole").show()
		elif r == 1:
			tombList[i].get_node("missingTomb").show()
			tombList[i].get_node("frontHole").show()
			tombList[i].get_node("backHole").show()
			#tombList[i].get_node("rubbleHole").show()
		else:
			pass
			
	createTombList()
	zombieDataInit()
	

func createTombList(): #Create List
	tombList.resize(0)
	for x in range(xSizeArray[playerDifficulty]):
		for y in range(ySizeArray[playerDifficulty]):
			tombList.append(tombArray[x][y])

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
	time = int(floor(playerTime))
	# Check for death.
	if playerDifficulty == 3:
		#isDied()= true
		pass
		
	for c in range(zombieData.size()): #Temporarily make all zombies show. # Mayby use zombieData.size()
		if zombieData.empty():
			continue
		var i = floor(rand_range(0, zombieData.size()))
		zombieData[i].node.get_node("zombieNormal").show()
		#if time <= 2:
		#	zombieMove() = true
		#else:
		#	zombieMove() = false

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
	
func isDied():
	get_node("/root/global").enteringMenu = true
	get_node("/root/global").updateHighScore(playerScore, playerTime)
	
func zombieMove(): #Now move zombies up, then down.  Use zombieTime.
	for x in range(xSizeArray[playerDifficulty]):
		for y in range(ySizeArray[playerDifficulty]):
			#MARGIN_LEFT, MARGIN_TOP, MARGIN_RIGHT, MARGIN_BOTTOM
			if time % 2 > 0.5:
				#This one runs second.
				tombArray[x][y].get_node("zombieNormal").set_margin(MARGIN_TOP, tombArray[x][y].get_node("zombieNormal").get_margin(MARGIN_TOP)+1)
			else:
				#This one runs first.
				tombArray[x][y].get_node("zombieNormal").set_margin(MARGIN_TOP, tombArray[x][y].get_node("zombieNormal").get_margin(MARGIN_TOP)-1)
	if time > 2:
		return
