extends Pooling

enum Align{
	LEFT,
	RIGHT
}

@export var randomSize   : bool = true

@export var minimumWidth : int = 160
@export var maximumWidth : int = 240
@export var minimumHeight: int = 240
@export var maximumHeight: int = 360
@export var landSpacing  : int = -34

@export var heightRange  : int = 1244

@export var align 	     : Align :
	set(value) : 
		align = value
		if not self.is_node_ready():
			await self.ready
		_update_align(align)
		
## FUNCTION
func generateNumbersInRangeWithSum(r: int, a: int, b: int, m : int) -> Array:
	randomize()
	
	var resultList = []
	
	var remainingSum = r

	# Generate random numbers within the range and adjust them to match the required sum
	while remainingSum > 0:
		if remainingSum <= a:
			break
			
		var randomNumber = randi_range(a, b)  # Generate a random number between a and b
		
		# Ensure the generated number won't exceed the remaining sum
		if randomNumber > remainingSum:
			randomNumber = a
			resultList.append(randomNumber)
			remainingSum -= (a + m)
		else:
			# Add the generated number to the list and subtract it from the remaining sum
			resultList.append(randomNumber)
			remainingSum -= (randomNumber + m)
	
	var indexes = range(resultList.size())
	indexes.shuffle()
	
	for i in indexes:
		var inc = resultList[i] + remainingSum
		if inc < b:
			resultList[i] = inc
			remainingSum = 0
			break
		else:
			inc -= b
			resultList[i] += inc
			remainingSum -= inc
			
	if remainingSum > 0 and resultList.size() > 0:
		resultList[0] += remainingSum
	
	return resultList

func generate():
	if count > 0:
		self.models = []
		
	var heights = generateNumbersInRangeWithSum(heightRange,minimumHeight,maximumHeight,landSpacing)
	var _model = []
	
	for _height in heights:
		var _width = randi_range(minimumWidth,maximumWidth)
		var _item = {"genwidth" : _width, "genheight": _height}
		_model.push_back(_item)
		
	self.models = _model

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _update_data(node : Node, _data)-> void:
	var prev_ground = prev(node)
	
	var genwidth = _data["genwidth"]
	var genheight = _data["genheight"]

	if "land_size" in node:
		node.land_size = Vector2(genwidth,genheight)
	var xNode = 0
	var yNode = 0
	
	if align == Align.RIGHT:
		xNode = -genwidth
		
	if prev_ground != null:
		yNode = prev_ground.position.y + prev_ground.land_size.y + landSpacing
	node.position = Vector2(xNode,yNode)

func _update_align(_align) :
	for node in items():
		var genwidth = 0
		if not "land_size" in node:
			continue
		genwidth = node.land_size.x
		if align == Align.RIGHT:
			node.position.x = -genwidth 
		else:
			node.position.x = 0
	pass
