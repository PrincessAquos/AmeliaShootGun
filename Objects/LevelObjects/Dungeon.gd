extends Node2D

export var start_room_path:NodePath
export var start_room_coord:Vector2

var current_room_lock:Vector2
var current_room:Room

var current_camera_min:Vector2
var current_camera_max:Vector2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_room_lock = start_room_coord
	current_room = get_node(start_room_path)
	current_room.active = true
	var screen_size = Vector2(256, 208)
	current_camera_max = -current_room.position
	current_camera_min = -current_room.position - (current_room.size - screen_size)
	current_room.disable()
	Game.current_dungeon = self


func _unhandled_input(event):
	if event.is_action_pressed("debug_room_down"):
		pass
	
	if event.is_action_pressed("debug_room_up"):
		pass
	pass


func change_rooms(new_room):
	moving = true
	var screen_size = Vector2(256, 208)
	#position = -new_room.position
	new_room.disable()
	var old_room = current_room
	current_room = new_room
	old_room.enable()
	current_camera_max = -current_room.position
	current_camera_min = -current_room.position - (current_room.size - screen_size)
	print("Current bounds are: " + String(current_camera_min) + " " + String(current_camera_max))
	print("Current room is " + current_room.name)
	pass


func _process(delta):
	if moving:
		Game.game_speed = Game.screen_transition_time
		Game.lock_game_speed(self)
		var screen_size = Vector2(256, 208)
		var speed = 300
		var new_camera = Vector2.ZERO
		new_camera.x = clamp(-get_node("Watson").position.x + (screen_size.x/2), current_camera_min.x, current_camera_max.x)
		new_camera.y = clamp(-get_node("Watson").position.y + (screen_size.y/2), current_camera_min.y, current_camera_max.y)
		position = position.move_toward(new_camera, speed*delta)
		if position == new_camera:
			Game.unlock_game_speed(self)
			Game.reset_game_speed()
			moving = false
	else:
		var screen_size = Vector2(256, 208)
		position.x = clamp(-get_node("Watson").position.x + (screen_size.x/2), current_camera_min.x, current_camera_max.x)
		position.y = clamp(-get_node("Watson").position.y + (screen_size.y/2), current_camera_min.y, current_camera_max.y)
		pass
