extends AnimatedSprite

func _ready():
	# Initalization here
	pass

func mouseEmpty(): #This shows empty hands for the mouse.
	get_node("anim").play("empty")
	pass

func mouseHeld(): #This shows held tombstone for the mouse.
	get_node("anim").play("held")
	pass

func mouseBreaking(): #This shows tombstone breaking animation for the mouse.
	if (get_node("anim").get_current_animation() != "breaking"
		and get_node("anim").get_current_animation() != "empty"):
		get_node("anim").play("breaking")
	pass

func mouseSwinging(): #This shows tombstone swinging animation for the mouse.
	if (get_node("anim").get_current_animation() == "held"):
		get_node("anim").play("swinging")
	pass
	