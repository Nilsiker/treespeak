extends ScrollContainer

@onready var text_node = $Margins/Label

func clear():
	text_node.text = ""

func add_entry(text: String):
	text_node += "\n\n" + text

func set_visible(visible):
	self.visible = visible
