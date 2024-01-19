extends Node2D

@export var speed_scale : float = 1
@export var time : float = 4
@export var content_height : float = 800


@onready var fences_content : int = 3 :
	set(value) :
		fences_content = value
		$groups/content.fence_content = value
		$groups/content2.fence_content = value

@onready var carrot_content : int = 3 :
	set(value) :
		carrot_content = value
		$groups/content.carrot_content = value
		$groups/content2.carrot_content = value
		
@onready var content_ready = $groups/content2

signal rabbit_out_of_zone(source)
signal rabbit_collide(source,target)

var _content_velocity : float :
	get : return content_height / time
	
func done_loop():
	swap_and_pooling_ground()
	pass

func swap_and_pooling_ground():
	var temp = $groups/content.position
	$groups/content.position  = $groups/content2.position
	$groups/content2.position = temp
	if content_ready == $groups/content 	: content_ready = $groups/content2
	else 					  	    		: content_ready = $groups/content
	
	content_ready.pooling()
	pass

func destroy_object(object):
	$groups/content.destroy_object(object)
	$groups/content2.destroy_object(object)
	pass
	
func restart():
	$groups/content.clear(true)
	$groups/content2.clear(true)
	if content_ready != null :
		content_ready.pooling()
	$groups.position.y = 0
	
func _process(delta):
	var move = _content_velocity * delta * speed_scale
	$groups.position.y = max(-content_height, $groups.position.y - move)
	if $groups.position.y <= -content_height:
		done_loop()
		$groups.position.y = 0
	pass

func _on_area_body_exited(body):
	if body is Rabbit and body.status != Rabbit.Status.KILL:
		rabbit_out_of_zone.emit(body)
		print("Rabbit is out of zone")
	pass # Replace with function body.
	
func _on_content_rabbit_collide(source, body):
	if body is Rabbit:
		rabbit_collide.emit(body,source)
		print("Collide %s %s" % [source,body])
	pass # Replace with function body.
