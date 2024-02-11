extends SerializingData

#### Settings
@export var volume : int = 3:
	set(value):
		if value > 3 :
			value = 0
		volume = value
		if not AppController.initialized:
			return
		volume_changed.emit(value)
@export var sfx : int = 3:
	set(value):
		if value > 3 :
			value = 0
		sfx = value
		if not AppController.initialized:
			return
		sfx_changed.emit(value)
@export var control : int = 3 :
	set(value) : 
		if value > 3 :
			value = 0
		control = value
		if not AppController.initialized :
			return
		control_changed.emit(value)
@export var brightness : int = 3 :
	set(value) : 
		if value > 3 :
			value = 0
		brightness = value
		if not AppController.initialized :
			return
		brightness_changed.emit(value)
@export var vibration : bool = false:
	set(value) :
		vibration = value
		if not AppController.initialized :
			return
		vibration_changed.emit(value)
		
@export var version : String = "1.0.0.0"

var _color_value : int :
	get : return  [0xbababaff,0xdbdbdbff,0xe2e2e2ff,0xffffffff][brightness]
var _default   := {}

signal volume_changed(value)
signal sfx_changed(value)
signal control_changed(value)
signal brightness_changed(value)
signal vibration_changed(value)

func _ready():
	volume_changed.connect(_on_setting_property_changed)
	sfx_changed.connect(_on_setting_property_changed)
	control_changed.connect(_on_setting_property_changed)
	brightness_changed.connect(_on_setting_property_changed)
	vibration_changed.connect(_on_setting_property_changed)
	
func _on_setting_property_changed(arg):
	save_local_file	(AppController.path_local + "settings.json")
	pass
