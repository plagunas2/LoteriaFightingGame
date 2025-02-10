extends State

@export
var idle_state: State

func process_frame(delta: float) -> State:
	#change state after completing animation
	if parent.animations.get_frame() == 5: 
		return idle_state
	return null

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.get_class() == "Player" && body.get_parent_node_3d() != parent.get_parent_node_3d():
		print("player has been hit!")
		if parent.animations.get_frame() == 3 or 4 or 5: #kicking frames
			body.health -= 2
