class_name DialogueUI
extends Control

@export var options: DialogueOptionsList
@export var line: Label


func _ready():
	DialogueManager.updated.connect(_on_dialogue_manager_updated)
	DialogueManager.ended.connect(func(): visible = false)
	options.item_selected.connect(DialogueManager.transition)

	# remove debug vvvv
	DialogueManager.start_dialogue(load("res://dialogues/bimpis.tres"))

		

func _on_dialogue_manager_updated(resource):
	if resource is DialogueNpcNodeResource:
		print("Npc node")
		line.text = resource.line
	elif resource is DialoguePlayerNodeResource:
		print("Player node")
		options.set_options(resource.options)
	options.visible = resource is DialoguePlayerNodeResource


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		DialogueManager.skip()
