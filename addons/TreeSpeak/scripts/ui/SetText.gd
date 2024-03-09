@tool
extends Label

func _ready():
	%TreeSpeakGraph.graph_loaded.connect(_on_graph_loaded)


func _on_graph_loaded(graph: DialogueGraphResource):
	var split: Array = graph.resource_path.split("/")
	var file_split: Array = split.back().split(".")
	text = "Editing " + file_split.front()