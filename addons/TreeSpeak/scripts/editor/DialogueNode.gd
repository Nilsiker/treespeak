@tool
class_name DialogueNode
extends GraphNode

var resource: DialogueNodeResource

signal deleted(name: StringName)
signal position_updated(name:StringName, position: Vector2)

func set_resource(resource):
    print("must override set_resource function in base class DialogueNode")

func _ready():
    position_offset_changed.connect(_on_position_offset_changed)

func _on_position_offset_changed():
    position_updated.emit(name, position_offset)

func delete():
    deleted.emit(name)
    queue_free()