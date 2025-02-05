extends State

@export
var idle_state: State

func process_frame(delta: float) -> State:
	#change state after completing animation
	if parent.animations.get_frame() == 7:
		return idle_state
	return null

#func _on_animated_sprite_3d_animation_finished() -> State:
	#print("punch finished!")
	#return idle_state
	
func _on_hit_box_body_entered(body: Node3D) -> void: #punch damage
	if body.get_class() == "Player" && body.get_parent_node_3d() != parent.get_parent_node_3d():
		print("player has been hit!")
		if parent.animations.get_frame() == 4 or 5 or 6: #punching frames
			body.health -= 2
