extends State
class_name DamageState

@export
var idle_state: State
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
		parent.move_and_slide()
	
func process_frame(delta: float) -> State:
	if parent.animations.get_frame() == 11:
		return idle_state
	return null
