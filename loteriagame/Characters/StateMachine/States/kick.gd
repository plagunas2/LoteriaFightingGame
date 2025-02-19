extends State

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
		print("player " + body.id + " has been kicked!")
		if parent.animations.get_frame() == 3 or 4 or 5: #kicking frames
			body.health -= 2
			if str(body.get_node("StateMachine").current_state) != "Damage":
				print("damage taken")
				body.get_node("StateMachine").current_state.damage()
