extends State

const SPEED = 5.0

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
@export
var punch_state: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("attack") and parent.is_on_floor():
		return punch_state
	return null

func process_physics(delta: float) -> State:
	
	if not parent.is_multiplayer_authority(): return
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#if !direction:
		#return idle_state
	
	#parent.animations.flip_h = direction.x > 0
	#parent.velocity.x = direction.x * SPEED
	#
	
	if direction:
		parent.velocity.x = direction.x * SPEED
		parent.animations.flip_h = direction.x > 0
		parent.rpc("sync_movement", parent.global_transform.origin, parent.velocity, "Walk", parent.animations.flip_h)
	else:
		parent.rpc("sync_movement", parent.global_transform.origin, parent.velocity, "Idle", parent.animations.flip_h)
		return idle_state
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
