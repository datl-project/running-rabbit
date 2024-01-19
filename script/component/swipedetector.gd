extends Camera2D
class_name SwipeDetector

enum Direction{
	Horizontal,
	Vertical
}

@export var length 		:int = 100
@export var threshold 	: int = 5

var startPos : Vector2
var curPos : Vector2
var swiping = false

signal swipe(direction, distance)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("press"):
		if !swiping:
			swiping = true
			startPos = get_global_mouse_position()
			print("Start Position: ", startPos)
	if Input.is_action_pressed("press"):
		if swiping:
			curPos = get_global_mouse_position()
			if startPos.distance_to(curPos) >= length:
				if abs(startPos.y - curPos.y) <= threshold:
					var distance = curPos.distance_to (startPos)
					if curPos.x < startPos.x:
						distance = -distance
					print("Horizontal Swipe distance = %s" % distance)
					swipe.emit(Direction.Horizontal,distance)
					swiping = false
				elif abs(startPos.x - curPos.x) <= threshold:
					var distance = curPos.distance_to (startPos)
					print("Vertical Swipe distance = %s" % distance)
					swipe.emit(Direction.Vertical,distance)
					swiping = false
	else:
		swiping = false
	pass
	

