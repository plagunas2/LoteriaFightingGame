extends State

const JUMP_VELOCITY = 4.5
const SPEED = 5.0

@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State

@export
var jump_force: float = 900.0

func enter() -> void:
	super()
	#parent.velocity.y = -jump_force
	parent.velocity.y = JUMP_VELOCITY

func process_physics(delta: float) -> State:
	#parent.velocity.y = JUMP_VELOCITY
	
	if parent.velocity.y > 0:
		return fall_state
		
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if direction:
		parent.animations.flip_h = direction.x > 0
	
	parent.velocity.x = direction.x * SPEED
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if direction:
			return move_state
		return idle_state
	
	return null
