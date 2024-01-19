extends Pooling
class_name Rabbits

var main_rabbit : Rabbit :
	get : return first() as Rabbit

# SWIPE VELOCITY
@export var min_x_point : int = -330
@export var max_x_point : int =  330 
var point_velocity : Vector2 = Vector2.ZERO

#TOUCH INPUT
@onready var global_mouse_pos := center_of_screen()
@onready var local_mouse_x_multiply := 3

func restart():
	models = [null]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Rabbit : child.target = target_position_of(child)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_check_touch_input(delta)
	
	for child in get_children():
		if child is Rabbit : child.target = target_position_of(child)
	pass

func _update_data(rabbit : Node, _data)-> void:
	super._update_data(rabbit,_data)
	if rabbit == main_rabbit:
		rabbit.position = Vector2.ZERO
	else:
		rabbit.position = $spawn.position


func target_position_of(rabbit):
	var point
	var _y : int = $"../point".position.y
	var _x : int = position_refect_center(global_mouse_pos).x * local_mouse_x_multiply
	return Vector2(_x ,_y)

func _check_touch_input(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Get the global mouse position
		global_mouse_pos = get_viewport().get_mouse_position()
	pass
	
func center_of_screen() -> Vector2: 
	return get_viewport_rect().size / 2

func position_refect_center(pos : Vector2) :
	return pos - center_of_screen()
	
func _on_spawned(node):
	var rabbit = node as Rabbit
	if not rabbit:
		return
	if rabbit == main_rabbit:
		rabbit._is_spawned("start_app")
	else:
		rabbit._is_spawned("spawned")
	pass # Replace with function body.

