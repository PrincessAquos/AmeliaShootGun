extends Node

const debug_mode = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var do_time_warp = false

var locked_by = null
#var speed_locked = false

var physics_step_counter = 0
var do_load_step = true

var hud
var player

var bullet_time = 0.35
var screen_transition_time = 0
var warp_time_by = 1

var menu_animation = false
var paused = false
var menu_alpha = 0
var world_brightness = 255
var menu_anim_timer = 0.0
var menu_anim_time = 0.5

var game_speed = 1 setget set_game_speed

var current_dungeon = null
var inv_screen = null
var camera = null

var loaded_save = -1
var savepath = "/filepath/goes/here/"

var current_event = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_file_select():
	var file_select = load("res://File Select.tscn").instance()
	get_tree().current_scene.add_child(file_select)
	pass


func load_save_file(save_data:SaveData):
	var data = save_data.data
	load_new_area(data["area_id"])
	pass


func load_new_area(area_id):
	var instanced_dungeon = Areas.load_area(area_id)
	get_tree().current_scene.get_node("LevelView/Viewport/nudge").add_child(instanced_dungeon)
	# Free current dungeon scene
	# Add a new dungeon scene
	physics_step_counter = 0
	do_load_step = true
	pass


func _load():
	print(get_tree().get_node_count())
	if current_dungeon != null:
		current_dungeon.prepare_room_bounds()
		yield(get_tree(), "physics_frame")
		current_dungeon.register_room_contents()
		current_dungeon.load_first_room()
	if player != null:
		player.is_loaded = true
	return


func play_event(event):
	current_event = event
	paused = true
	current_event.trigger()
	pass


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
	if current_event != null:
		if current_event.complete:
			current_event.ack()
			current_event = null
			paused = false
	
	if menu_animation:
		if paused:
			menu_anim_timer += delta
			if menu_anim_timer > menu_anim_time:
				menu_anim_timer = menu_anim_time
				menu_animation = false
		else:
			menu_anim_timer -= delta
			if menu_anim_timer < 0:
				menu_anim_timer = 0
				menu_animation = false
		world_brightness = (menu_anim_time - menu_anim_timer)/menu_anim_time
		menu_alpha = menu_anim_timer/menu_anim_time
		current_dungeon.modulate = Color(world_brightness, world_brightness, world_brightness, 1)
		#inv_screen.modulate = Color(1, 1, 1, menu_alpha)
		inv_screen.rect_position = Vector2(0, -216 * world_brightness)
	var layer_list = get_tree().get_nodes_in_group("layered")
	layer_list.sort_custom(DepthSorter, "high_y_low_z")
	for i in range(layer_list.size()):
		layer_list[i].z_index = i

func _physics_process(delta):
	if do_load_step:
		do_load_step = false
		_load()


func _unhandled_input(event):
	
	if event.is_action_pressed("pause"):
		if current_event == null:
			if current_dungeon != null:
				if inv_screen != null && !menu_animation && (locked_by == self || locked_by == null):
					paused = !paused
					menu_animation = true
				
	return


func update_hud_health(num_gears, current_health):
	hud.num_gears = num_gears
	hud.current_health = current_health
	return


func get_savefile_name():
	if loaded_save != -1:
		var savefilepath = savepath + "savefile" + String(loaded_save) + ".sav"
		# Open the save file
		# Read the filename field
		# return the filename field
	return null


func save():
	var savefilepath = savepath + "savefile" + String(loaded_save) + ".sav"
	var save_dict = {
		# What to name the file on the file select screen
		"filename": get_savefile_name(),
		
		# First cutscene
		"intro_complete": false,
		
		# What area to load upon selecting the file
		"current_area": "MisteavousManor",
		
		# Where to spawn the character. 
		# If the current area is a dungeon, this will be ignored
		"spawn_position": Vector2(0, 0),
		
		# Equipped item
		"equipped_id" : -1,
		
		# The number of gears in the player health bar
		"num_gears": 3,
		
		# The contents of the player's inventory
		"inventory": [
			# Each item will have this format
			{
				"item_id": -1,
				"quantity": -1
			}
		],
		
		# Progress through dungeons
		# Opened chests, unlocked doors, boss state
		"dungeon_flags": {
			"MisteavousManor": {
				"chests": [],
				"locked_doors": [],
				"boss_defeated": false
			}
		}
	}
	return


class DepthSorter:
	static func high_y_low_z(a, b):
		if a.global_position.y < b.global_position.y:
			return true
		return false
	
