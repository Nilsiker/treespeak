@tool
class_name DialogueNpcNode
extends DialogueNode


func set_resource(resource):
    self.resource = resource
    $Line.text = resource.line


func _ready():
    super._ready()
    resource = DialogueNpcNodeResource.new()
    $Line.text_changed.connect(_on_textedit_text_changed)

func _on_textedit_text_changed():
    resource.line = $Line.text