extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var save_data

func create_save_file(f_num, f_name):
	var save_data = {
		"version": SaveData.current_save_version,
		"file_number": f_num,
		"file_name": f_name,
		"num_gears": 3,
		"area_id": "dungeon_manor",
		"spawn_position": {}
	}
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var test = "fu"
	var value
	match(test):
		"version":
			value = SaveData.current_save_version
		"test_num":
			value = 8
		"file_number":
			value = Game.loaded_save
		"file_name":
			value = Game.get_savefile_name()
		"num_gears":
			value = 3
		"spawn_position":
			value = {"x": 6, "y": 9}
		"area_id":
			value = "dungeon_manor"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
