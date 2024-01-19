extends CanvasLayer

var _model := Popups.new()

var current_id		: int

var popup_handler : Callable
var popup_data    : Dictionary
var popup_flags   : int
var popup_type 	  : String
var popup_content : String
var popup_buttons : Array

@onready var type_node : Dictionary = {
	"type1" : {
		"content"   : $outside/type1/content,
		"btn"		: [$outside/type1/button/btn1,$outside/type1/button/btn2],
		"btn_label" : [$outside/type1/button/btn1/label,$outside/type1/button/btn2/label]
	}
}
@export var sfx_volume : int:
	get: return SettingsController.sfx
	set(value): SettingsController.sfx = value
	
func show_popup(id,handler : Callable = Callable()):
	if not (id in Popups.PopupsDefine.keys()):
		hide_popup()
	current_id 		= id
	
	popup_handler 	= handler
	popup_data		= Popups.PopupsDefine[id]
	popup_flags		= 0	   		if not popup_data.has("flags")		else popup_data.flags
	popup_type		= "type1" 	if not popup_data.has("type") 		else popup_data.type
	popup_content	= ""		if not popup_data.has("content") 	else popup_data.content
	popup_buttons	= []		if not popup_data.has("buttons") 	else popup_data.buttons
	_display_popup(popup_type)
	_update_popup(popup_type)
	
func hide_popup(reason = ""):
	popup_handler 	= Callable()
	popup_data		= {}
	popup_flags		= 0
	popup_type		= "none"
	popup_content	= ""
	popup_buttons	= []
	_display_popup(popup_type)
	_update_popup(popup_type)
	pass

func _display_popup(type):
	var no_popup_show = true
	for popup in $outside.get_children():
		if popup.name == type:
			popup.show()
			no_popup_show = false
			$outside.show()
		else:
			popup.hide()
	if no_popup_show:
		$outside.hide()
	pass
	
func _update_popup(type):
	if not (type_node.keys().has(type)):
		return
	
	#Update Popup Content
	if type_node[type].content != null and "text" in type_node[type].content:
		type_node[type].content.text = popup_content
	
	#Update Popup Buttons Label
	for i in range(type_node[type].btn_label.size()):
		if type_node[type].btn_label[i] != null and "text" in type_node[type].btn_label[i]:
			if i < popup_buttons.size():
				type_node[type].btn_label[i].text = str(popup_buttons[i])
			else:
				type_node[type].btn_label[i].text = ""
			pass
	pass
	
func _ready():
	_connect_signal()
	_init()
	
func _connect_signal():
	if not SceneController.is_node_ready():
		await SceneController.ready
	SceneController.transitioning.connect(_on_scene_transitioning)
	if not SettingsController.is_node_ready():
		await SettingsController.ready
	SettingsController.sfx_changed.connect(_on_sfx_changed)
	pass

func _init():
	if not SettingsController.is_node_ready():
		await SettingsController.ready
	_on_sfx_changed(sfx_volume)
	
func _on_scene_transitioning():
	hide_popup("scene_transitioning")
	pass
	
func _on_popup_actions(action,arg):
	if !popup_handler.is_null():
		popup_handler.call(action,arg)
		
	if action == "btn_pressed" :
		if (popup_flags & Popups.PRESSED_KEEP) == 0:
			hide_popup("btn_pressed")
	elif action == "outside_pressed":
		if (popup_flags & Popups.CLICK_OUTSIDE_CLOSE) != 0 :
			hide_popup("outside_pressed")
	pass

func _on_sfx_changed(value):
	if value == 0 : 
		$sfx.volume_db = -72
	else:
		$sfx.volume_db = - (3 - value) * 14
	pass
	
func _on_btn_1_pressed():
	$sfx.play()
	_on_popup_actions("btn_pressed","btn1")
	pass # Replace with function body.

func _on_btn_2_pressed():
	$sfx.play()
	_on_popup_actions("btn_pressed","btn2")
	pass # Replace with function body.

func _on_outside_gui_input(event):
	var mouse : InputEventMouseButton = event as InputEventMouseButton
	if mouse:
		if mouse.pressed and mouse.button_index == MOUSE_BUTTON_LEFT:
			_on_popup_actions("outside_pressed",null)
			pass
	pass # Replace with function body.
