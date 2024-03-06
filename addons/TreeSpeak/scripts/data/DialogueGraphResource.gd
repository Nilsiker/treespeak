@tool
class_name DialogueGraphResource
extends Resource


@export var dialogue_id: String
@export var npc_name: String
@export var npc_portrait: Texture2D

@export_category("DO NOT MODIFY")
@export var nodes: Dictionary
@export var positions: Dictionary
@export var connections: Array[Dictionary]

func add_node(node: DialogueNode):
    nodes[node.name] = node.resource
    positions[node.name] = node.position_offset

func remove_node(node: StringName):
    nodes.erase(node)
    positions.erase(node)

func update_position(name: StringName, position: Vector2):
    positions[name] = position
