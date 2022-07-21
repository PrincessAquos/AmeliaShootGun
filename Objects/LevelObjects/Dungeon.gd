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


func _ready():
	if Engine.editor_hint:
		var new_camera = get_path_to(find_node("Camera2D"))
		if camera != new_camera:
			camera = new_camera
		
		# Clear out all expired room paths
		for room_key in room_list:
			if get_node(room_list[room_key]) == null || room_list[room_key].is_empty():
				room_list.erase(room_key)
		
		# Update inaccurate room ids
		for room_key in room_list:
			# If the room's ID doesn't match its key, we need to change its key
			if get_node(room_list[room_key]).room_id != room_key:
				var room_to_update = get_node(room_list[room_key])
				var requested_id = room_to_update.room_id
				# Make sure that the requested room key number isn't taken
				if !(requested_id in room_list):
					# Store the path, erase the old key, add the new one
					var this_room_path = room_list[room_key]
					room_list.erase(room_key)
					room_list[requested_id] = this_room_path
				# The current room key is already occupied
				else:
					print("ERROR: Can't update room " + get_path_to(room_to_update) + " because ID is occupied by " + room_list[requested_id])
				pass
		
		# Add new rooms 
		var all_rooms = get_tree().get_nodes_in_group("room")
		var i = 0
		for room in all_rooms:
			var room_path = get_path_to(room)
			
			# Room's current path is not in the list
			if !(room_path in room_list.values()):
				
				# Room has no ID
				if room.room_id == -1:
					while i in room_list:
						i += 1
					room_list[i] = room_path
					room.room_id = i
				
				# Room has an unoccupied ID
				elif !(room.room_id in room_list):
					room_list[room.room_id] = room_path
					pass
				
				# Room has an occupied ID
				else:
					print("ERROR: New room: " + get_path_to(room) + " has its requested ID occupied by " + room_list[room.room_id])
					pass
			
			
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
