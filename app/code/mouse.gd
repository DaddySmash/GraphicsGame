extends AnimatedSprite

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initalization here
	pass


func mouseEmpty(): #This shows empty hands for the mouse.
	get_node("anim").play("empty")
	pass

func mouseHeld(): #This shows held tombstone for the mouse.
	print("I made it here!")
	#get_node("mouse").get_node("held").show()
	get_node("anim").play("held")
	pass

func mouseBreaking(): #This shows tombstone breaking animation for the mouse.
	if (get_node("anim").get_current_animation() != "breaking"):
		get_node("anim").play("breaking")
	else: 
		print(get_node("mouse").get_node("animations").get_node("anim").get_current_animation())
	pass

func mouseSwinging(): #This shows tombstone swinging animation for the mouse.
	if (get_node("anim").get_current_animation() != "swinging"):
		get_node("anim").play("swinging")
	else: 
		print(get_node("anim").get_current_animation())
	pass
	