@tool
extends Control

@onready var graph = $TreeSpeakGraph

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func debug_print():
	print("=====TreeSpeak Debug Print======\n")
	print("nodes: ", graph.resource.nodes)
	print("\n================================\n")
