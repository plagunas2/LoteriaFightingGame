extends State
class_name DuckState
@export
var idle_state: State
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released('down'+parent.id):
		return idle_state
	return null
