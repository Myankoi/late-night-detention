extends Control

func _ready():
	$AnimatedSprite2D.play("menu")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://cutscene/cutscene1.tscn")
	

func _on_option_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
