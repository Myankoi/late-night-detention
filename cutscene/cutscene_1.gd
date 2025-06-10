extends Control

var footo_array: Array[Texture2D] = [
	preload("res://cutscene/start1.jpeg"),
	preload("res://cutscene/start2.jpeg"),
	preload("res://cutscene/start3.jpeg"),
	preload("res://cutscene/start4.jpeg"),
	preload("res://cutscene/start5.jpeg"),
	preload("res://cutscene/start6.jpeg"),
	preload("res://cutscene/start7.jpeg"),
	preload("res://cutscene/start8.jpeg"),
	preload("res://cutscene/start9.jpeg"),
	preload("res://cutscene/start10.jpeg"),
	preload("res://cutscene/start11.jpeg"),
	preload("res://cutscene/start12.jpeg"),
]

var current_index := 0

func _ready():
	$CanvasLayer/TextureRect.texture = footo_array[current_index]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_show_next_image()

func _on_play_pressed() -> void:
	_show_next_image()

func _show_next_image():
	current_index += 1

	if current_index >= footo_array.size():
		get_tree().change_scene_to_file("res://scene/BK.tscn")
	else:
		$CanvasLayer/TextureRect.texture = footo_array[current_index]
