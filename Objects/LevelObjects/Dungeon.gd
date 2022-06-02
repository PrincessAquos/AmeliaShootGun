extends Node2D

class_name Dungeon

export var start_room_path:NodePath
export var start_room_coord:Vector2

var current_room_lock:Vector2
var current_room:Room
var previous_room:Room

#var current_camera_min:Vector2
#var current_camera_max:Vector2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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


# Called when the node enters the scene tree for the first time.
func _ready():
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
	var t = TextEvent.new(self, "This is a test of text events")
	add_child(t)
	Game.play_event(t)


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
