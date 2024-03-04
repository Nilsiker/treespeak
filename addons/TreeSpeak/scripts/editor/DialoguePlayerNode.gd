@tool
class_name DialoguePlayerNode
extends DialogueNode

signal slot_removed(name:StringName, index: int)

@onready var dialogue_option = preload ("res://addons/TreeSpeak/components/dialogue_option.tscn")

var option_index = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_option():
	var node = dialogue_option.instantiate()
	var index = get_children().size() - 2
	print(index)
	add_child(node)
	move_child(node, index)
	option_index += 1

	set_slot_enabled_right(option_index, true)
	node.removed_clicked.connect(remove_slot)

func remove_slot(index: int):
	slot_removed.emit(name, index)
	set_slot_enabled_right(option_index, false)
	get_child(index).queue_free()
	option_index -= 1

func to_json():
	pass