extends CharacterBody2D

@export var speed: float = 100.0 # Kecepatan Hantu
@export var chase_distance: float = 300.0 # Jarak Hantu mulai mengejar player (opsional jika sudah dipicu start_chase)
@export var stop_distance: float = 50.0 # Jarak Hantu berhenti mendekati player agar tidak terlalu menempel

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var target_player: CharacterBody2D = null # Referensi ke node player yang akan dikejar
var is_chasing: bool = false # Flag untuk mengontrol apakah Hantu sedang mengejar atau tidak

func _ready() -> void:
	if navigation_agent == null:
		print("ERROR: NavigationAgent2D tidak ditemukan sebagai anak Hantu! Pastikan Anda menambahkannya.")
		set_physics_process(false) # Nonaktifkan _physics_process jika tidak ada agent
		return

	# Jangan mencari player di _ready() jika player di-instantiate belakangan
	# atau jika Hantu akan di-instantiate setelah player ada.
	# Referensi player akan diberikan melalui fungsi start_chase().

	navigation_agent.path_desired_distance = 40.0
	navigation_agent.target_desired_distance = stop_distance
	
	# Hantu dimulai dalam mode idle
	animated_sprite.play("front") # Atau "idle" jika ada
	velocity = Vector2.ZERO
	is_chasing = false # Pastikan dimulai tidak mengejar

	print("DEBUG: Hantu siap, menunggu perintah start_chase().")

# --- FUNGSI BARU: start_chase() ---
func start_chase(player_node: CharacterBody2D) -> void:
	if player_node != null and is_instance_valid(player_node):
		target_player = player_node
		is_chasing = true
		print("DEBUG: Hantu menerima perintah untuk memulai pengejaran terhadap player.")
		# Opsional: Mainkan suara teriakan hantu atau semacamnya saat mulai mengejar
	else:
		print("ERROR: start_chase() dipanggil dengan node player yang tidak valid.")

func _physics_process(delta: float) -> void:
	if !is_chasing or target_player == null or navigation_agent == null:
		# Jika tidak dalam mode mengejar, atau tidak ada target/agent, Hantu diam.
		velocity = Vector2.ZERO
		update_animation(Vector2.ZERO) # Pastikan animasi idle
		return

	var current_agent_position = global_position
	var target_player_position = target_player.global_position # Menggunakan target_player yang diberikan via start_chase()

	var distance_to_player = current_agent_position.distance_to(target_player_position)

	# Jika player belum terlalu dekat (agar tidak menempel)
	if distance_to_player > stop_distance:
		navigation_agent.target_position = target_player_position
		
		var next_nav_point = navigation_agent.get_next_path_position()
		var direction = (next_nav_point - current_agent_position).normalized()
		
		velocity = direction * speed
		update_animation(direction)
	else:
		# Player sudah cukup dekat, Hantu berhenti bergerak mendekat
		velocity = Vector2.ZERO
		update_animation(Vector2.ZERO) # Hantu dalam posisi idle

	move_and_slide()

func update_animation(direction: Vector2) -> void:
	if animated_sprite:
		if direction.x > 0.1: # Bergerak ke kanan
			animated_sprite.flip_h = false
			animated_sprite.play("side")
		elif direction.x < -0.1: # Bergerak ke kiri
			animated_sprite.flip_h = true
			animated_sprite.play("side")
		elif direction.y < 0.1: # Bergerak vertikal tanpa horizontal signifikan
			animated_sprite.play("front") # Bisa juga pakai "walk_up/down" jika ada
		else: # Diam
			animated_sprite.play("back")

# Fungsi ini dipanggil ketika NavigationAgent2D selesai menghitung jalur baru (opsional)
# func _on_NavigationAgent2D_path_changed():
# 	print("DEBUG: Jalur navigasi Hantu berubah.")
