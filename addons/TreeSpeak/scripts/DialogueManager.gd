extends Node

signal updated(resource: DialogueNodeResource) # TODO maybe think of a better name here
signal ended()

@export var graph: DialogueGraphResource # TODO remove export
@export var current: StringName

func start_dialogue(graph: DialogueGraphResource):
	self.graph = graph
	var start_connection = graph.connections.filter(func(conn): return conn.from_node == &"START").front()
	if not start_connection: 
		print("No START connection found. Ending dialogue...")
		end_dialogue()
		return

	current = start_connection.to_node
	var current_resource = graph.nodes.get(current)
	updated.emit(current_resource)

func transition(port_index: int):
	var matching_connection = graph.connections.filter(func(conn): return conn.from_node == current and conn.from_port == port_index)
	if matching_connection.is_empty():
		print("No connection found from node ", current, " on port ", port_index, ". Ending dialogue...")
		end_dialogue()
		return
		
	current = matching_connection.front().to_node
	print(current)
	var current_resource = graph.nodes.get(current)
	if current_resource is DialogueEventNodeResource:
		print("TODO implement event node firing")
		transition(0)
	else:
		updated.emit(current_resource)

func skip():	# TODO maybe this is too exposed...?
	if not graph: return
	var current_resource = graph.nodes.get(current)
	if current_resource is DialogueNpcNodeResource:
		transition(0)

func end_dialogue():
	graph = null
	current = &""
	ended.emit()
