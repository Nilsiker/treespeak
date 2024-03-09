@tool
extends Control


@onready var graph = $TreeSpeakGraph
@onready var file_dialog: TreeSpeakFileDialog = $TreeSpeakFileDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().gui_embed_subwindows = false
	get_tree().root.files_dropped.connect(_on_files_dropped)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func debug_print():
	print("=====TreeSpeak Debug Print======\n")
	print("nodes: ", graph.resource.nodes)
	print("\n================================\n")



func _on_files_dropped(files: PackedStringArray):
	print(files)
	pass