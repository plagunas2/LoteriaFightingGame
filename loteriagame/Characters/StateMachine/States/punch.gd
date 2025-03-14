extends State
class_name PunchState

@export
var idle_state: State

func process_frame(delta: float) -> State:
	# Only the authority controls the attack
	#if parent.is_multiplayer_authority():
		# Sync the attack animation across the network
		#parent.rpc("sync_attack_animation")
	#change state after completing animation, disable punch collision
	if parent.animations.get_frame() == 7:
		parent.punch_hitbox.disabled = true
		print("punch hitbox collision disabled =  " + str(parent.punch_hitbox.disabled))
		return idle_state
	return null

#func _on_animated_sprite_3d_animation_finished() -> State: NOT WORKING
	#print("punch finished!")
	#return idle_state
	# [DamageState, KickState, PunchState, FallKickState, DuckState, SmokeState]
func _on_hit_box_body_entered(body: Node3D) -> void: #punch damage
	if body is Player and body.id != parent.id:
		var body_state = body.get_node("StateMachine").current_state
		if body_state is not DamageState and body_state is not KickState and body_state is not PunchState and body_state is not FallKickState and body_state is not DuckState and body_state is not SmokeState:
			print("player " + body.id + "has been punched!")
			if parent.animations.get_frame() == 4 or 5 or 6: #punching frames
				body.take_damage(2)
				$"../../Punch".play()
			print("damage taken")
			body.get_node("StateMachine").change_state(body.get_node("StateMachine").current_state.damage())
