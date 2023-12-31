extends CharacterBody2D

@export var move_speed : float = 200
@export var starting_direction : Vector2 = Vector2(0,1)

# parameters/idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		,Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	
	update_animation_parameters(input_direction)
	velocity = input_direction.normalized() * move_speed
	move_and_slide()
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
