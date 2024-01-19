extends CanvasLayer

var time : int:
	set(value):
		time = value
		if not self.is_node_ready():
			await self.ready
		$pause/panel/list/time/value.text = str(time)
var distant : int:
	set(value):
		distant = value
		if not self.is_node_ready():
			await self.ready
		$pause/panel/list/distant/value.text = str(value)
var rabbits : int:
	set(value):
		rabbits = value
		if not self.is_node_ready():
			await self.ready
		$pause/panel/list/rabbits/value.text = str(value)	
var score : int:
	set(value):
		score = value
		if not self.is_node_ready():
			await self.ready
		$popup/panel/scores/score/value.text = str(value)		
		$score/panel/label.text = str(value)
		
var highscore : int:
	set(value):
		highscore = value
		if not self.is_node_ready():
			await self.ready
		$pause/panel/scores/highscore/value.text = str(value)
var volume : int :
	set(value):
		volume = value
		if not self.is_node_ready():
			await self.ready
		var icon = "mute"
		match value:
			0 : icon = "mute"
			1 : icon = "1"
			2 : icon = "2"
			3 : icon = "3"
			_ : icon = "mute"
		change_button_icon($sound/icon,"ui/icon_volume_"+icon)
		
var popup : String = "" :
	set(value) :
		if (value == "pause" or value == "gameover") and popup != value:
			popup = value
			if not self.is_node_ready():
				await self.ready
			_display_popup(popup)
		else:
			popup = ""
			_hide_popup()

signal button_pressed(event)

### FUNCTION
func change_button_icon(icon,path):
	var icon_n = "res://image/"+path+"_n.png"
	var icon_p = "res://image/"+path+"_p.png"
	var icon_f = "res://image/"+path+"_f.png"
	
	var res_n = load(icon_n)
	var res_p = load(icon_p)
	var res_f = load(icon_f)
		
	if not self.is_node_ready():
		await self.ready
		
	icon.texture_normal  = res_n
	icon.texture_pressed = res_p if res_p != null else res_n
	icon.texture_hover   = res_f if res_f != null else res_n

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _display_popup(popup):
	if not $popup.visible:
		$popup.show()
	match popup:
		"pause":
			$popup/image.texture = preload("res://image/ui/pause-image.png")
			$popup/button/cancel.visible = true
			$back.process_mode = Node.PROCESS_MODE_INHERIT
			pass
		"gameover":
			$popup/image.texture = preload("res://image/ui/game-over-text.png")
			$popup/button/cancel.visible = false
			$back.process_mode = Node.PROCESS_MODE_DISABLED
			pass
	pass

func _hide_popup():
	if $popup.visible:
		$popup.hide()
	$back.process_mode = Node.PROCESS_MODE_INHERIT
	$popup/button/cancel.visible = true

func play_sound():
	$sfx.play()
	pass
	
func _on_quit_pressed():
	play_sound()
	button_pressed.emit("quit")
	pass # Replace with function body.

func _on_retry_pressed():
	play_sound()
	button_pressed.emit("retry")
	pass # Replace with function body.

func _on_cancel_pressed():
	play_sound()
	button_pressed.emit("cancel")
	pass # Replace with function body.

func _on_back_pressed():
	play_sound()
	button_pressed.emit("back")
	pass # Replace with function body.

func _on_sound_pressed():
	play_sound()
	button_pressed.emit("volume")
	pass # Replace with function body.
