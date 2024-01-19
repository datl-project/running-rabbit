extends BaseScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$layer/player.play("show")
	await $layer/player.animation_finished
	print("DONE")
	($layer/delay as Timer).start()
	await ($layer/delay as Timer).timeout
	SceneController.transition_to("res://scene/main_menu.tscn")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if $layer/player.is_playing():
			$layer/player.seek($layer/player.current_animation_length - 0.01)
	pass




