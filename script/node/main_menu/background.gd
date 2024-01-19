extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scroll_offset.y += delta * 100
	pass
	
func change_brighness(value):
	$background.modulate = value
	$ParallaxLayer.modulate = value
	pass

