extends Area2D

var entered = false
@onready var animationPlayer: AnimationPlayer = get_node("../CanvasLayer/AnimationPlayer")
@onready var mba_kunti_scene = preload("res://scene/hantu.tscn")

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is CharacterBody2D: # Pastikan yang masuk adalah player
		entered = true

func _on_body_exited(body: PhysicsBody2D) -> void:
	if body is CharacterBody2D:
		entered = false

func _process(delta: float) -> void:
	if entered && Global.udah_dijumpscare == true:
		Global.udah_dijumpscare = true
		if animationPlayer != null:
			animationPlayer.current_animation = "new_animation"
			
func _on_animation_player_animation_finished():
	if mba_kunti_scene != null:
		var mba_kunti_instance = mba_kunti_scene.instantiate()
		get_tree().get_root().add_child(mba_kunti_instance) 
		var player = get_tree().get_first_node_in_group("player")
		if player:
			mba_kunti_instance.global_position = player.global_position + Vector2(0, -50) # Contoh: sedikit di atas player
			if mba_kunti_instance.has_method("start_chase"):
				mba_kunti_instance.start_chase(player) # Memberikan player sebagai target
			else:
				print("ERROR: Mba Kunti tidak memiliki fungsi 'start_chase()'.")
		else:
			print("ERROR: Player tidak ditemukan di grup 'player'.")
	else:
		print("ERROR: Scene Mba Kunti tidak berhasil dimuat. Periksa jalurnya.")
	# --- AKHIR TAMBAHAN BARU --
