extends Node2D

signal answer_submitted
@onready var line_edit = $LineEdit

func _ready() -> void:
	line_edit.text_submitted.connect(_on_LineEdit_Text_Entered)
	
func _on_LineEdit_Text_Entered(answer: String) -> void:
	emit_signal("answer_submitted", answer)
