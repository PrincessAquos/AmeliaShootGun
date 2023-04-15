extends Node

const debug_mode = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var do_time_warp = false

var locked_by = null
#var speed_locked = false

var physics_step_counter = 0
var do_load_step = false

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

var game_speed = 1: set = set_game_speed

var current_area_id
var current_dungeon = null
var inv_screen = null
var camera = null

var loaded_save = -1
var savepath = "/filepath/goes/here/"

var current_loaded_save:SaveData

var current_event = null

var player_num_gears = 3: set = set_num_gears
var player_current_health = 12: set = set_current_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_file_select():
	var file_select = load("res://File Select.tscn").instantiate()
	get_tree().current_scene.add_child(file_select)
	pass


func load_save_file(save_data:SaveData):
	current_loaded_save = save_data
	current_area_id = save_data.area_id
	load_new_area(save_data.area_id)
	inv_screen.load_save_info(current_loaded_save.inventory)
	set_num_gears(current_loaded_save.num_gears)
	set_current_health(current_loaded_save.num_gears * 4)
	pass


func load_new_area(area_id):
	# Free current dungeon scene
	# FREE CURRENT DUNGEON SCENE
	# FOR THE LOVE OF GOD YOU GOTTA CODE THAT IN EVENTUALLY
	
	# Add a new dungeon scene
	var instanced_dungeon = Areas.load_area(area_id)
	get_tree().current_scene.get_node("LevelView/SubViewport/nudge").add_child(instanced_dungeon)
	
	# Load save information
	current_loaded_save.area_id = area_id
	if area_id in current_loaded_save.areas:
		instanced_dungeon.save_area = current_loaded_save.areas[area_id]
	else:
		# Create a save area object for this area
		var new_save_area = SaveData.SaveArea.new()
		current_loaded_save.areas[area_id] = new_save_area
		instanced_dungeon.save_area = current_loaded_save.areas[area_id]
		pass
	
	if current_dungeon != null:
		print("Cool, the dungeon is there")
		await get_tree().physics_frame
		current_dungeon.prepare_room_bounds()
		await get_tree().physics_frame
		current_dungeon.register_room_contents()
		current_dungeon.load_save_info(current_loaded_save.areas[current_loaded_save.area_id])
		current_dungeon.load_first_room()
	if player != null:
		print("Cool, the player is there")
		player.is_loaded = true
		player.max_health = player_num_gears * 4
		player.current_health = player_current_health
	
	#physics_step_counter = 0
	#do_load_step = true
	pass


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
		inv_screen.position = Vector2(0, -216 * world_brightness)
	var layer_list = get_tree().get_nodes_in_group("layered")
	layer_list.sort_custom(Callable(DepthSorter, "high_y_low_z"))
	for i in range(layer_list.size()):
		layer_list[i].z_index = i


func _unhandled_input(event):
	
	if event.is_action_pressed("pause"):
		if current_event == null:
			if current_dungeon != null:
				if inv_screen != null && !menu_animation && (locked_by == self || locked_by == null):
					paused = !paused
					menu_animation = true
				
	if event.is_action_pressed("debug_save"):
		#print(to_json(current_loaded_save.get_dict()))
		#current_loaded_save.data[current_area_id] = current_dungeon.collect_save_info()
		#current_loaded_save.data["inventory"] = inv_screen.collect_save_info()
		#print(current_loaded_save.data)
		current_loaded_save.write_save()
	
	return


func set_num_gears(new_val):
	player_num_gears = new_val
	hud.num_gears = new_val

func set_current_health(new_val):
	player_current_health = new_val
	hud.current_health = new_val

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
	
