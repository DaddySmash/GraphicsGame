
#extends AnimatedSprite
extends TextureButton

var index = null

func getDamaged():
	index = get_parent().get_parent().get_parent().getIndexFromNode(self.get_parent())
	print("Get Damaged ", index)
	
func stopMyAnimation(): #Stop the animation and restart the zombie time.
	index = get_parent().get_parent().get_parent().getIndexFromNode(self.get_parent())
	print("Head Thrown ", index)
	get_parent().get_parent().get_parent().zombieStart(index)

