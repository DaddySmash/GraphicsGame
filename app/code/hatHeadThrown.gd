
#extends AnimatedSprite
extends TextureButton
#animations
var index = null

func getDamaged():
	index = get_parent().get_parent().get_parent().getIndexFromNode(self.get_parent())
	print("Get Damaged ", index)
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

