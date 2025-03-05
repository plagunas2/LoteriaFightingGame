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
@export
var damage_state: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump'+parent.id) and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("attack"+parent.id) and parent.is_on_floor():
		return punch_state
	return null

func process_physics(delta: float) -> State:
	
	if not parent.is_multiplayer_authority() and not parent.offline: return
	
	var input_dir = Input.get_vector("left"+parent.id, "right"+parent.id, "up"+parent.id, "down"+parent.id)
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#if !direction:
		#return idle_state
	
	#parent.animations.flip_h = direction.x > 0
	#parent.velocity.x = direction.x * SPEED
	#
	
	if direction:
		parent.velocity.x = direction.x * SPEED
		parent.animations.flip_h = direction.x > 0
		hitbox_flip_h(parent.animations.flip_h)
		parent.rpc("sync_movement", parent.global_transform.origin, parent.velocity, "Walk", parent.animations.flip_h)
	else:
		parent.rpc("sync_movement", parent.global_transform.origin, parent.velocity, "Idle", parent.animations.flip_h)
		return idle_state
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
#change positioning of hitbox collision shape to other side if walking in opp direction
func hitbox_flip_h(flip_h: bool):
	if flip_h:
		parent.kick_hitbox.position.x = 0.793
		parent.punch_hitbox.position.x = 0.694
	else:
		parent.kick_hitbox.position.x = -0.793
		parent.punch_hitbox.position.x = -0.694

func damage() -> State:
	return damage_state
