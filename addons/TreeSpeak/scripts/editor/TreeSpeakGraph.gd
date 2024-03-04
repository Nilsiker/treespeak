@tool
class_name TreeSpeakGraph
extends GraphEdit

enum PopupOption {
	NewPlayerNode,
	NewNPCNode,
	NewEventNode
}

@export var popup: TreeSpeakGraphContextMenu

@onready var start: GraphNode = $NodeStart
@onready var end: GraphNode = $NodeEnd

func _ready():
	connection_to_empty.connect(_on_connection_to_empty)
	connection_request.connect(connect_node)
	disconnection_request.connect(disconnect_node)

	popup.id_pressed.connect(_on_popup_id_pressed)
	popup.autolink_requested.connect(_on_autolink_request)

func to_json() -> String:
	var node_data: Array = get_children().filter(func(c): return c.has_method(&"to_res")).map(func(child):
		print(child)
		return {
			"name": child.name,
			"data": child.to_res()
		})


	var obj = {
		"nodes": node_data,
		"connections": get_connection_list()
	}

	return JSON.stringify(obj)

func _gui_input(event):
	if Input.is_key_label_pressed(KEY_DELETE):
		var selected: Array[Node]
		for child in get_children():
			var node = child as DialogueNode
			if node and node.selected:
				%TreeSpeakDeleteNodesDialog.visible = true
				return

	elif event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_RIGHT:
		popup.open(get_global_mouse_position() + Vector2.DOWN * 30)

func _delete_nodes_confirmed():
	var selected: Array[Node]
	for child in get_children():
		var node = child as DialogueNode
		if node and node.selected: node.delete()

func _on_connection_to_empty(from, from_port, release_position):
	popup.open(get_global_mouse_position() + Vector2.DOWN * 30, from, from_port)

func _on_popup_id_pressed(option: PopupOption):
	var node
	var graph_mouse_pos = get_graph_pos(get_local_mouse_position())
	match option:
		PopupOption.NewPlayerNode:
			node = popup.create_player_node(graph_mouse_pos)
			node.slot_removed.connect(_on_slot_removed)
		PopupOption.NewNPCNode:
			node = popup.create_npc_node(graph_mouse_pos)
		PopupOption.NewEventNode:
			node = popup.create_event_node(graph_mouse_pos)
	node.deleted.connect(_on_node_deleted)

func _on_autolink_request(from: StringName, port: int, to: StringName):
	connect_node(from, port, to, 0)
	
func _on_node_deleted(node: StringName):
	print("node removed: ", node)
	for connection in get_connection_list():
		print(connection)
		if connection.from_node == node or connection.to_node == node:
			disconnect_node(connection.from_node, connection.from_port, connection.to_node, connection.to_port)

func _on_slot_removed(node: StringName, port_index: int):
	print("slot ", port_index, " removed on ", node)
	for conn in get_connection_list():
		if conn.from == node and conn.from_port == port_index:
			disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
		elif conn.to == node and conn.to_port == port_index:
			disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)


func get_graph_pos(position: Vector2) -> Vector2:
	return (position + scroll_offset) / zoom