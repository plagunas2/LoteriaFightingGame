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
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#parent.velocity.x = direction.x * SPEED
	#parent.animation.flip_h = direction.x > 0
	
	if !direction:
		return idle_state
	
	parent.animations.flip_h = direction.x > 0
	parent.velocity.x = direction.x * SPEED
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
