extends Node2D

## SIGNAL 
signal done_pooling ()
signal rabbit_collide(source,part)

@onready var fence_content : int = 3:
	set(value) :
		fence_content = value
		$fences.generating_number = value
		
@onready var carrot_content : int = 3:
	set(value) :
		carrot_content = value
		$carrots.generating_number = value
		
@onready var rect : Rect2 :
	get: 
		var rect = $contentarea/rect.shape.get_rect()
		var position = $contentarea.position + rect.position
		return Rect2(position,rect.size)

var rect_occupied: Array = []

func pooling():
	rect_occupied = []
	$lands/left.generate()
	$lands/right.generate()
	$fences.generate()
	$carrots.generate()
	done_pooling.emit()

func destroy_object(object):
	$lands/left.despawn(object)
	$lands/right.despawn(object)
	$fences.despawn(object)
	$carrots.despawn(object)
	
func restart():
	$lands/left.models = []
	$lands/right.models = []
	$fences.models = []
	$carrots.models = []
	pooling()
	pass

func clear(ignore_land):
	if not ignore_land:
		$lands/left.models = []
		$lands/right.models = []
	$fences.models = []
	$carrots.models = []
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_fences_pooling_node(node : Fence):
	node.rabbit_collide.connect(handle_item_signal.bind("rabbit_collide",node))
	pass # Replace with function body.
	
func _on_carrots_pooling_node(node):
	node.rabbit_collide.connect(handle_item_signal.bind("rabbit_collide",node))
	pass # Replace with function body.

func handle_item_signal(data,type,source):
	match type:
		"rabbit_collide" : rabbit_collide.emit(source,data)
	pass

func check_have_object(x,y):
	$check.position = Vector2(-10,-10)
	$check.target_position = Vector2(x,y)
	return $check.is_colliding()

func check_unused_position(_x,_y):
	return not check_have_object(_x,_y)
			
func check_unused_rect(_rect : Rect2):
	var top 	= _rect.position
	var bot		= _rect.position + _rect.size
	return not check_have_object(top.x,top.y) \
			and not check_have_object(top.x,bot.y) \
			and not check_have_object(bot.x,top.y) \
			and not check_have_object(bot.x,bot.y)


