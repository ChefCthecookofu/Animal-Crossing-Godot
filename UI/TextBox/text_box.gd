extends Control

@export var speaker : String = "Scoot"
@export var content : String = "Wow, you just keep turning up today. It's like you're only playing offense, zip zoom."

@onready var content_label = $Bubble/ContentText
@onready var name_label = $Bubble/NameText

func _ready() -> void:
	content_label.text = content
	name_label.text = speaker
