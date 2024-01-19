extends Label

var is_pressed : bool = false
var is_hovered : bool = false

@export var pressed_settings  : LabelSettings = null
@export var hovered_settings  : LabelSettings = null

@onready var normal_settings : LabelSettings = (self as Label).label_settings
signal pressed
signal clicked
signal released
signal hovered

# Called when the node enters the scene tree for the first time.
func _ready():
	print("normal_Settings = %s "% normal_settings)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_gui_input(event):
	var mouse : InputEventMouseButton = event as InputEventMouseButton
	if mouse:
		if mouse.pressed and mouse.button_index == MOUSE_BUTTON_LEFT and not is_pressed:
			print("IS_PRESSED")
			is_pressed = true
			_update_button_display()
			pressed.emit()
		elif mouse.is_released() and mouse.button_index == MOUSE_BUTTON_LEFT and is_pressed:
			print("IS_RELEASED")
			is_pressed = false 
			_update_button_display()
			released.emit()
			clicked.emit()
	pass # Replace with function body.
	
func _update_button_display():
	if is_pressed:
		(self as Label).label_settings = pressed_settings if pressed_settings != null else normal_settings
		#IS PRESSED
		pass
	elif is_hovered:
		(self as Label).label_settings = hovered_settings if hovered_settings != null else normal_settings
		#IS HOVERED
		pass
	else:
		(self as Label).label_settings = normal_settings 
		#IS NORMAL
		pass
	pass

func _on_mouse_entered():
	if not is_hovered :
		is_hovered = true
		hovered.emit()
		_update_button_display()
	pass # Replace with function body.

func _on_mouse_exited():
	if is_hovered :
		is_hovered = false
		_update_button_display()
	pass # Replace with function body.
