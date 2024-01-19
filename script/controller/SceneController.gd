extends CanvasLayer


#PROPERTY
@export var wait_scene_function : bool = true

var is_transitioning = false

var current_scene: BaseScene = null

#SIGNAL
signal transitioning()
signal done_transition()

func is_screen_transitioning():
	return is_transitioning

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the transition scene and add it to the scene tree.
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
func displaying ():
	$player_transition.play("showing")
	await $player_transition.animation_finished
	
func fading ():
	$player_transition.play("fading")
	await $player_transition.animation_finished
	
func current() :
	return current_scene
	
func transition_to(scene):
	get_tree().paused = true
	is_transitioning = true
	transitioning.emit()
	
	if "_on_exit_scene" in current_scene:
		if wait_scene_function:
			await current_scene._on_exit_scene()
		else:
			current_scene._on_exit_scene()
		
	await fading()
	
	get_tree().change_scene_to_file(scene)
	await get_tree().create_timer(0.5).timeout
	
	await displaying()
	
	get_tree().paused = false
	
	if "_on_enter_scene" in current_scene:
		if wait_scene_function:
			await current_scene._on_enter_scene()
		else:
			current_scene._on_enter_scene()
			
	is_transitioning = false
	done_transition.emit()
	
	pass
