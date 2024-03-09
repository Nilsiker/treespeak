@tool
class_name DialogueGraphResource
extends Resource


@export var dialogue_id: String
@export var npc_name: String
@export var npc_portrait: Texture2D

@export_category("DO NOT MODIFY")
@export var nodes: Dictionary
@export var connections: Array[Dictionary]

func add_node(node: DialogueNode):
	print(node)
	nodes[node.name] = {
		"data": node.resource,
		"position": node.position_offset,
		"size": node.custom_minimum_size
	}
	print(nodes)

func remove_node(node: StringName):
	nodes.erase(node)

func update_position(name: StringName, position: Vector2):
	nodes[name].position = position

func update_size(name: StringName, size: Vector2):
	nodes[name].size = size