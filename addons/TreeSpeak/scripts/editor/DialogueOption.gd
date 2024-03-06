@tool
extends PanelContainer

signal removed_clicked(index: int)
signal text_updated(index: int, text: String)

func _ready():
	$HBox/TextEdit.text_changed.connect(_on_textedit_text_changed)

func get_text(): return $HBox/TextEdit.text

func set_text(text: String): $HBox/TextEdit.text = text

func remove():
	removed_clicked.emit(get_index())

func _on_textedit_text_changed():
	text_updated.emit(get_index(), get_text())