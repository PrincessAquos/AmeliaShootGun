extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var f_num = 0
var f_name = "a"
var game_data_format = {
	"version": SaveData.current_save_version,
	"file_number": f_num,
	"file_name": f_name,
	"num_gears": 3,
	"current_location":
		{
			"area_id": "dungeon_manor",
			"spawn_position": {
				"x": 0,
				"y": 0,
			},
		},
	"areas":
		{
			"dungeon_manor":
				{
					"opened_chests":
						[
							0, 3, 5,
						],
					"room_solved":
						[
							2, 5,
						],
					"enemy_defeated":
						[
							12, 13,
						],
					"unlocked_doors":
						[
							4, 6,
						],
					"flags":
						[
							1
						]
				},
		},
	"inventory":
		{
			0:
				{
					"item_id": 0,
					"count": 0,
				},
		},
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
