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
	if Input.is_action_just_pressed('jump'+parent.id) and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed('left'+parent.id) or Input.is_action_just_pressed('right'+parent.id):
		return move_state
	if Input.is_action_just_pressed('attack'+parent.id) and parent.is_on_floor():
		#enable punch collision
		parent.punch_hitbox.disabled = false
		print("punch hitbox collision disabled =  " + str(parent.punch_hitbox.disabled))
		return punch_state
	if Input.is_action_just_pressed('kick'+parent.id) and parent.is_on_floor():
		#enable kick collision
		parent.kick_hitbox.disabled = false
		print("kick hitbox collision disabled = " + str(parent.kick_hitbox.disabled))
		return kick_state
	return null

func process_physics(delta: float) -> State:
	if not parent.is_multiplayer_authority() and not parent.offline: return
	parent.velocity.x = move_toward(parent.velocity.x, 0, SPEED)
	parent.move_and_slide()
	if !parent.is_on_floor():
		return fall_state
	return null
	
func damage() -> State:
	return damage_state
	
	
