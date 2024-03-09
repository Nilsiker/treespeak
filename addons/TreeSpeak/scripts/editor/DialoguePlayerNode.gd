@tool
class_name DialoguePlayerNode
extends DialogueNode

signal slot_removed(name: StringName, index: int)

@onready var dialogue_option = preload ("res://addons/TreeSpeak/components/dialogue_option.tscn")

var _option_index = 0

func _ready():
	super._ready()
	resource = DialoguePlayerNodeResource.new()
	resource.options.push_back("")

func set_resource(resource):
	self.resource = resource
	_set_options(resource.options)

func _set_options(options: Array[String]):
	for option in options:
		if option == options[0]:
			get_child(0).set_text(option)
		else:
			_add_option(option)

func _on_add_option_pressed():
	_add_option("")


func _add_option(text: String):
	var node = dialogue_option.instantiate()
	var index = get_children().size() - 2

	add_child(node)
	move_child(node, index)
	_option_index += 1

	set_slot_enabled_right(_option_index, true)

	node.text_updated.connect(_on_option_text_updated)
	node.removed_clicked.connect(_on_removed_clicked)
	if text:	
		node.set_text(text)
	else: # if not provided a text param, this is a new option that should be added to the resource
		resource.options.insert(_option_index, "")

func _on_removed_clicked(index: int):
	slot_removed.emit(name, index)
	set_slot_enabled_right(_option_index, false)
	resource.options.remove_at(_option_index)

	get_child(index).queue_free()
	_option_index -= 1

func _on_option_text_updated(index: int, text: String):
	resource.options[index] = text
