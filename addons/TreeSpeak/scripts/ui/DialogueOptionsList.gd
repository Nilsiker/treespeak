class_name DialogueOptionsList
extends ItemList


func set_options(options: Array[String]):
	print("clearing options")
	clear()
	for option in options:
		add_item(option)