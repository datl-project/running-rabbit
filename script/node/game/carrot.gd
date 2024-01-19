extends Area2D
class_name Carrot

const rect : Rect2 = Rect2(-12,-19,24,38)

signal rabbit_collide(body)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Rabbit and process_mode != PROCESS_MODE_DISABLED:
		rabbit_collide.emit(body)
	pass # Replace with function body.
