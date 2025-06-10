extends Node2D

@onready var player = $player

func _on_ready() -> void: 
	if !Global.satu:
		player.can_move = false
		player.velocity = Vector2.ZERO 
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/1.dialogue"), "start")
		await DialogueManager.dialogue_ended
		player.can_move = true
		Global.satu = true
