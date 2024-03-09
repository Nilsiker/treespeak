extends Node


signal started(resource: DialogueGraphResource, variables: Dictionary)
signal updated(resource: DialogueNodeResource)
signal ended()

var graph: DialogueGraphResource # TODO remove export
var current: StringName

func start_dialogue(graph: DialogueGraphResource, variables: Dictionary):
	self.graph = graph
	if not graph.connections:
		push_error(graph.resource_path, ": No connections found in graph. Ending dialogue...")
		end_dialogue()
		return

	var start_connection = graph.connections.filter(func(conn): return conn.from_node == &"START").front()
	if not start_connection: 
		push_error("No START connection found. Ending dialogue...")
		end_dialogue()
		return

	current = start_connection.to_node
	var current_node = graph.nodes.get(current)
	started.emit(graph, variables)
	updated.emit(current_node.data)

func transition(port_index: int):
	var matching_connection = graph.connections.filter(func(conn): return conn.from_node == current and conn.from_port == port_index)
	if matching_connection.is_empty():
		print("No connection found from node ", current, " on port ", port_index, ". Ending dialogue...")
		end_dialogue()
		return
		
	current = matching_connection.front().to_node
	var current_node = graph.nodes.get(current)
	if current_node is DialogueEventNodeResource:
		print("TODO implement event node firing")
		transition(0)
	else:
		updated.emit(current_node.data)

func skip():	# TODO maybe this is too exposed...?
	if not graph: return
	var current_node = graph.nodes.get(current)
	if current_node.data is DialogueNpcNodeResource:
		transition(0)

func end_dialogue():
	graph = null
	current = &""
	ended.emit()
