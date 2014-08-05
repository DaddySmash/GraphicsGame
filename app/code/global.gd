extends Node

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
#var specialAbilityAmmo

func _ready():
    get_scene().set_auto_accept_quit(false)
    loadHighScore()
    playerScore = 0
    savedHighScore = [0, 1, 2]
    savedHighTime = [0, 1, 2]
    savedHighDifficulty = [0, 1, 2]
    savedHighName = [0, 1, 2]
func _notification(what):
    if (what==MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
        get_scene().quit() #default behavior

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
