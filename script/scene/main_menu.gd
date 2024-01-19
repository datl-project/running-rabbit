extends BaseScene
class_name MainMenu
	
@onready var ui_map : Dictionary = {
	"title" :  $ui/menu,
	"settings" : $ui/settings,
	"about" : $ui/appinfo
}
var ui : String = "title":
	set(value):
		if ui_map.keys().find(value) < 0 or (value == ui and value != "title"):
			value = "title"
		ui = value
		print("ui = %s" % ui)
		if not self.is_node_ready():
			await self.ready
		_update_ui(value)

func update_icon(node,type,value):
	var icon = "mute"
	match value:
		0 : icon = "mute"
		1 : icon = "1"
		2 : icon = "2"
		3 : icon = "3"
		_ : icon = "mute"
	self.change_button_icon(node,"ui/"+type+"_"+icon)
	pass
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.scroll_offset.y += delta * 100
	$camera.offset.y += delta * 100
	if $camera.offset.y >= 745 :
		$camera.offset.y = 0
	pass


func _on_menu_gui_input(event):
	var mouse : InputEventMouseButton = event as InputEventMouseButton
	if mouse:
		if mouse.pressed and mouse.button_index == MOUSE_BUTTON_LEFT:
			$ui/sfx.play()
		elif mouse.is_released() and mouse.button_index == MOUSE_BUTTON_LEFT:
			SceneController.transition_to("res://scene/game.tscn")
	pass # Replace with function body.

func _on_setting_pressed():
	$ui/sfx.play()
	ui = "settings"
	pass # Replace with function body.

func _on_scores_pressed():
	$ui/sfx.play()
	GooglePlayController.show_leaderboard()
	pass # Replace with function body.
	
func _on_close_pressed():
	$ui/sfx.play()
	ui = "title"
	pass # Replace with function body.
	
func _on_about_pressed():
	$ui/sfx.play()
	ui = "about"
	pass # Replace with function body.
	
func _on_clear_pressed():
	$ui/sfx.play()
	PopupController.show_popup(Popups.PopupID.POPUP_CLEAR_DATA,_on_handle_clear_all_popup)
	pass # Replace with function body.
	
func _on_volume_changed(value):
	update_icon($ui/settings/list/sound/button,"icon_volume_small",self.volume)
	if value == 0 : 
		$sound .volume_db = -72
	else:
		$sound .volume_db = - (3 - value) * 14
	pass
	
func _on_sfx_changed(value):
	update_icon($ui/settings/list/sound/sfx/button,"icon_volume_small",self.sfx_volume)
	if value == 0 : 
		$ui/sfx .volume_db = -72
	else:
		$ui/sfx .volume_db = - (3 - value) * 14
	pass
	
func _on_control_changed(value):
	$ui/settings/list/control/textbutton.text = str(self.control)
	pass

func _on_brightness_changed(value):
	$ui/settings/list/brightness/textbutton.text = str(self.brightness)
	
	$".".modulate = SettingsController._color_value
	$background.change_brighness(SettingsController._color_value)
	
	$ui/menu.modulate = SettingsController._color_value
	$ui/setting.modulate = SettingsController._color_value
	$ui/scores.modulate = SettingsController._color_value
	$ui/settings.modulate = SettingsController._color_value
	
	pass

func _on_handle_clear_all_popup(action,args):
	if action == "btn_pressed" :
		if args == "btn1":
			print("Pressing Yes")
		elif args == "btn2" :
			print("pressing No")
	pass
	
func _on_handle_quit_app(action,args):
	if action == "btn_pressed" :
		if args == "btn1":
			print("Pressing Yes")
			AppController.close_app()
		elif args == "btn2" :
			print("pressing No")
	pass
	
func _on_phone_back():
	PopupController.show_popup(Popups.PopupID.POPUP_QUIT_APP,_on_handle_quit_app)
	pass

func _update_ui(type) :
	#INITIALIZING VALUE
	for key in ui_map.keys():
		print("key = %s %s!=null" % [key,ui_map[key]])
		if ui_map[key] == null:
			continue

		if key == type : ui_map[key].show()
		else 		   : ui_map[key].hide()


func _on_volume_button_pressed():
	self.volume += 1
	pass # Replace with function body.

func _on_sfx_button_pressed():
	self.sfx_volume += 1
	pass # Replace with function body.

func _on_textbutton_released():
	self.control += 1
	pass # Replace with function body.

func _on_brightness_textbutton_released():
	self.brightness += 1
	pass # Replace with function body.
