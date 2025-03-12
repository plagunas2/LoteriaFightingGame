extends State

const SPEED = 5.0
const AIR_CONTROL = 0.5

@export
var idle_state: State
@export
var move_state: State
@export
var fall_kick_state: State
@export
var damage_state: State

#func _ready() -> void:
	#parent.hitbox.monitoring = false
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("kick"+parent.id):
		if parent.animations.flip_h:
			parent.fall_kick_hitbox2.disabled = false
		else:
			parent.fall_kick_hitbox1.disabled = false
		return fall_kick_state
	return null

func process_physics(delta: float) -> State:
	
	if not parent.is_multiplayer_authority() and not parent.offline: return
	
	#apply gravity
	parent.velocity += parent.get_gravity() * delta
	
	var direction = Vector3.ZERO
	if Input.is_action_pressed("left"+parent.id):
		direction.x -= 1
	if Input.is_action_pressed("right"+parent.id):
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
	
func damage() -> State:
	return damage_state
