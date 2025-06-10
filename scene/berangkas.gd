extends StaticBody2D

var entered = false
@onready var sprite := $AnimatedSprite2D
@onready var interaction_area := $InteractionArea
@onready var input_ui = get_node("../CanvasLayer/TextureRect/InputText")
@onready var gambar = get_node("../CanvasLayer/TextureRect")
@onready var label = get_node("../CanvasLayer/TextureRect/Label")

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	var player = get_node("../player")  
	player.can_move = false
	player.velocity = Vector2.ZERO 
	
	
	gambar.show()
	input_ui.show()
	label.hide()
	input_ui.get_node("LineEdit").grab_focus()
	input_ui.get_node("LineEdit").text = ""
	if not input_ui.is_connected("answer_submitted", Callable(self, "_on_answer_received")):
		input_ui.connect("answer_submitted", Callable(self, "_on_answer_received"))

func _on_answer_received(answer: String) -> void:
	var player = get_node("../player")
	var input_ui = get_node("../CanvasLayer/TextureRect/InputText")
	var gambar = get_node("../CanvasLayer/TextureRect")
	var label = get_node("../CanvasLayer/TextureRect/Label")
	if answer.to_lower() == "9042":
		_on_correct_answer(player)
		gambar.hide()
		input_ui.hide()
		label.hide()
		player.can_move = false
		player.velocity = Vector2.ZERO 
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/dapatkuncidialogue.dialogue"), "start")
		await DialogueManager.dialogue_ended
		Global.dapetkuncigerbang = true
		player.can_move = true 
	else:
		label.show()
	
	player.can_move = true

func _on_correct_answer(body: PhysicsBody2D) -> void:
	if body is CharacterBody2D:
		entered = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		gambar.visible
		input_ui.hide()
		label.hide()
	for child in get_children():
		if child is Sprite2D:
			child.z_index = int(global_position.y)
	if entered:
		$AnimatedSprite2D.offset.x = 15
		$AnimatedSprite2D.offset.y = 16
		$AnimatedSprite2D.frame = 1
	else:
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.offset.x = 0
		$AnimatedSprite2D.offset.y = 0
		
