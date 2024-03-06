@tool
class_name DialogueEventNode
extends DialogueNode

signal event_name_changed(name: StringName)

func _ready():
    super._ready()
    resource = DialogueEventNodeResource.new()
    $EventName.text_changed.connect(update_resource)

func set_resource(resource: DialogueEventNodeResource):
    self.resource = resource
    $EventName.text = resource.event_name

func update_resource(text: String):
    resource.event_name = text