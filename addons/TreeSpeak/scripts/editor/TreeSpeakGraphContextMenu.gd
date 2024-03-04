@tool
class_name TreeSpeakGraphContextMenu
extends PopupMenu

enum PopupOption {
	NewPlayerNode,
	NewNPCNode,
	NewEventNode
}

signal autolink_requested(from: StringName, port: int, to: StringName)

@onready var player_node = preload ("res://addons/TreeSpeak/components/dialogue_player_node.tscn")
@onready var npc_node = preload ("res://addons/TreeSpeak/components/dialogue_npc_node.tscn")
@onready var event_node = preload ("res://addons/TreeSpeak/components/dialogue_event_node.tscn")

var autolink_from: StringName
var autolink_port: int

func open(position: Vector2, from: StringName="", port: int =- 1):
	visible = true
	self.position = position

	autolink_from = from
	autolink_port = port

func create_player_node(position: Vector2) -> Node:
	var node: Node = player_node.instantiate()
	add_sibling(node)
	node.position_offset = position

	if autolink_from:
		autolink_requested.emit(autolink_from, autolink_port, node.name)
		autolink_from = ""

	return node

func create_npc_node(position: Vector2) -> Node:
	var node: Node = npc_node.instantiate()
	add_sibling(node)
	node.position_offset = position

	if autolink_from:
		autolink_requested.emit(autolink_from, autolink_port, node.name)
		autolink_from = ""

	return node

func create_event_node(position: Vector2) -> Node:
	var node: Node = event_node.instantiate()
	add_sibling(node)
	node.position_offset = position

	if autolink_from:
		autolink_requested.emit(autolink_from, autolink_port, node.name)
		autolink_from = ""

	return node
