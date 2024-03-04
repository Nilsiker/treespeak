@tool
extends Control


@onready var graph = $TreeSpeakGraph
@onready var file_dialog: TreeSpeakFileDialog = $TreeSpeakFileDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func debug_print():
	print(graph.get_graph())
	