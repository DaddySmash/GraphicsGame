extends Node

#This is used by global.gd for changing scenes.
var current_scene = null

#These need saved to disk.
var savedHighScore = null
var savedHighTime = null
var savedHighDifficulty = null
var savedHighName = null

#Time based variables.
var eclipseRatio = null

#Player stuff.
var playerScore = null
var playerTime = null
var playerDifficulty = null
var playerHealth = null
#var specialAbilityAmmo = null

func _ready():
    get_scene().set_auto_accept_quit(false)
    loadHighScore()
    playerScore = 0
    savedHighScore = [0, 1, 2]
    savedHighTime = [0, 1, 2]
    savedHighDifficulty = [0, 1, 2]
    savedHighName = [0, 1, 2]
    var root = get_scene().get_root()
    current_scene = root.get_child( root.get_child_count() -1 )

func _notification(what):
    if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
        get_scene().quit() #default behavior

func start_round(difficulty):
	set_process_input(false)
	
	#Init settings for round.
	playerDifficulty = difficulty
	eclipseRatio = (difficulty - 1) * 0.2
	playerScore = 0
	playerTime = 0
	#specialAbilityAmmo = 0
	if playerDifficulty == 1:
		playerHealth = 3
	if playerDifficulty == 2:
		playerHealth = 6
	if playerDifficulty == 3:
		playerHealth = 5
	if playerDifficulty == 4:
		playerHealth = 4
	
	var s = ResourceLoader.load("res://scene/zombiesGo.xscn")
	
	#get_node("exitScene").active(true)
	
	current_scene.queue_free()
	current_scene = s.instance()
	get_scene().get_root().add_child(current_scene)

func end_round():
    var s = ResourceLoader.load("res://scene/intro.xscn")
    current_scene.queue_free()
    current_scene = s.instance()
    get_scene().get_root().add_child(current_scene)

func sortHighScore():
    #This function is to sort the high scores before a save.
    pass

func saveHighScore():
    #This function is to save the high scores.
    var f = File.new()
    var err = f.open_encrypted_with_pass("user://highScores.zombie", File.WRITE, OS.get_unique_ID())
    if err:
        print("SAVE ERROR: " + str(err))
    else:
        f.store_var(savedHighScore)
        f.store_var(savedHighTime)
        f.store_var(savedHighDifficulty)
        f.store_var(savedHighName)
    f.close()

func loadHighScore():
    #this function is to load the high scores for viewing.
    var f = File.new()
    if f.file_exists("user://highScores.zombie"):
        var err = f.open_encrypted_with_pass("user://highScores.zombie", File.READ, OS.get_unique_ID())
        if err:
            print("LOAD ERROR: " + str(err))
        else:
            savedHighScore = f.get_var()
            savedHighTime = f.get_var()
            savedHighDifficulty = f.get_var()
            savedHighName = f.get_var()
    else:
        print("LOAD ERROR: highScores.zombie does not exist.")
    f.close()

func newHighScore(savedHighScore, savedHighTime, savedHighDifficulty, savedHighName):
    #This needs to called at the end of the game.
    #Check to see if the player is in the top 10 high scores.  If so, then add to high score.
    
    sortHighScore()
    
    # Trim any high scores past the tenth entry.

func getSavedHighScore():
    return savedHighScore

func exitGame():
	get_scene().quit()
	