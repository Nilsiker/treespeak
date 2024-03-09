class_name DialogueUI
extends Control

@export var player_options: DialogueOptionsList
@export var npc_name: Label
@export var npc_line: Label
@export var variables: Dictionary

func _ready():
	DialogueManager.started.connect(_on_dialogue_manager_started)
	DialogueManager.updated.connect(_on_dialogue_manager_updated)
	DialogueManager.ended.connect(func(): visible=false)
	player_options.item_selected.connect(DialogueManager.transition)

	# remove debug vvvv
	var dialogue_graph: DialogueGraphResource = load("res://dialogues/variable_test.tres")
	DialogueManager.start_dialogue(dialogue_graph, {
		"npc_name": dialogue_graph.npc_name,
		"coins": 101,
		"player_name": "Nilsiker"
	})

func _on_dialogue_manager_started(resource, variables):
	npc_name.text = resource.npc_name
	self.variables = variables

func _on_dialogue_manager_updated(resource):
	if resource is DialogueNpcNodeResource:
		var line = resource.line
		for key in variables.keys():
			var enclosed_key = "{" + key + "}"
			line = line.replace(enclosed_key, str(variables[key]))
		npc_line.text = line

	elif resource is DialoguePlayerNodeResource:
		player_options.set_options(resource.options)
	player_options.visible = resource is DialoguePlayerNodeResource

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		DialogueManager.skip()
