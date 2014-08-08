
extends Control

var counter = 0
var x = 0
textHeight = ""

# member variables here, example:
# var a=2
# var b="textvar"

var credits = [
    "Manager\nXXXX",
    "Programming\nXXXX",
    "Graphic Artist\nXXXX",
    "Musician\nXXXX",
    "Story\nXXXX"
    ]

func _ready():
	# Initalization here
	textHeight = get_node("text").get_height()
	pass

func next_credit():
    if (counter < credits.size()):
        get_node("text").set_text(credits[counter])
        counter += 1
        x += 1
    else:
        counter = 0

    #if x > 5:
        get_scene().quit()