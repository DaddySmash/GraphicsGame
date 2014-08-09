extends Node2D

var counter = 0
var x = 0
var credits = [
    "Manager\nXXXX",
    "Programming\nXXXX",
    "Graphic Artist\nXXXX",
    "Musician\nXXXX",
    "Story\nXXXX"
    ]

func _ready():
	pass

func next_credit():
    if (counter < credits.size()):
        get_node("text").set_text(credits[counter])
        counter += 1
        x += 1
    else: #if x > 5:
        counter = 0
