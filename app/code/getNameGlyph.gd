extends TextureButton

func _ready():
	pass

func _on_r_pressed():
	if get_node("/root/global").isInputEnabled():
		print("THIS GLYPH WAS PRESSED! " + get_child(0).get_child(0).get_text())
		get_node("/root/global").disableInputForXMs(200)
		
		if get_node("/root/global").currentName.length() > 2:
			get_node("/root/global").updateHighScorePart2()
		else:
			get_node("/root/global").currentName = get_node("/root/global").currentName + get_child(0).get_child(0).get_text()
			print("Updated: " + get_node("/root/global").currentName)
			
			if get_node("/root/global").currentName.length() > 2:
				get_node("/root/global").updateHighScorePart2()