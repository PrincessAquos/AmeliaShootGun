extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var do_time_warp = false

var locked_by = null
#var speed_locked = false

var hud
var player

var bullet_time = 0.35
var screen_transition_time = 0
var warp_time_by = 1

var game_speed = 1 setget set_game_speed

var current_dungeon = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate_bullet_time():
	set_game_speed(bullet_time)

func deactivate_bullet_time():
	reset_game_speed()

func set_game_speed(new_speed):
	if locked_by == null:
		game_speed = new_speed

func lock_game_speed(object):
	locked_by = object

func unlock_game_speed(object):
	if object == locked_by:
		locked_by = null

func reset_game_speed():
	set_game_speed(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var layer_list = get_tree().get_nodes_in_group("layered")
	layer_list.sort_custom(DepthSorter, "high_y_low_z")
	for i in range(layer_list.size()):
		layer_list[i].z_index = i


func update_hud_health(num_gears, current_health):
	hud.num_gears = num_gears
	hud.current_health = current_health
	return


class DepthSorter:
	static func high_y_low_z(a, b):
		if a.global_position.y < b.global_position.y:
			return true
		return false
	
