extends Node3D



func _on_out_of_bounds_body_entered(body):
	if body.has_method("out_of_bounds"):
		body.out_of_bounds()


func _on_out_of_bounds_body_exited(body):
	if body.has_method("in_bounds"):
		body.in_bounds()

func _on_void_body_entered(body):
	if body.has_method("in_void"):
		body.in_void()
