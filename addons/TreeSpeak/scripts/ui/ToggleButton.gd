extends Button

@export var on_text: String
@export var off_text: String


# Called when the node enters the scene tree for the first time.
func _ready():
	toggled.connect(func(on): text = on_text if on else off_text)
	text = off_text

