extends Node

#get_node("/root/global").enteringOS               <--This is the proper method to quit to desktop.
#get_node("/root/global").enteringMenu             <--This is the proper method to get to the main menu.
#get_node("/root/global").currentDifficulty        <--This is the proper method to get the difficulty.
#get_node("/root/global").disableInputForXMs(1000) <--This is the proper method to rapid inputs.

#Time based variables.
#var eclipseRatio = null

#Player stuff.
var playerScore = null
var playerTime = null #Units are in seconds.
var playerDifficulty = null #This has to be between 0 and 3 to match the size of xSizeArray and ySizeArray.
#var specialAbilityAmmo = null
var tombArray = []
var tombOrigen = null
var tombs = null
var tombNumberTotal = 0 
var zombieData = [] #[{"node":sub-scene, "zombieTime":time, "zombieStart":rand_range(0, 4), "zombieType":"type", "tombType":"type"}, {...}, ...]
#zombieData[0] = {"node":sub-scene, "zombieTime":time}
#zombieData[1].node = sub-scene
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

#var mouseState = null
#var mousePosition = null

func zombieStart(index): #Don't call unless zombie is below ground.
	zombieData[index].zombieTime = rand_range(1.85, 2.15) #This needs to be in seconds to match playerTime.
	zombieData[index].zombieStart = max(playerTime, 1) + rand_range(0, 4) #This needs to be in seconds to match playerTime.
	
	if zombieData[index].tombType == "rubbleHole":
		zombieData[index].zombieType = "missing"
	else:
		if floor(rand_range(0, 3)) == 0:
			zombieData[index].zombieType = "hat"
		else:
			zombieData[index].zombieType = "normal"

func zombieDataInit():
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
	zombieData.resize(0)
	for x in range(xSizeArray[playerDifficulty]):
		for y in range(ySizeArray[playerDifficulty]):
			zombieData.append({"node":tombArray[x][y], "zombieTime":0, "zombieStart":0, "zombieType":"x", "tombType":"x", "MARGIN_TOP":tombArray[x][y].get_margin(MARGIN_TOP)})
	for c in range(zombieData.size()):
		if zombieData.empty():
			continue
		zombieData[c].node.get_node("zombieClickMask").show() #Make zombieClickMask visible so it can be clicked.
		#print(zombieData)
		#print(zombieData[c])
		#print(zombieData[c].node)
		#print(zombieData[c].node.get_node("rubbleHole"))
		#var x = zombieData[c].node.get_node("rubbleHole")
		#print(x)
		#print(x.is_visible())
		#print(zombieData[c].node.get_node("rubbleHole").CanvasItem)
		#print(zombieData[c].node.get_node("rubbleHole").CanvasItem.is_visible)
		#print(zombieData[c].node.get_node("rubbleHole").get_property_list)
		
		if zombieData[c].node.get_node("rubbleHole").is_visible():
			zombieData[c].tombType = "rubbleHole"
			zombieData[c].zombieType = "missing"
		
		if zombieData[c].node.get_node("normalTomb").is_visible():
			zombieData[c].tombType = "normalTomb"
			zombieData[c].node.get_node("tombClickMask").show()
		
		if zombieData[c].node.get_node("brokenTomb").is_visible():
			zombieData[c].tombType = "brokenTomb"
			
		if zombieData[c].node.get_node("missingTomb").is_visible():
			zombieData[c].tombType = "missingTomb"
			
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
	set_process_input(true) #Enables: _input(InputEvent) to run every mouse change.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
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
		pass
		
	zombieMove()


func isDied():
	get_node("/root/global").enteringMenu = true
	get_node("/root/global").updateHighScore(playerScore, playerTime)

func _on_backGround_pressed():
	if get_node("/root/global").isInputEnabled():
		#Submit current game and save highArray before ending round.
		#updateHighScore(score, time)
		get_node("/root/global").enteringMenu = true
		get_node("/root/global").updateHighScore(rand_range(0, 9999), rand_range(0, 59))

func zombieMove(): #Move zombies up, then down, based on playerTime, zombieTime, zombieStart.
	for c in range(zombieData.size()):

		if zombieData.empty():
			continue

		if zombieData[c].zombieType == "normal":
			zombieData[c].node.get_node("zombieNormal").show()
			zombieData[c].node.get_node("zombieHatBody").hide()
			zombieData[c].node.get_node("zombieHatHead").hide()
			if playerTime < zombieData[c].zombieStart: #Before start
				zombieData[c].node.get_node("zombieNormal").set_margin(MARGIN_TOP, 0)
				zombieData[c].node.get_node("zombieClickMask").set_margin(MARGIN_TOP, 0)
				
			elif playerTime < (zombieData[c].zombieStart + (zombieData[c].zombieTime / 2)): #Going up
				zombieData[c].node.get_node("zombieNormal").set_margin(MARGIN_TOP,  ((-190 / zombieData[c].zombieTime) * playerTime) + (zombieData[c].zombieStart * (190 / zombieData[c].zombieTime)))
				zombieData[c].node.get_node("zombieClickMask").set_margin(MARGIN_TOP,  ((-190 / zombieData[c].zombieTime) * playerTime) + (zombieData[c].zombieStart * (190 / zombieData[c].zombieTime)))
				
			elif playerTime < (zombieData[c].zombieStart + zombieData[c].zombieTime): #Going down
				zombieData[c].node.get_node("zombieNormal").set_margin(MARGIN_TOP,  ((190 / zombieData[c].zombieTime) * playerTime) - ((zombieData[c].zombieStart + zombieData[c].zombieTime) * (190 / zombieData[c].zombieTime)))
				zombieData[c].node.get_node("zombieClickMask").set_margin(MARGIN_TOP,  ((190 / zombieData[c].zombieTime) * playerTime) - ((zombieData[c].zombieStart + zombieData[c].zombieTime) * (190 / zombieData[c].zombieTime)))
				
			else: #playerTime >= (zombieData[c].zombieStart + zombieData[c].zombieTime): #Reset zombieStart
				zombieData[c].node.get_node("zombieNormal").set_margin(MARGIN_TOP, 0)
				zombieData[c].node.get_node("zombieClickMask").set_margin(MARGIN_TOP, 0)
				zombieStart(c)
				
		elif zombieData[c].zombieType == "hat":
			zombieData[c].node.get_node("zombieNormal").hide()
			zombieData[c].node.get_node("zombieHatBody").show()
			zombieData[c].node.get_node("zombieHatHead").show()
			if playerTime < zombieData[c].zombieStart: #Before start
				zombieData[c].node.get_node("zombieHatBody").set_margin(MARGIN_TOP, 0)
				zombieData[c].node.get_node("zombieHatHead").set_margin(MARGIN_TOP, 0)
				zombieData[c].node.get_node("zombieClickMask").set_margin(MARGIN_TOP, 0)
				
			elif playerTime < (zombieData[c].zombieStart + (zombieData[c].zombieTime / 2)): #Going up
				zombieData[c].node.get_node("zombieHatBody").set_margin(MARGIN_TOP,  ((-190 / zombieData[c].zombieTime) * playerTime) + (zombieData[c].zombieStart * (190 / zombieData[c].zombieTime)))
				zombieData[c].node.get_node("zombieHatHead").set_margin(MARGIN_TOP,  ((-190 / zombieData[c].zombieTime) * playerTime) + (zombieData[c].zombieStart * (190 / zombieData[c].zombieTime)))
				zombieData[c].node.get_node("zombieClickMask").set_margin(MARGIN_TOP,  ((-190 / zombieData[c].zombieTime) * playerTime) + (zombieData[c].zombieStart * (190 / zombieData[c].zombieTime)))
				
			elif playerTime < (zombieData[c].zombieStart + zombieData[c].zombieTime): #Going down
				zombieData[c].node.get_node("zombieHatBody").set_margin(MARGIN_TOP,  ((190 / zombieData[c].zombieTime) * playerTime) - ((zombieData[c].zombieStart + zombieData[c].zombieTime) * (190 / zombieData[c].zombieTime)))
				zombieData[c].node.get_node("zombieHatHead").set_margin(MARGIN_TOP,  ((190 / zombieData[c].zombieTime) * playerTime) - ((zombieData[c].zombieStart + zombieData[c].zombieTime) * (190 / zombieData[c].zombieTime)))
				zombieData[c].node.get_node("zombieClickMask").set_margin(MARGIN_TOP,  ((190 / zombieData[c].zombieTime) * playerTime) - ((zombieData[c].zombieStart + zombieData[c].zombieTime) * (190 / zombieData[c].zombieTime)))
				
			else: #playerTime >= (zombieData[c].zombieStart + zombieData[c].zombieTime): #Reset zombieStart
				zombieData[c].node.get_node("zombieHatBody").set_margin(MARGIN_TOP, 0)
				zombieData[c].node.get_node("zombieHatHead").set_margin(MARGIN_TOP, 0)
				zombieData[c].node.get_node("zombieClickMask").set_margin(MARGIN_TOP, 0)
				zombieStart(c)
		elif zombieData[c].zombieType == "missing":
			zombieData[c].node.get_node("zombieNormal").hide()
			zombieData[c].node.get_node("zombieHatBody").hide()
			zombieData[c].node.get_node("zombieHatHead").hide()
		else:
			print("Variable zombieType is set to an incorrect value.")
			continue

func onZombieClicked():
	pass
	
func onTombClicked():
	#tombClickMask
	pass
	
func _input(ev):
	# Mouse in viewport coordinates. "ev" is an instance of the class InputEvent.
	
	if (ev.type==InputEvent.MOUSE_BUTTON):
		print("Mouse Click/Unclick at: ",ev.pos)
	elif (ev.type==InputEvent.MOUSE_MOTION):
		print("Mouse Motion at: ",ev.pos)
		get_node("mouse").set_margin(MARGIN_TOP, ev.pos.y)
		get_node("mouse").set_margin(MARGIN_LEFT, ev.pos.x)
		
	mouseEmpty()

func mouseEmpty(): #This shows empty hands for the mouse.
	pass

func mouseHeld(): #This shows held tombstone for the mouse.
	get_node("mouse").get_node("held").show()
	pass

func mouseBreaking(): #This shows tombstone breaking animation for the mouse.
	pass

func mouseSwinging(): #This shows tombstone swinging animation for the mouse.
	pass
	