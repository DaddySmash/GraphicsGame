extends TextureButton

func _ready():
	pass

func _on_r_pressed():
	print("THIS GLYPH WAS PRESSED! " + get_child(0).get_child(0).get_text())
	print("Updated: " + get_node("/root/global").currentName)
	
	if get_node("/root/global").currentName.length() > 2:
		get_node("/root/global").updateHighScorePart2()
	
	get_node("/root/global").currentName = get_node("/root/global").currentName + get_child(0).get_child(0).get_text()
	print("Updated: " + get_node("/root/global").currentName)
	
	if get_node("/root/global").currentName.length() > 2:
		get_node("/root/global").updateHighScorePart2()