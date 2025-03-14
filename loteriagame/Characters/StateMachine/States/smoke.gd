extends State
class_name SmokeState

@export
var idle_state: State

func process_frame(delta: float) -> State:
	if parent.animations.get_frame() == 19:
		return idle_state
	return null
