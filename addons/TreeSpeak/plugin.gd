@tool
extends EditorPlugin

# A class member to hold the main_panel during the plugin life cycle.
var main_panel_instance

func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the main_panel scene and instantiate it.
	main_panel_instance = preload ("res://addons/TreeSpeak/components/treespeak.tscn").instantiate()
	_make_visible(false)

	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)

func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()

func _get_plugin_name() -> String:
	return "TreeSpeak"

func _get_plugin_icon():
	return preload("res://addons/TreeSpeak/solid-leaf.svg")


func _has_main_screen() -> bool:
	return true

func _make_visible(next_visible: bool) -> void:
	if next_visible:
		reload()
	if main_panel_instance:
		main_panel_instance.visible = next_visible

func update_size():
	var size = get_editor_interface().get_editor_main_screen().size
	main_panel_instance.size = size
	print("dialogue size: ", size)

func reload():
	print("reloaded")
	if main_panel_instance:
		main_panel_instance.queue_free()
		
	main_panel_instance = preload ("res://addons/TreeSpeak/components/treespeak.tscn").instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)