@tool
extends EditorPlugin

var icon = preload ("res://addons/TreeSpeak/solid-leaf.svg")
var main_panel = preload ("res://addons/TreeSpeak/components/treespeak.tscn")

# A class member to hold the main_panel during the plugin life cycle.
var main_panel_instance

func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the main_panel scene and instantiate it.
	main_panel_instance = main_panel.instantiate()
	_make_visible(false)
	
	add_autoload_singleton("DialogueManager", "res://addons/TreeSpeak/scripts/DialogueManager.gd")
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)

func _exit_tree():
	remove_autoload_singleton("DialogueManager")
	if main_panel_instance:
		main_panel_instance.queue_free()

func _get_plugin_name() -> String: return "TreeSpeak"

func _get_plugin_icon(): return icon

func _has_main_screen() -> bool: return true

func _make_visible(next_visible: bool) -> void:
	if next_visible:
		reload()
	if main_panel_instance:
		main_panel_instance.visible = next_visible

func reload():
	if main_panel_instance:
		main_panel_instance.queue_free()
		
	main_panel_instance = main_panel.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
