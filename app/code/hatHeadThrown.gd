
#extends AnimatedSprite
extends TextureButton

var index = null

func getDamaged():
	index = get_parent().get_parent().get_parent().getIndexFromNode(self.get_parent())
	if(get_parent().get_parent().get_parent().zombieData[index].zombieFadeStart != 0): #Check to see if the zombie was killed.
		return
	print("Get Damaged ", index)
	#Start showing red damage on screen. Then fade it out.  If it is fading, then restart the fading animation.
	get_parent().get_parent().get_parent().get_node("recievingDamage").get_node("anim").play("damage")
	get_parent().get_parent().get_parent().get_node("recievingDamage").get_node("anim").seek( 0, true)
	get_parent().get_parent().get_parent().get_node("recievingDamage").show()
	if (get_parent().get_parent().get_parent().get_node("mouse").get_node("animations").get_node("anim").get_current_animation() == "empty"):
		print("Death due to zombie.")
		get_parent().get_parent().get_parent().isDied()
		
	elif (get_parent().get_parent().get_parent().get_node("mouse").get_node("animations").get_node("anim").get_current_animation() == "held"):
		get_parent().get_parent().get_parent().get_node("mouse").get_node("animations").get_node("anim").play("breaking")
		print("Tomb was held.")
		
	elif (get_parent().get_parent().get_parent().get_node("mouse").get_node("animations").get_node("anim").get_current_animation() == "swinging"):
		get_parent().get_parent().get_parent().get_node("mouse").get_node("animations").get_node("anim").play("breaking")
		print("Tomb was swinging.")
		
	elif (get_parent().get_parent().get_parent().get_node("mouse").get_node("animations").get_node("anim").get_current_animation() == "breaking"): #If you are breaking, then you are immune to damage.
		print("Tomb was breaking.")
		
	else:
		print("Death due to error.")
		get_parent().get_parent().get_parent().isDied()
		
	
func stopMyAnimation(): #Stop the animation and restart the zombie time.
	index = get_parent().get_parent().get_parent().getIndexFromNode(self.get_parent())
	print("Head Thrown ", index)
	get_parent().get_parent().get_parent().zombieStart(index)



func _on_zombieHatHeadThrown_pressed():
	index = get_parent().get_parent().get_parent().getIndexFromNode(self.get_parent())
	print("Zombie Head Clicked ", index)
	if (get_parent().get_parent().get_parent().get_node("mouse").get_node("animations").get_node("anim").get_current_animation() != "breaking"):
		if(get_parent().get_parent().get_parent().zombieData[index].zombieFadeStart == 0):
			get_parent().get_parent().get_parent().zombieFadeStart(index)
			get_parent().get_parent().get_parent().playerScore += 1
