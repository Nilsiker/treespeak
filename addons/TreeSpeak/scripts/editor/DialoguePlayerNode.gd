@tool
class_name DialoguePlayerNode
extends DialogueNode

signal slot_removed(name: StringName, index: int)

@onready var dialogue_option = preload ("res://addons/TreeSpeak/components/dialogue_option.tscn")

var option_index = 0

func _ready():
	super._ready()
	resource = DialoguePlayerNodeResource.new()
	resource.options.push_back("")

func set_resource(resource):
	self.resource = resource
	set_options(resource.options)

func set_options(options: Array[String]):
	for option in options:
		if option == options[0]:
			get_child(0).set_text(option)
		else:
			var node = dialogue_option.instantiate()
			var index = get_children().size() - 2

			add_child(node)
			move_child(node, index)
			option_index += 1

			set_slot_enabled_right(option_index, true)
			node.text_updated.connect(_on_option_text_updated)
			node.removed_clicked.connect(_on_removed_clicked)

			node.set_text(option)

func add_option():
	var node = dialogue_option.instantiate()
	var index = get_children().size() - 2
	print(index)

	add_child(node)
	move_child(node, index)
	option_index += 1

	set_slot_enabled_right(option_index, true)
	resource.options.insert(option_index, "")

	node.text_updated.connect(_on_option_text_updated)
	node.removed_clicked.connect(_on_removed_clicked)

func _on_removed_clicked(index: int):
	slot_removed.emit(name, index)
	set_slot_enabled_right(option_index, false)
	resource.options.remove_at(option_index)

	get_child(index).queue_free()
	option_index -= 1

func _on_option_text_updated(index: int, text: String):
	resource.options[index] = text
