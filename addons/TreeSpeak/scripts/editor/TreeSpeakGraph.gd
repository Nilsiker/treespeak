@tool
class_name TreeSpeakGraph
extends GraphEdit

enum PopupOption {
	NPCNode,
	PlayerNode,
	EventNode
}

signal graph_loaded(graph)

@export var popup: TreeSpeakGraphContextMenu
@export var resource: DialogueGraphResource

@onready var player_node = preload ("res://addons/TreeSpeak/components/dialogue_player_node.tscn")
@onready var npc_node = preload ("res://addons/TreeSpeak/components/dialogue_npc_node.tscn")
@onready var event_node = preload ("res://addons/TreeSpeak/components/dialogue_event_node.tscn")
@onready var start: DialogueStart = $START

var _autolink_data = {}

func _ready():
	connection_to_empty.connect(_on_connection_to_empty)
	connection_request.connect(_on_connection_request)
	disconnection_request.connect(_on_disconnection_request)
	
	popup.id_pressed.connect(_on_popup_id_pressed)
	popup.close_requested.connect(_on_popup_close_requested)

	start.get_node("NpcName").text_changed.connect(func(new_name): resource.npc_name=new_name)
	start.visible = resource != null


#region PRIVATE OVERRIDES

func _gui_input(event):
	if Input.is_key_label_pressed(KEY_DELETE):
		var selected: Array[Node]
		for child in get_children():
			var node = child as DialogueNode
			if node and node.selected:
				print(event)
				%TreeSpeakDeleteNodesDialog.visible = true
				return

	elif event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_RIGHT:
		popup.open(get_global_mouse_position() + Vector2.DOWN * 30)

func _can_drop_data(at_position, data):
	if data.type == "files" and data.files:
		var split: Array = data.files[0].split(".")
		return split.back() == "tres"
	return false

func _drop_data(at_position, data):
	var res = ResourceLoader.load(data.files[0])
	if res == resource:
		push_warning(name, ": cannot load same file twice")
		return
	_clear_nodes() # FIXME this doesn't clear the nodes in time for the loaded nodes to enter, which causes issues with naming
	load_res.call_deferred(res)

#endregion

#region PUBLIC METHODS

func load_res(res: DialogueGraphResource):
	resource = res
	print(res.resource_path)
	for node in res.nodes.values():
		_create_node_from_dictionary(node)

	for conn in res.connections:
		connect_node(conn.from_node, conn.from_port, conn.to_node, conn.to_port)

	graph_loaded.emit(res)
	start.visible = resource != null
	start.get_node("NpcName").text = resource.npc_name
	EditorInterface.inspect_object(resource)


#endregion

#region SIGNAL HANDLERS

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	connect_node(from_node, from_port, to_node, to_port)
	_update_connections()

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	disconnect_node(from_node, from_port, to_node, to_port)
	_update_connections()

func _delete_nodes_confirmed():
	var selected: Array[Node]
	for child in get_children():
		var node = child as DialogueNode
		if node and node.selected:
			node.delete()

func _on_connection_to_empty(from, from_port, release_position):
	_autolink_data = {"from": from, "from_port": from_port}
	popup.open(get_global_mouse_position() + Vector2.DOWN * 30)

func _on_popup_close_requested():
	print("close request")	 # TODO this is also run when pressing an option - I need to handle the autolink cancellation differently! Anti-logic?
	_autolink_data = null

func _on_popup_id_pressed(option: PopupOption):
	var graph_mouse_pos = _get_graph_pos(get_local_mouse_position())
	match option:
		PopupOption.NPCNode:
			_create_node_from_type(DialogueNpcNodeResource, graph_mouse_pos)
		PopupOption.PlayerNode:
			_create_node_from_type(DialoguePlayerNodeResource, graph_mouse_pos)
		PopupOption.EventNode:
			_create_node_from_type(DialogueEventNodeResource, graph_mouse_pos)
	
func _on_node_deleted(node: StringName):
	print("node removed: ", node)
	resource.remove_node(node)
	for connection in get_connection_list():
		if connection.from_node == node or connection.to_node == node:
			_on_disconnection_request(connection.from_node, connection.from_port, connection.to_node, connection.to_port)

func _on_node_position_updated(name: StringName, position: Vector2):
	resource.update_position(name, position)

func _on_node_size_updated(name: StringName, size: Vector2):
	resource.update_size(name, size)

func _on_npc_name_updated(name: String):
	resource.npc_name = name

func _on_slot_removed(node: StringName, port_index: int):
	print("removed slot ", port_index, " on ", node)
	for conn in get_connection_list():
		if conn.from == node and conn.from_port == port_index:
			_on_disconnection_request(conn.from, conn.from_port, conn.to, conn.to_port)
		elif conn.to == node and conn.to_port == port_index:
			_on_disconnection_request(conn.from, conn.from_port, conn.to, conn.to_port)

#endregion

#region PRIVATE METHODS

func _get_graph_pos(position: Vector2) -> Vector2:
	return (position + scroll_offset) / zoom

func _update_connections():
	resource.connections = get_connection_list()

func _create_node_from_type(node_type, position: Vector2):
	var node = {
		"position": position,
		"size": Vector2.ZERO,
		"data": node_type.new()
	}
	var created_node = _create_node_from_dictionary(node)
	resource.add_node(created_node)
	if _autolink_data:
		_on_connection_request(_autolink_data.from, _autolink_data.from_port, created_node.name, 0)
		_autolink_data = null

func _create_node_from_dictionary(node: Dictionary) -> DialogueNode:
	var data = node.data
	var created_node: DialogueNode
	
	if data is DialoguePlayerNodeResource:
		created_node = player_node.instantiate()
		created_node.slot_removed.connect(_on_slot_removed)
	elif data is DialogueNpcNodeResource:
		created_node = npc_node.instantiate()
	elif data is DialogueEventNodeResource:
		created_node = event_node.instantiate()
	
	add_child(created_node)

	created_node.set_resource(data)
	created_node.position_offset = node.position
	if node.size:
		created_node.size = node.size
	created_node.deleted.connect(_on_node_deleted)
	created_node.position_updated.connect(_on_node_position_updated)
	created_node.size_updated.connect(_on_node_size_updated)
	return created_node

func _clear_nodes():
	clear_connections()
	for node in get_children().filter(func(c): return c is DialogueNode):
		node.queue_free()

#endregion
