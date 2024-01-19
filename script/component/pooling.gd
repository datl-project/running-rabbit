extends Node2D
class_name Pooling

@export var node := NodePath()

@export var delegate  : PackedScene
@export var models    : Array :
	set(value) :
		_model = value
		if not self.is_node_ready():
			await self.ready
		var _max = max(_model.size(),_nodes.size())
		for i in range(_max):
			if i < _model.size() and i < _nodes.size():
				_active(_nodes[i])
				_update_data(_nodes[i],_model[i])
				spawned.emit(_nodes[i])
			elif i >= _model.size() and i < _nodes.size():
				_deactive(_nodes[i])
			elif i < _model.size() and i >= _nodes.size():
				_pooling()
				_update_data(_nodes[_nodes.size() - 1],_model[i])
				spawned.emit(_nodes[_nodes.size() - 1])
		updated.emit()
		_done()
			
@onready var container: Node = get_node(node)

signal updated()
signal pooling_node(node)
signal spawned(node)

var     _nodes    	: Array[Node]
var  	_activated  : Array[Node]
var 	_model 	  	: Array

var  	count     : int :
	get : return items().size()
	
func _deactive(node : Node) -> void:
	if node is Node2D or node is Control:
		node.visible = false
	node.process_mode = Node.PROCESS_MODE_DISABLED
	pass
	
func _active(node : Node) -> void:
	if node is Node2D or node is Control:
		node.visible = true
	node.process_mode = Node.PROCESS_MODE_INHERIT

	pass
	
func _pooling() -> void:
	if delegate == null:
		return
	var inst = delegate.instantiate()
	var _container = container
	if _container == null:
		_container = self
	_container.add_child(inst)
	_nodes.push_back(inst)
	pooling_node.emit(inst)

func _update_data(_node : Node, _data)-> void:
	if _nodes == null or _data == null:
		print("[Error] Cannot update data node[%s] data[%s]"%[_node,_data])
		return
		
	for key in _data.keys():
		for prop in _node.get_property_list():
			if prop.has("name") and prop["name"] == key :
				_node.set(key,_data[key])
	pass

func index_of(node : Node) -> int:
	return _nodes.find(node)

func item(index : int, contain_deactive : bool = false) -> Node:
	if index < 0 or index >= items(contain_deactive).size() :
		return null
	return items(contain_deactive)[index]
	
func items(contain_deactive : bool = false) -> Array[Node]:
	if contain_deactive:
		return _nodes
	else :
		var list : Array[Node] = []
		for _n in _nodes:
			if is_active(_n):
				list.push_back(_n)
		return list

func is_active(node : Node) -> bool:
	return node.process_mode != Node.PROCESS_MODE_DISABLED

func has(node : Node , contain_deactive : bool = false) -> bool:
	return items(contain_deactive).has(node)

func for_each(call : Callable , contain_deactive : bool = false) -> void :
	for node in items(contain_deactive):
		call.call(node)
	return
	
func finds_if(call : Callable , contain_deactive : bool = false) -> Array:
	var result := []
	for node in items(contain_deactive):
		if call.call(node):	result.push_back(node)
	return result

func prev(node : Node, distance : int = 1, contain_deactive : bool = false) -> Node:
	if not _nodes.has(node) :
		return null
	var lst = items(contain_deactive)
	var index = lst.find(node)
	if (index - distance) < 0 or (index - distance) >= lst.size():
		return null
	return lst[index - distance]

func next(node : Node, distance : int = 1, contain_deactive : bool = false) -> Node:
	if not _nodes.has(node) :
		return null
	var lst = items(contain_deactive)
	var index = lst.find(node)
	if (index + distance) < 0 or (index + distance) >= lst.size():
		return null
	return lst[index + distance]

func last(contain_deactive : bool = false) -> Node:
	var lst = items(contain_deactive)
	if lst.size() <= 0:
		return null
	return lst[lst.size() - 1]

func first(contain_deactive : bool = false) -> Node:
	var lst = items(contain_deactive)
	if lst.size() <= 0:
		return null
	return lst[0]

func _done() -> void:
	pass

#OVERLOADING "SPAWNER" FUNCTION
func spawn(item : Dictionary = {}):
	var index
	var node
	if _nodes.size() > _model.size():
		print("active node")
		_active(_nodes[_model.size()])
		index = _model.size()
	else:
		print("pooling node")
		_pooling()
		index = _nodes.size() - 1
	node = _nodes[index]
	_active(_nodes[index])
	_update_data(_nodes[index],item)
	_model.push_back(item)
	spawned.emit(node)
	updated.emit()
	return node

func despawn(node : Node):
	if not node in items():
		return
	_deactive(node)
	_nodes.remove_at(_nodes.find(node))
	_nodes.push_back(node)
	updated.emit()
	pass
