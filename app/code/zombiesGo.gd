extends Node

#Time based variables.
#var eclipseRatio = null

#Player stuff.
#var playerScore = null
#var playerTime = null
#var playerDifficulty = null
#var playerHealth = null
#var specialAbilityAmmo = null

func _ready():
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


func _process(delta):
	#This is ran every frame.
	pass

func _input(inputEvent):
	#This is ran every input.
	if (inputEvent.is_pressed()):
		get_node("/root/global").endRound()
