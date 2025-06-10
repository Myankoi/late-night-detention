extends StaticBody2D

var entered = false
@onready var sprite := $AnimatedSprite2D
@onready var interaction_area := $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	var player = get_node("../player")  
	player.can_move = false
	player.velocity = Vector2.ZERO 
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/2.dialogue"), "start")
	await DialogueManager.dialogue_ended
	player.can_move = true 

func _process(delta: float) -> void:
	for child in get_children():
		if child is Sprite2D:
			child.z_index = int(global_position.y)
