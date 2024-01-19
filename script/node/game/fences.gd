extends Pooling

@export  var generating_number  : int = 2
@export  var vertial_spacing    : int = 100


var _vertical_line : int :
	get: return $"..".rect.size.y / vertial_spacing 

func rect_of_fence_at(_x,_y) -> Rect2:
	var x = Fence.rect.position.x + _x
	var y = Fence.rect.position.y + _y
	return Rect2(Vector2(x,y),Fence.rect.size)

func get_unused_position(overlapping_list):
	randomize()
	for i in range(100):
		var _x = $"..".rect.position.x + randi_range(0,$"..".rect.size.x)
#		var _y = rect.position.x + randi_range(0,rect.size.y)
		var _y = randi_range(0,_vertical_line - 1) * vertial_spacing
		var _rect  = rect_of_fence_at(_x,_y)
		if $"..".check_unused_rect(_rect) :
			var intersect = false
			for rect in $"..".rect_occupied:
				intersect = rect.intersects(_rect) or intersect
			if not intersect:
				return Vector2(_x,_y)
	return null
func clear():
	pass
	
func generate():
	if count > 0:
		self.models = []
	var _models : Array = []
	var _list   : Array = []
	for i in range(generating_number):
		var pos = get_unused_position(_list)
		if pos != null:
			$"..".rect_occupied.push_back(rect_of_fence_at(pos.x,pos.y))
			_models.push_back({"posx" : pos.x,"posy": pos.y})
			_list.push_back(pos)
		else:
			print("CANT GEN %s" % i)
	self.models = _models
	pass
	
func _ready():
	pass

func _update_data(node : Node, item)-> void:
	node.position.x = item["posx"]
	node.position.y = item["posy"]
