extends State


const SPEED = 5.0

@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var punch_state: State
@export
var damage_state: State
@export
var kick_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('right'):
		return move_state
	if Input.is_action_just_pressed("attack") and parent.is_on_floor():
		return punch_state
	if Input.is_action_just_pressed("kick") and parent.is_on_floor():
		return kick_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.x = move_toward(parent.velocity.x, 0, SPEED)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
	
