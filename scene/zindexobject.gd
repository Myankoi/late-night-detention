extends StaticBody2D

func _ready():
	set_physics_process(true)
	

func _physics_process(delta):
	for child in get_children():
		if child is Sprite2D:
			child.z_index = int(global_position.y)
			
