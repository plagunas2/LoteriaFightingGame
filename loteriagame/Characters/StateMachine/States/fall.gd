extends State

const SPEED = 5.0
const AIR_CONTROL = 0.5

@export
var idle_state: State
@export
var move_state: State

func process_physics(delta: float) -> State:
	#apply gravity
	parent.velocity += parent.get_gravity() * delta
	
	var direction = Vector3.ZERO
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized() * SPEED * AIR_CONTROL
		parent.velocity.x = direction.x
		
	parent.move_and_slide()
	
	if parent.is_on_floor():
		parent.velocity.y = 0  # Reset vertical velocity to avoid bouncing
		if direction != Vector3.ZERO:
			return move_state
		return idle_state
	
	return null
