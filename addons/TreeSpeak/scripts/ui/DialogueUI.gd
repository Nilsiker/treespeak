class_name DialogueUI
extends Control

@export var options: DialogueOptionsList
@export var line: Label
@export var dialogue: DialogueGraphResource

var current_node: StringName = "START"


func _ready():
	options.item_selected.connect(_on_dialogue_option_selected)
	start_dialogue(dialogue)
	print(dialogue.connections)


func start_dialogue(dialogue: DialogueGraphResource):
	self.dialogue = dialogue
	var start_connection = dialogue.connections.filter(func(conn): return conn.from_node == &"START")[0]
	current_node = start_connection.to_node

	visible = true
	update_view()


func _on_dialogue_option_selected(index: int):	# TODO break out transition logic to own function
	var next = get_next_node(index)
	print(current_node, " transitioned into ", next, " through port ", index)
	current_node = next

	if current_node == &"END":
		visible = false
	else:
		update_view()
		

func update_view():
	var resource = dialogue.nodes[current_node]
	print(resource)
	if resource is DialogueNpcNodeResource:
		line.text = resource.line
	elif resource is DialoguePlayerNodeResource:
		options.set_options(resource.options)
	elif resource is DialogueEventNodeResource:
		print("TODO fire ", resource.event_name, " event")
		_on_dialogue_option_selected(0)

	options.visible = resource is DialoguePlayerNodeResource




func get_next_node(index: int = 0) -> StringName:
	print("getting node from ", current_node, " through port ", index)
	var connection = dialogue.connections.filter(func(conn): return conn.from_node == current_node and conn.from_port == index)[0]
	var to_node = connection.to_node
	print("port ", index, " connects to node ", to_node)
	return to_node



func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var node = dialogue.nodes.get(current_node)
		if node is DialogueNpcNodeResource:
			_on_dialogue_option_selected(0)
