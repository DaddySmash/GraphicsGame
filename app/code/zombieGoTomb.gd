

func _on_clickArea_pressed():
	print("Zombie Clicked")
	pass # replace with function body


func _on_tombClickMask_pressed():
	print("Tomb Clicked")
	if (get_parent().get_parent().get_node("mouse").get_node("animations").get_node("anim").get_current_animation() == "empty"
		and get_node("normalTomb").is_visible()):
		get_node("normalTomb").hide() #We may need to change the data structure to hold the tombs new state.
		get_node("missingTomb").show()
		get_parent().get_parent().get_node("mouse").get_node("animations").mouseHeld()
	pass 
