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
	#parent.move_and_slide()
	
	if direction:
		parent.velocity.x = direction.x * SPEED
		parent.animations.flip_h = direction.x > 0
		parent.rpc("sync_movement", parent.global_transform.origin, parent.velocity, "Walk", parent.animations.flip_h)
	else:
		parent.rpc("sync_movement", parent.global_transform.origin, parent.velocity, "Idle", parent.animations.flip_h)
		return idle_state
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
@rpc("any_peer", "call_local")
func sync_movement(new_position: Vector3, new_velocity: Vector3, anim_name: String, flip_h: bool):
	if not parent.is_multiplayer_authority():  # Clients update their state based on server data
		parent.global_transform.origin = new_position
		parent.velocity = new_velocity
		parent.animations.play(anim_name)
		parent.animations.flip_h = flip_h
