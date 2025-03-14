extends State
class_name KickState

@export
var idle_state: State

func process_frame(delta: float) -> State:
	#change state after completing animation, disable kick collision
	if parent.animations.get_frame() == 5: 
		parent.kick_hitbox.disabled = true
		print("kick hitbox collision disabled = " + str(parent.kick_hitbox.disabled))
		return idle_state
	return null

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body is Player and body.id != parent.id:
		var body_state = body.get_node("StateMachine").current_state
		if body_state is not DamageState and body_state is not KickState and body_state is not PunchState and body_state is not FallKickState and body_state is not DuckState and body_state is not SmokeState:
			print("player " + body.id + " has been kicked!")
			if parent.animations.get_frame() == 3 or 4 or 5: #kicking frames
				body.take_damage(2)
				$"../../Punch".play()
			print("damage taken")
			body.get_node("StateMachine").change_state(body.get_node("StateMachine").current_state.damage())
