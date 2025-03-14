extends State

@export
var idle_state: State
# Called when the node enters the scene tree for the first time.
	
func process_frame(delta: float) -> State:
	if parent.is_on_floor():
		parent.fall_kick_hitbox1.disabled = true
		parent.fall_kick_hitbox2.disabled = true
		return idle_state
	return null

func _on_fall_kick_hit_box_1_body_entered(body: Node3D) -> void:
	if body is Player and body.id != parent.id:
		if body.get_node("StateMachine").current_state is not DamageState and body.get_node("StateMachine").current_state is not DuckState and body.get_node("StateMachine").current_state is not SmokeState:
			print("player " + body.id + " has been kicked!")
			body.take_damage(4)
			body.get_node("StateMachine").change_state(body.get_node("StateMachine").current_state.damage())

func _on_fall_kick_hit_box_2_body_entered(body: Node3D) -> void:
	if body is Player and body.id != parent.id:
		if body.get_node("StateMachine").current_state is not DamageState:
			print("player " + body.id + " has been kicked!")
			body.take_damage(4)
			body.get_node("StateMachine").change_state(body.get_node("StateMachine").current_state.damage())
