tool
extends Node2D

class_name Dungeon

export var start_room_path:NodePath
export var start_room_coord:Vector2

var current_room_lock:Vector2
var current_room:Room
var previous_room:Room

export var camera:NodePath
export var room_list:Dictionary
export var chest_list:Dictionary
export var actor_list:Dictionary
export var door_list:Dictionary

var moving = false

func collect_save_info():
	var dungeon_info = {}
	dungeon_info["rooms"] = {}
	dungeon_info["chests"] = {}
	dungeon_info["doors"] = {}
	for room_id in room_list:
		dungeon_info["rooms"][room_id] = get_node(room_list[room_id]).collect_save_info()
	for chest_id in chest_list:
		dungeon_info["chests"][chest_id] = get_node(chest_list[chest_id]).collect_save_info()
	for door_id in door_list:
		dungeon_info["doors"][door_id] = get_node(door_list[door_id]).collect_save_info()
	return dungeon_info


func load_save_info(dungeon_info):
	var temp_room_list = dungeon_info.rooms
	var temp_chest_list = dungeon_info.chests
	var temp_door_list = dungeon_info.doors
	for room_id in temp_room_list:
		get_node(room_list[int(room_id)]).load_save_info(temp_room_list[room_id])
	for chest_id in temp_chest_list:
		get_node(chest_list[int(chest_id)]).load_save_info(temp_chest_list[chest_id])
	for door_id in temp_door_list:
		get_node(door_list[int(door_id)]).load_save_info(temp_door_list[door_id])



func prepare_room_bounds():
	var rooms = get_node("Rooms").get_children()
	for room in rooms:
		room.update_bounds()


func register_room_contents():
	var rooms = get_node("Rooms").get_children()
	for room in rooms:
		room.register_contents()
	print("Yo I have registered stuff")

func load_first_room():
	current_room.load_room()


func editor_register_element(element_dict, element_group):
	# Clear out all expired element paths
	for element_key in element_dict:
		if get_node(element_dict[element_key]) == null || element_dict[element_key].is_empty():
			element_dict.erase(element_key)
	
	# Update inaccurate element ids
	for element_key in element_dict:
		# If the element's ID doesn't match its key, we need to change its key
		if get_node(element_dict[element_key]).unique_id != element_key:
			var element_to_update = get_node(element_dict[element_key])
			var requested_id = element_to_update.unique_id
			# Make sure that the requested element key number isn't taken
			if !(requested_id in element_dict):
				# Store the path, erase the old key, add the new one
				var this_element_path = element_dict[element_key]
				element_dict.erase(element_key)
				element_dict[requested_id] = this_element_path
			# The current element key is already occupied
			else:
				print("ERROR: Can't update " + element_group + " " + get_path_to(element_to_update) + " because ID is occupied by " + element_dict[requested_id])
			pass
	
	# Add new elements 
	var all_elements = get_tree().get_nodes_in_group(element_group)
	var i = 0
	for element in all_elements:
		var element_path = get_path_to(element)
		
		# Element's current path is not in the list
		if !(element_path in element_dict.values()):
			
			# Element has no ID
			if element.unique_id == -1:
				while i in element_dict:
					i += 1
				element_dict[i] = element_path
				element.unique_id = i
			
			# Element has an unoccupied ID
			elif !(element.unique_id in element_dict):
				element_dict[element.unique_id] = element_path
				pass
			
			# Element has an occupied ID
			else:
				print("ERROR: New " + element_group + ": " + get_path_to(element) + " has its requested ID occupied by " + element_dict[element.unique_id])
				pass


func editor_register_rooms():
	editor_register_element(room_list, "room")


func editor_register_chests():
	editor_register_element(chest_list, "chest")


func editor_register_doors():
	editor_register_element(door_list, "door")


func _ready():
	if Engine.editor_hint:
		var new_camera = get_path_to(find_node("Camera2D"))
		if camera != new_camera:
			camera = new_camera
		
		editor_register_rooms()
		editor_register_chests()
		editor_register_doors()
			
			
	else:
		#current_room_lock = start_room_coord
		current_room = get_node(start_room_path)
		current_room.active = true
		
		var screen_size = Vector2(256, 208)
		Game.camera.current_camera_min = current_room.position
		Game.camera.current_camera_max = current_room.position - (current_room.size - screen_size)
		#var screen_size = Vector2(256, 208)
		#current_camera_max = -current_room.position
		#current_camera_min = -current_room.position - (current_room.size - screen_size)
		current_room.disable_player_collision()
		Game.current_dungeon = self


func _unhandled_input(event):
	if event.is_action_pressed("debug_room_down"):
		pass
	
	if event.is_action_pressed("debug_room_up"):
		pass
	pass


func figure_out_entry_direction(new_room:Room):
	var watson = Game.player
	var move_edge = 18
	print("Watson is at: " + String(watson.global_position))
	print("Room Bounds:") 
	var topy = new_room.global_position.y + move_edge
	var boty = new_room.global_position.y + new_room.size.y - move_edge
	var leftx = new_room.global_position.x + move_edge
	var rightx = new_room.global_position.x + new_room.size.x - move_edge
	print("Top Y=" + String(topy))
	print("Bot Y=" + String(boty))
	print("Left X=" + String(leftx))
	print("Right X=" + String(rightx))
	if watson.global_position.x < leftx:
		watson.global_position.x = leftx
	if watson.global_position.x > rightx:
		watson.global_position.x = rightx
	if watson.global_position.y < topy:
		watson.global_position.y = topy
	if watson.global_position.y > boty:
		watson.global_position.y = boty
	return


func change_rooms(new_room):
	moving = true
	Game.camera.moving = true
	
	var screen_size = Vector2(256, 208)
	figure_out_entry_direction(new_room)
	#position = -new_room.position
	new_room.load_room()
	previous_room = current_room
	current_room = new_room
	
	Game.camera.current_camera_max = current_room.position + (current_room.size - screen_size)
	Game.camera.current_camera_min = current_room.position
	#print("Current bounds are: " + String(current_camera_min) + " " + String(current_camera_max))
	#print("Current room is " + current_room.name)
	return


func _process(delta):
	if Engine.editor_hint:
		pass
	else:
		if moving:
			#Game.game_speed = Game.screen_transition_time
			#Game.lock_game_speed(self)
			#var screen_size = Vector2(256, 208)
			#var speed = 300
			#var new_camera = Vector2.ZERO
			#new_camera.x = clamp(-Game.player.position.x + (screen_size.x/2), current_camera_min.x, current_camera_max.x)
			#new_camera.y = clamp(-Game.player.position.y + (screen_size.y/2), current_camera_min.y, current_camera_max.y)
			#position = position.move_toward(new_camera, speed*delta)
			#if position == new_camera:
			#	Game.unlock_game_speed(self)
			#	Game.reset_game_speed()
			#	previous_room.unload_room()
			#	moving = false
			pass
		else:
			#var screen_size = Vector2(256, 208)
			#position.x = clamp(-Game.player.position.x + (screen_size.x/2), current_camera_min.x, current_camera_max.x)
			#position.y = clamp(-Game.player.position.y + (screen_size.y/2), current_camera_min.y, current_camera_max.y)
			pass
