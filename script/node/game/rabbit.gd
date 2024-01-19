extends CharacterBody2D
class_name Rabbit

# ENUM
enum Direction  { NORTH,EAST,   SOUTH, WEST}
enum Status 	{ INIT,	RUNNING,KILL}

# PROPERTY
@export var speed = 40  # Set the snake's movement speed
@export var spacing = 50
@export var vertical_maximum_speed = 60

# PROPERTY
var target : Vector2
var status : Status = Status.INIT

# PROPERTY
var direction: Direction = Direction.NORTH :
	set(dir) :
		if dir != direction:
			direction = dir
			play_animation()

#READ-ONLY PROPERTY
var container : Rabbits:
	get : return get_parent() as Rabbits
	
# FUNCTION
func direct_to(_position):
	var direction = (self.position - _position).normalized()
	var angle = atan2(direction.y, direction.x)
	angle += PI / 2
	
	var degrees = rad_to_deg(angle)
	var dir = Direction.NORTH
	
	if degrees >= -70 && degrees < 70:
		dir = Direction.SOUTH
	elif degrees >= 70 && degrees < 110:
		dir = Direction.WEST
	elif degrees >= 110 || degrees < -110:
		dir = Direction.NORTH
	else:
		dir = Direction.EAST


	
	return dir

func rotating_sprite_to(_position):
	# Get the direction vector from the node to the mouse position
	var direction = ($sprite.position - _position).normalized()
	# Calculate the angle between the bottom of the Node2D and the mouse position
	var angle = atan2(direction.y, direction.x)
	# Rotate the node to face the mouse position
	$sprite.rotation = angle + PI / 2 # Adding PI/2 adjusts the rotation based on the Node2D's local space
	pass

func play_animation():
	match direction:
		Direction.NORTH:  $sprite.play("rabbit_south")
		Direction.SOUTH:  $sprite.play("rabbit_south")
		Direction.EAST :  $sprite.play("rabbit_east")
		Direction.WEST :  $sprite.play("rabbit_west")
	pass
	
func follow(delta,to_position,head_position):
	var maximum_y = 120
	var target = to_position
	var sp   = speed 
	
	var main = container.main_rabbit
	
	if status == Status.INIT and main != self:
		var _direction = (main.position + Vector2(0,spacing)) - self.position
		_direction = _direction.normalized() * spacing
		self.velocity = Vector2.ZERO.lerp(main.position  - _direction - self.position, (sp + 60)  * delta) 
		
	else:
		if target == null or get_parent() == null:
			return
		var _vel     = target - self.position
		var _vel_dir = _vel.normalized()
		var _desired_postition = target - _vel_dir * (get_index() + 1) * spacing
	
		var _desired_vel = _desired_postition - self.position

		var _vel_x = Vector2.ZERO.lerp(Vector2(_desired_vel.x,0),sp * delta)
		var _vel_y = Vector2(0,min(_desired_vel.y,vertical_maximum_speed))

		self.velocity = (_vel_x + _vel_y)

	self.move_and_slide()
	direction = direct_to(target)
	#if direction == Direction.SOUTH or direction == Direction.NORTH :
		#rotating_sprite_to(head_position)
	#else:
	#$sprite.rotation = 0
			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow(delta,target,target + Vector2(0,200))
	pass

func _is_spawned(reason):
	status = Status.INIT
	if reason == "spawned" :
		$animation.play("iframe")
		await $animation.animation_finished
	status = Status.RUNNING
	pass	

func _exit_tree():
	status = Status.KILL

func _start_iframe():
	$".".set_collision_mask_value(1,false)
	$".".set_collision_mask_value(2,false)
	$".".set_collision_mask_value(3,false)
	
func _end_iframe():
	$".".set_collision_mask_value(1,true)
	$".".set_collision_mask_value(2,true)
	$".".set_collision_mask_value(3,true)
