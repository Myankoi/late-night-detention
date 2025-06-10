extends Area2D

@export var target_scene_path: String = "res://scene/uks.tscn"
@export var destination_door_id: String = "class32darilorong"

var entered = false

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is CharacterBody2D: # Pastikan yang masuk adalah player
		entered = true

func _on_body_exited(body: PhysicsBody2D) -> void:
	if body is CharacterBody2D:
		entered = false

#func _process(delta: float) -> void:
	#if entered:
		#Global.last_door_id = destination_door_id
		#get_tree().change_scene_to_file(target_scene_path)
