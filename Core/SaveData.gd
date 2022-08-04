extends Reference

class_name SaveData

const current_save_version = "0.0.3"

var file_number = 0
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
	else:
		data = null
	


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
