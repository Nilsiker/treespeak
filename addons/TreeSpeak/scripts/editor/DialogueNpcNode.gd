@tool
class_name DialogueNpcNode
extends DialogueNode

var line: String 
var next: DialogueNodeResource


func set_line(): 
    self.line = $TextEditLine.text


func to_res() -> DialogueNpcNodeResource:
    var res = DialogueNpcNodeResource.new()
    res.line = line
    return res


func from_res(res: DialogueNpcNodeResource):
    line = res.line

