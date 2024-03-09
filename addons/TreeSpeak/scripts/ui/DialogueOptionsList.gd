class_name DialogueOptionsList
extends ItemList


func set_options(options: Array[String]):
	print(options)
	clear()
	for option in options:
		add_item(option)
	