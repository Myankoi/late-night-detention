extends CharacterBody2D
@onready var sprite := $AnimatedSprite2D
@onready var interaction_area := $InteractionArea

func _ready():
	if !Global.guru_ipa_selesai:
		interaction_area.visible = true
		interaction_area.interact = Callable(self, "_on_interact")
	else:
		interaction_area.visible = false
	
func _on_interact():
	var player = get_node("../player")  
	player.can_move = false
	player.velocity = Vector2.ZERO 
	var resource = null
	if Global.guru_ipa_memberi_tugas && !Global.ipa_item:
		resource = load("res://dialogue/ipa_belomketemu.dialogue")
	elif !Global.guru_ipa_memberi_tugas && !Global.ipa_item:
		resource = load("res://dialogue/opening_ipa.dialogue")
	elif Global.guru_ipa_memberi_tugas && Global.ipa_item:
		resource = load("res://dialogue/quiz_ipa.dialogue")
	DialogueManager.show_example_dialogue_balloon(resource, "start")
	await DialogueManager.dialogue_ended
	player.can_move = true

func _physics_process(delta):
	var player = get_node("../player")  
	if !Global.guru_ipa_selesai:
		interaction_area.show()
		interaction_area.interact = Callable(self, "_on_interact")
	else:
		player.can_move = true
		queue_free()
	sprite.z_index = int(global_position.y)
	sprite.play("idle")
