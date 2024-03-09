@tool 
extends Control

func _ready():
	pass


func _get_drag_data(at_position):
	print(at_position)

func _can_drop_data(at_position, data):
	print(data)

func _drop_data(at_position, data):
	print("dropped")