extends Node2D
class_name Spawner

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var node := NodePath()

@export var delegate  : PackedScene
@export var models    : Array : 
	set(value) :
		_model = value
		if not self.is_node_ready():
			await self.ready
		for node in _nodes:
			_despawn(node)
			despawned.emit(node)
		_nodes.clear()
		for item in models:
			if item == null:
				_spawn({})
			else:
				_spawn(item)
		_done()
		spawned_model.emit()
		
	get:
		return _model

@onready var container: Node = get_node(node)

var  	count     : int : 
	get : 
		return _nodes.size()

var     _nodes    : Array[Node]
var 	_model 	  : Array

signal spawned(node)
signal despawned(node)
signal spawned_model()

func spawn(item : Dictionary = {}) -> Node:
	_model.push_back(item)
	return _spawn(item)
	
func despawn(node : Node):
	var i = _despawn(node)
	if i >= 0 :
		_nodes.remove_at(i)
		despawned.emit(node)
		
func index_of(node : Node) -> int:
	return _nodes.find(node)

func item(index : int) -> Node:
	if index < 0 or index >= _nodes.size() :
		return null
	return _nodes[index]
	
func items() -> Array[Node]:
	return _nodes

func has(node : Node) -> bool:
	return _nodes.has(node)

func for_each(call : Callable) -> void :
	for node in _nodes:
		call.call(node)
	return
	
func finds_if(call : Callable) -> Array:
	var result := []
	for node in _nodes:
		if call.call(node):	result.push_back(node)
	return result

## INTERFACE
func _spawn(item: Dictionary) -> Node:
	if delegate == null:
		return null
	var inst = delegate.instantiate()
	if item != null:
		for key in item.keys():
			for prop in inst.get_property_list():
				if prop.has("name") and prop["name"] == key :
					inst.set(key,item[key])
				
	var _container = container
	
	if _container == null:
		_container = self
		
	_container.add_child(inst)
	_nodes.push_back(inst)
	
	spawned.emit(inst)
	return inst

func _despawn(node : Node) -> int:
	if node == null:
		return -1
	var i = _nodes.find(node)
	if i < 0:
		return -1
	node.queue_free()

	return i

func _done() -> void:
	pass

func _ready() -> void:
	pass
