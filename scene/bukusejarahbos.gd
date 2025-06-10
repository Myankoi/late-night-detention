extends StaticBody2D

var entered = false
@onready var sprite := $AnimatedSprite2D
@onready var interaction_area := $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")	
	if Global.guru_sejarah_memberi_tugas && !Global.sejarah_item:
		interaction_area.visible = true
	else:
		interaction_area.visible = false
	
func _on_interact():
	var player = get_node("../player")  
	player.can_move = false
	player.velocity = Vector2.ZERO 
	var resource = null
	if Global.guru_sejarah_memberi_tugas && !Global.sejarah_item:
		resource = load("res://dialogue/sejarah_ketemu.dialogue")
		DialogueManager.show_example_dialogue_balloon(resource, "start")
		await DialogueManager.dialogue_ended
	player.can_move = true 

func _process(delta: float) -> void:
	var player = get_node("../player")
	if Global.guru_sejarah_memberi_tugas && !Global.sejarah_item:
		interaction_area.visible = true
	else:
		player.can_move = true
		interaction_area.visible = false
	for child in get_children():
		if child is Sprite2D:
			child.z_index = int(global_position.y)

		
