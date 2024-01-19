extends StaticBody2D

@export var land_size = Vector2(200, 200): # Default size
	set(value) :
		land_size = value
		if not self.is_node_ready():
			await self.ready
		update_size(value)

func update_size(size):
	$sprite.custom_minimum_size = size
	$sprite.size = size
	var collision_shape = $collision
	var shape = RectangleShape2D.new()
	shape.extents = size / 2

	collision_shape.shape = shape
	collision_shape.position = size / 2
