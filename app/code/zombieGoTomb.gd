var index = null

func _on_clickArea_pressed():
	index = get_parent().get_parent().getIndexFromNode(self)
	print("Zombie Clicked ", index)
	if(get_parent().get_parent().zombieData[index].zombieFadeStart == 0):
		get_parent().get_parent().zombieFadeStart(index)
		get_parent().get_parent().playerScore += 1

func _on_tombClickMask_pressed():
	print("Tomb Clicked")
	if (get_parent().get_parent().get_node("mouse").get_node("animations").get_node("anim").get_current_animation() == "empty"
		and get_node("normalTomb").is_visible()):
		get_node("normalTomb").hide() #We may need to change the data structure to hold the tombs new state.
		get_node("missingTomb").show()
		get_parent().get_parent().get_node("mouse").get_node("animations").mouseHeld()

