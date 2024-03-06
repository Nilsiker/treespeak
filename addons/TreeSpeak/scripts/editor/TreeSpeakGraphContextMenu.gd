@tool
class_name TreeSpeakGraphContextMenu
extends PopupMenu

enum NodeType {
	Player,
	NPC,
	Event
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

func request_create_node(position: Vector2, type: NodeType, name: StringName = "") -> Node:
	var node
	match type:
		NodeType.Player:
			node = player_node.instantiate()
		NodeType.NPC:
			node = npc_node.instantiate()
		NodeType.Event:
			node = event_node.instantiate()

	if name:
		node.name = name
	add_sibling(node, true)
	node.position_offset = position

	if autolink_from:
		autolink_requested.emit(autolink_from, autolink_port, node.name)
		autolink_from = ""

	return node