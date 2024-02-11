extends BaseScene
class_name MainGame

enum Status{
	INIT,
	RUNNING,
	PAUSE,
	GAMEOVER,
}
enum Reason{
	NONE,
	PAUSE_BY_BUTTON,
	PAUSE_BY_BACK,
	PAUSE_BY_APP_RESUME,
	
	UNKNOWN = -1,
}
var level 		 : int 		= 1
var status		 : Status 	= Status.INIT
var pause_reason : Reason	= Reason.NONE

@export var default_speed_scale    : int = 1

@export var default_fences_content : int = 5
@export var fence_level_change     : int = 6
@export var fence_value_change     : int = 1

@export var default_carrots_content : int = 4
@export var carrot_level_change     : int = 3
@export var carrot_value_change     : int = -1

@export var scrolling_value_change  : float = 0.25
@export var scrolling_value_max     : float = 14.0

@export var score_rabbit_count      : int = 1
@export var score_eating_carrot 	: int = 2
@export var score_touching_fence 	: int = 4

var score : int = 0 :
	set(value) :
		score = value
		if not self.is_node_ready():
			await self.ready
		$ui.score = score
		
var highscore : int:
	get 		: return DataController.highscore
	set(value) 	: 
		DataController.highscore = value
		if not self.is_node_ready():
			await self.ready
		$ui/popup/panel/scores/highscore/value.text = str(DataController.highscore)
	

	
var distance  : float = 0 :
	set(value) 	:
		distance = value
		if not self.is_node_ready():
			await self.ready
		$ui/popup/panel/list/distant/value.text = str(int(value))

var highest_rabbit : int = 0:
	set(value) 	:
		highest_rabbit = value
		if not self.is_node_ready():
			await self.ready
		$ui/popup/panel/list/rabbits/value.text = str(int(value))

var time      : float = 0 :
	set(value) 	:
		time = value
		if not self.is_node_ready():
			await self.ready
		$ui/popup/panel/list/time/value.text = str(int(value))

signal add_rabbit
signal remove_rabbit

@onready var node_rabbits 	:= $scene/rabbits
@onready var node_scrolling := $scene/scrolling

@onready var rabbit_count : 
	get: return node_rabbits.count
	
func restart():
	$scene/sound.stop()
	SceneController.transition_to("res://scene/game.tscn")
	pass

func pause(reason) :
	pause_reason = reason
	pause_game()

func resume(reason) :
	pause_reason = Reason.NONE
	resume_game()
		
# Called when the node enters the scene tree for the first time.
func _ready(): 
	status = Status.INIT
	node_scrolling.speed_scale    = default_speed_scale
	node_scrolling.fences_content = default_fences_content
	node_scrolling.carrot_content = default_carrots_content
	score = 0
	distance = 0
	time = 0

	$ui/popup/panel/scores/score/value.text  = "0"
	$ui/popup/panel/list/time/value.text = "0"
	$ui/popup/panel/list/distant/value.text = "0"
	$ui/popup/panel/list/rabbits/value.text = "0"
		
	status = Status.RUNNING
	
	await DataController.update_highscore()
	$ui/popup/panel/scores/highscore/value.text = str(highscore)
	
	pass # Replace with function body.

func _process(delta):
	calculate_runtime_game(delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_volume_changed(value):
	$ui.volume = value
	if value == 0 : 
		$scene/sound.volume_db = -72
	else:
		$scene/sound.volume_db = - (3 - value) * 14
	pass
	
func _on_sfx_changed(value):
	if value == 0 : 
		$scene/sfx.volume_db = -72
		$ui/sfx.volume_db = -72
	else:
		$scene/sfx.volume_db = - (3 - value) * 14
		$ui/sfx.volume_db = - (3 - value) * 14
	pass

func _on_control_changed(value):
	$scene/rabbits.local_mouse_x_multiply = (value * 2) + 3
	pass

func _on_brightness_changed(value):
	$".".modulate = SettingsController._color_value
	$ui/count.modulate = SettingsController._color_value
	$ui/score.modulate = SettingsController._color_value
	$ui/back.modulate = SettingsController._color_value
	$ui/sound.modulate = SettingsController._color_value
	$ui/popup.modulate = SettingsController._color_value
	pass

func _on_vibration_changed(value):
	if value:
		Input.vibrate_handheld(100)

func _on_phone_back():
	if status == Status.RUNNING:
		pause(Reason.PAUSE_BY_BACK)
	elif status == Status.PAUSE:
		if pause_reason == Reason.PAUSE_BY_BACK:
			quit_game()
		elif pause_reason == Reason.PAUSE_BY_BUTTON:
			resume(Reason.PAUSE_BY_BUTTON)
		elif pause_reason == Reason.PAUSE_BY_APP_RESUME:
			resume(Reason.PAUSE_BY_APP_RESUME)
			
	elif status == Status.GAMEOVER:
		quit_game()
	pass
	
func _on_phone_resume():
	if status == Status.RUNNING or status == Status.PAUSE:
		pause(Reason.PAUSE_BY_APP_RESUME)

func _on_exit_scene():
	#GooglePlayController.hide_banner()
	pass

func _on_enter_scene():
	#GooglePlayController.show_banner()
	pass

func _on_timer_timeout():
	increase_level()
	pass

func increase_level():
	level += 1
	node_scrolling.speed_scale = min(node_scrolling.speed_scale + scrolling_value_change, scrolling_value_max)
	node_scrolling.fences_content = max(1, default_fences_content  + (level / fence_level_change) * fence_value_change )
	node_scrolling.carrot_content = max(1, default_carrots_content + (level / carrot_level_change) * carrot_value_change)
	
func update_rabbit_count():
	if not self.is_node_ready():
		await self.ready
	$ui/count/content/label.text = str(node_rabbits.count)

func calculate_end_game():
	if score > highscore :
		DataController.submit_score(score)
		DataController.update_highscore()
	pass
	
func calculate_runtime_game(delta):
	if status == Status.RUNNING:
		time += delta
		distance += delta * $scene/scrolling.speed_scale
		highest_rabbit = max(highest_rabbit,rabbit_count)
		
func restart_game():
	if status == Status.RUNNING or status == Status.PAUSE:
		self.process_mode = Node.PROCESS_MODE_INHERIT
		$ui.popup = ""
		restart()
		pass
	elif status == Status.GAMEOVER:
		self.process_mode = Node.PROCESS_MODE_INHERIT
		$ui.popup = ""
		restart()
		pass

func pause_game():
	if status == Status.RUNNING:
		self.process_mode = Node.PROCESS_MODE_DISABLED
		$ui.popup = "pause"
		status = Status.PAUSE

func resume_game():
	if status == Status.PAUSE:
		self.process_mode = Node.PROCESS_MODE_INHERIT
		$ui.popup = ""
		status = Status.RUNNING
		
func end_game():
	if status == Status.RUNNING:
		$".".process_mode = Node.PROCESS_MODE_DISABLED
		$ui.popup = "gameover"
		status = Status.GAMEOVER
		calculate_end_game()
	pass
	
func quit_game():
	SceneController.transition_to("res://scene/main_menu.tscn")
	pass
	
func check_gameover():
	if rabbit_count == 0 and (status == Status.RUNNING or status == Status.PAUSE):
		end_game()
	pass
	
func play_sfx(path):
	$scene/sfx.stream = load(path)
	$scene/sfx.play()
	
## RABIT FUNCTION
func rabbit_eat(rabbit,carrot):
	if not (carrot is Carrot) or not(rabbit is Rabbit) or (rabbit.status != Rabbit.Status.RUNNING):
		return
	play_sfx("res://sound/sfx/eat0.ogg")
	node_rabbits.spawn()
	node_scrolling.destroy_object(carrot)
	pass
	
func rabbit_kill(rabbit):
	if not (rabbit is Rabbit):
		return
	if self.vibration:
		Input.vibrate_handheld(500)
	play_sfx("res://sound/sfx/hit0.ogg")
	node_rabbits.despawn(rabbit)
	check_gameover()
	pass
	
func _on_scrolling_rabbit_out_of_zone(source):
	if status == Status.RUNNING:
		rabbit_kill(source)
	pass # Replace with function body.

func _on_scrolling_rabbit_collide(source, target):
	if status == Status.RUNNING:
		rabbit_eat(source,target)
	pass # Replace with function body.

func _on_rabbits_updated():
	update_rabbit_count()
	pass # Replace with function body.

func _on_back_pressed():
	pass # Replace with function body.

func _on_scoring_timer_timeout():
	score += score_rabbit_count * rabbit_count
	pass # Replace with function body.


func _on_ui_button_pressed(event):
	if self.vibration :
		Input.vibrate_handheld(100)
	match event:
		"quit":
			quit_game()
			pass
			
		"retry":
			restart_game()
			pass
			
		"cancel":
			resume_game()
			pass
			
		"volume":
			self.volume += 1
			pass
			
		"back":
			if status == Status.RUNNING :
				pause(Reason.PAUSE_BY_BUTTON)
			else:
				resume(Reason.PAUSE_BY_BUTTON)
			pass
	pass # Replace with function body.






