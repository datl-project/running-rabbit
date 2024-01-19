extends Node2D
class_name BaseScene

var initialized : bool = _initializing()
@onready var parent_ready : bool = __parent_ready()


@export var volume : int :
	get: return SettingsController.volume
	set(value): SettingsController.volume = value
	
@export var sfx_volume : int:
	get: return SettingsController.sfx
	set(value): SettingsController.sfx = value
	
@export var control : int:
	get : return SettingsController.control
	set(value) : SettingsController.control = value
	
@export var brightness : int:
	get : return SettingsController.brightness
	set(value) : SettingsController.brightness = value

func _initializing() -> bool:
	if initialized :
		return true
	
	SceneController.current_scene = self
	
	#Connect Signal
	SettingsController.volume_changed.connect(_on_volume_changed)
	SettingsController.sfx_changed.connect(_on_sfx_changed)
	SettingsController.control_changed.connect(_on_control_changed)
	SettingsController.brightness_changed.connect(_on_brightness_changed)
	
	AppController.phone_back.connect(_on_phone_back)
	AppController.phone_resume.connect(_on_phone_resume)
	
	
	#Initializing
	#_on_volume_changed(volume)
	#_on_sfx_changed(sfx_volume)
	#_on_control_changed(control)
	#_on_brightness_changed(brightness)
	
	return true

func __parent_ready():
	_on_volume_changed(volume)
	_on_sfx_changed(sfx_volume)
	_on_control_changed(control)
	_on_brightness_changed(brightness)
	return true

func _on_volume_changed(value):
	pass
	
func _on_control_changed(value):
	pass
	
func _on_sfx_changed(value):
	pass
	
func _on_brightness_changed(value):
	pass

func _on_phone_back():
	pass
	
func _on_phone_resume():
	pass
	
func _on_enter_scene():
	pass

func _on_exit_scene():
	pass
	
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
