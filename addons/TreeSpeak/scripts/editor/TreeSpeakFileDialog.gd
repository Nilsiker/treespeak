@tool
class_name TreeSpeakFileDialog
extends FileDialog

func _ready():
	confirmed.connect(_on_confirmed)


func prompt_save():
	print("prompt save")
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	visible = true
	show()

func _on_confirmed():
	match file_mode:
		FILE_MODE_SAVE_FILE:
			var file = FileAccess.open(current_path, FileAccess.WRITE)
			var json = %TreespeakerGraph.to_json()
			file.store_string(json)
			