@tool
class_name TreeSpeakFileDialog
extends FileDialog

func _ready():
	confirmed.connect(_on_confirmed)


func prompt_save():
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	visible = true


func prompt_load():
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	visible = true


func _on_confirmed():
	match file_mode:
		FILE_MODE_SAVE_FILE:
			var resource = %TreeSpeakGraph.resource.duplicate()	# NOTE duplicate to not keep editing a saved file resource (maybe we want that...?)
			# resource.take_over_path(current_path) 
			var result = ResourceSaver.save(resource, current_path)
			print(result == OK)
		FILE_MODE_OPEN_FILE:
			var resource = ResourceLoader.load(current_path, "DialogueGraphResource")
			%TreeSpeakGraph.load_res(resource)