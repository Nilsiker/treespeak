@tool
class_name TreeSpeakFileDialog
extends FileDialog

func _ready():
	confirmed.connect(_on_confirmed)


func prompt_save():
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	visible = true


func _on_confirmed():
	match file_mode:
		FILE_MODE_SAVE_FILE:
			var resource = DialogueGraphResource.new()
			var result = ResourceSaver.save(resource, current_path)