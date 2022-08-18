extends Reference

class_name SaveData

const current_save_version = "0.0.3"

var file_name
var file_number = 0

var num_gears
var area_id

var areas = {
	Areas.DUNGEON_MANOR: SaveArea.new(),
	Areas.DUNGEON_DEBUG: SaveArea.new()
}

var inventory:SaveInventory


var data = null


var savepath = "user://"
var test_save_file_path = "user://test_save.save"


var formats = {
	"0.0.1": SaveFormat.new("0.0.1", ["test_num"]),
	"0.0.2": SaveFormat.new("0.0.2", ["test_num", "spawn_position"]),
	"0.0.3": SaveFormat.new("0.0.3", ["file_number", "file_name", "num_gears", "area_id"])
}


func _init(file_num):
	file_number = file_num
	var savefilepath = get_save_path(file_number)
	var save_game = File.new()
	if save_game.file_exists(savefilepath):
		save_game.open(savefilepath, File.READ)
		var data_json = save_game.get_line()
		data = parse_json(data_json)
		print(data)
		file_name = data["file_name"]
		num_gears = data["num_gears"]
		area_id = data["area_id"]
		for area in areas:
			SaveArea.new(data["areas"][area])
		inventory = SaveInventory.new(data["inventory"])
	else:
		file_name = "NO DATA"
		num_gears = 3
		area_id = "dungeon_manor"
		inventory = SaveInventory.new()
		data = parse_json("{}")
	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_save_path(file_num):
	var savefilepath = savepath + "savefile" + String(file_num) + ".sav"
	return savefilepath


func collect_data():
	return formats[current_save_version].collect_data_with_format()


func write_save():
	var savefilepath = get_save_path(file_number)
	var save_file = File.new()
	#var this_data = collect_data()
	#data = this_data
	var data_json = to_json(data)
	print(data_json)
	save_file.open(savefilepath, File.WRITE)
	save_file.store_line(data_json)
	save_file.close()
	pass

func read_save():
	var savefilepath = get_save_path(file_number)
	var save_game = File.new()
	save_game.open(savefilepath, File.READ)
	var data_json = save_game.get_line()
	var data = parse_json(data_json)
	print(data)
	print(data.version)
	print(typeof(data.version) == TYPE_STRING)
	return data


func get_dict():
	var save_dict = {}
	save_dict["file_name"] = file_name
	save_dict["file_number"] = file_number
	save_dict["num_gears"] = num_gears
	save_dict["area_id"] = area_id
	save_dict["areas"] = {}
	for area in areas:
		save_dict["areas"][area] = areas[area].get_dict()
	save_dict["inventory"] = inventory.get_dict()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

class SaveArea:
	var flags = {}
	var rooms = {}
	var chests = {}
	var doors = {}
	
	func _init(loaded_area:Dictionary = {}):
		flags = {}
		rooms = {}
		chests = {}
		doors = {}
		if !loaded_area.empty():
			for room_id in loaded_area["rooms"]:
				rooms[room_id] = SaveRoom.new(loaded_area["rooms"][room_id])
				
			for chest_id in loaded_area["chests"]:
				chests[chest_id] = SaveChest.new(loaded_area["chests"][chest_id])
			
			for door_id in loaded_area["doors"]:
				doors[door_id] = SaveDoor.new(loaded_area["doors"][door_id])
	
	func get_dict():
		var area_info = {}
		area_info["rooms"] = {}
		area_info["chests"] = {}
		area_info["doors"] = {}
		for room_id in rooms:
			area_info["rooms"][room_id] = rooms[room_id].get_dict()
		for chest_id in chests:
			area_info["chests"][chest_id] = chests[chest_id].get_dict()
		for door_id in doors:
			area_info["doors"][door_id] = doors[door_id].get_dict()
		return area_info
			
	
	
	class SaveRoom:
		var is_solved:bool
		
		func _init(loaded_room:Dictionary = {}):
			if !loaded_room.empty():
				is_solved = loaded_room["is_solved"]
			else:
				is_solved = false
		
		func get_dict():
			return {"is_solved": is_solved}
	
	class SaveChest:
		var is_closed:bool
		var is_active:bool
		func _init(loaded_chest:Dictionary = {}):
			if !loaded_chest.empty():
				is_closed = loaded_chest["closed"]
				is_active = loaded_chest["active"]
			else:
				is_closed = true
				is_active = false
		
		func get_dict():
			return {
				"closed": is_closed,
				"active": is_active
			}
	
	class SaveDoor:
		var is_locked:bool
		func _init(loaded_door:Dictionary = {}):
			if !loaded_door.empty():
				is_locked = loaded_door["is_locked"]
		
		func get_dict():
			return {"is_locked": is_locked}

class SaveInventory:
	var slots
	
	func _init(loaded_inventory:Array = []):
		slots = []
		if loaded_inventory.empty():
			for i in range(24):
				slots.append(SaveInventorySlots.new())
		else:
			for item in loaded_inventory:
				slots.append(SaveInventorySlots.new(item))
	
	func get_dict():
		var inventory_info = []
		for slot in slots:
			inventory_info.append(slot.get_dict())
	
	class SaveInventorySlots:
		var item_id
		var count
		
		func _init(loaded_item:Dictionary = {"item_id": null, "count": 0}):
			item_id = loaded_item.item_id
			if item_id == null:
				count = 0
			else:
				count = loaded_item.count
				
		func get_dict():
			return {
				"item_id": item_id,
				"count": count
			}

class SaveFormat:
	
	var version
	var keyname_ids
	
	func _init(ver, key_ids):
		version = ver
		keyname_ids = ["version"] + key_ids
		pass
	
	func collect_data_with_format():
		var dict = {}
		for key in keyname_ids:
			dict[key] = get_value_from_game(key)
		return dict
	
	func get_value_from_game(key):
		var value = "null"
		var spawn_vector = Vector2(6, 9)
		match key:
			"version":
				value = version
			"test_num":
				value = 8
			"file_number":
				value = Game.loaded_save
			"file_name":
				value = Game.get_savefile_name()
			"num_gears":
				value = 3
			"spawn_position":
				value = {"x": spawn_vector.x, "y": spawn_vector.y}
			"area_id":
				value = "dungeon_manor"
		return value


	func get_value_from_save(key):
		pass
