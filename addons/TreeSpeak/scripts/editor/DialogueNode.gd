@tool
class_name DialogueNode
extends GraphNode

signal deleted(name: StringName)

func delete():
    deleted.emit(name)
    queue_free()