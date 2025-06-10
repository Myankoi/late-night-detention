extends CharacterBody2D

@export var speed := 80.0
@export var walkSpeed := 80.0
@export var sprintSpeed := 100.0
@export var maxStamina := 100.0
@export var stamina := 100.0
@export var staminaDrainRate := 40.0
@export var staminaRegenRate := 10.0
@export var sprint_activation_threshold := 20.0
@export var sprint_regen_delay := 0.5
@export var health : int = Global.health
var can_move = true

var last_direction := Vector2.DOWN

@onready var sprite := $AnimatedSprite2D
@onready var actionable_finder: Area2D = $Direction/actionablefinder
@export var inv: Inv

@export var walk_animation_speed_scale := 1.0 # Kecepatan normal animasi jalan
@export var sprint_animation_speed_scale := 1.5

var is_sprinting := false
var time_since_last_sprint_end := 0.0

@onready var door_spawn_points: Node2D = get_node_or_null("../DoorSpawnPoints")
func _ready() -> void:
	if Global.last_door_id != "":
		if door_spawn_points:
			# Cari anak dari DoorSpawnPoints yang namanya sesuai dengan last_door_id
			var spawn_point = door_spawn_points.get_node(Global.last_door_id)
			if spawn_point:
				global_position = spawn_point.global_position # Pindahkan player ke posisi itu
		else:
			print("WARNING: Node 'DoorSpawnPoints' not found in the current scene!")
		Global.last_door_id = "" # Reset ID setelah digunakan

		
func _physics_process(delta):
	if Global.health <= 0:
		get_tree().change_scene_to_file("res://scene/game_over.tscn")
		Global.health = 5
		return
		
	var direction = Vector2.ZERO
	$AnimatedSprite2D.z_index = int(global_position.y)

	var wants_to_sprint = Input.is_action_pressed("shift")
	$CanvasLayer/Label2.text = "Health: " + str(Global.health)
	if wants_to_sprint and stamina > sprint_activation_threshold:

		# Jika ingin sprint dan stamina di atas ambang batas, SETELAH regen delay
		# Ini untuk memulai sprint baru atau melanjutkan jika sudah sprint tapi stamina turun
		speed = sprintSpeed
		stamina -= staminaDrainRate * delta
		stamina = max(0.0, stamina)
		is_sprinting = true # Set status sprinting
		time_since_last_sprint_end = 0.0 # Reset delay jika sedang sprint
		sprite.speed_scale = sprint_animation_speed_scale

	elif wants_to_sprint and stamina <= 0.01: # Jika shift masih ditekan tapi stamina habis
		speed = walkSpeed # Paksa kembali ke walk speed
		is_sprinting = false # Set status tidak sprinting
		# Stamina TIDAK meregenerasi di sini. Regenerasi akan dimulai hanya jika 'shift' dilepas
		time_since_last_sprint_end = 0.0 # Reset delay, karena dia masih berusaha sprint tapi gak bisa
		sprite.speed_scale = walk_animation_speed_scale
		
	else: # Jika tombol sprint dilepas (wants_to_sprint == false)
		speed = walkSpeed
		is_sprinting = false # Set status tidak sprinting
		sprite.speed_scale = walk_animation_speed_scale
		# Cek delay sebelum regenerasi aktif penuh
		if time_since_last_sprint_end < sprint_regen_delay:
			time_since_last_sprint_end += delta
		else:
			# Mulai regenerasi hanya jika stamina belum penuh
			if stamina < maxStamina:
				stamina += staminaRegenRate * delta
				stamina = min(maxStamina, stamina)

	if can_move:
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
			sprite.play("kanan")
			sprite.flip_h = false
		elif Input.is_action_pressed("ui_left"):
			direction.x -= 1
			sprite.play("kiri")
			sprite.flip_h = false
		elif Input.is_action_pressed("ui_down"):
			direction.y += 1
			sprite.play("jalan depan")
		elif Input.is_action_pressed("ui_up"):
			direction.y -= 1
			sprite.play("jalan belakang")
		else:
			match last_direction:
				Vector2.RIGHT:
					sprite.play("idlekanan")
					sprite.flip_h = true
				Vector2.LEFT:
					sprite.play("idlekiri")
					sprite.flip_h = false
				Vector2.DOWN:
					sprite.play("idle")
				Vector2.UP:
					sprite.play("idlebelakang")

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		if abs(direction.x) > abs(direction.y):
			last_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
		else:
			last_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP
	
	$Label.text = "Stamina: " + str(round(stamina)) + "/" + str(maxStamina)
		
	velocity = direction * speed
	move_and_slide()
