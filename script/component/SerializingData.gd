extends Node
class_name SerializingData

func serializing_properties_name():
	var names = []
	var thisScript: GDScript = get_script()
	for propertyInfo in thisScript.get_script_property_list():
		var name = propertyInfo.name
		var first = name.left(1)
		if not propertyInfo.name in self \
			or first == "_":
			continue
		names.push_back(propertyInfo.name)
	return names

func serializing_properties():
	var datas = {}
	for name in self.serializing_properties_name():
		datas[name] = self.get(name)
	return datas

func set_serializing_properties(data: Dictionary):
	for key in data.keys():
		if key in serializing_properties_name():
			var value = data[key]
			if value is Array:
				print("VALUE %s is array" % key)
			self.set(key,data[key])

func save_local_file(path):
	if not FileAccess.file_exists(path):
		FileAccess.open(path,FileAccess.WRITE_READ)
		
	var file = FileAccess.open(path, FileAccess.WRITE)

	var data = serializing_properties()
	
	file.store_string(JSON.stringify(data))
	file.close()
	
	print("SAVE %s content %s" % [path,data])
	pass
	
func load_local_file(path):
	if not FileAccess.file_exists(path):
		FileAccess.open(path,FileAccess.WRITE_READ)
		
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	print("LOAD %s content = %s" % [path,content])
	var str = JSON.parse_string(content)
	if str != null and content != "":
		set_serializing_properties(JSON.parse_string(content))
