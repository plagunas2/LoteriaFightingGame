extends State

@export
var idle_state: State

func process_frame(delta: float) -> State:
	#change state after completing animation
	if parent.animations.get_frame() == 5:
		return idle_state
	return null
