extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = false

var current_camera_min:Vector2
var current_camera_max:Vector2

const screen_size = Vector2(256, 208)
# Called when the node enters the scene tree for the first time.
func _ready():
	#var current_room = Game.dungeon.current_room
	#current_camera_max = current_room.position
	#current_camera_min = current_room.position + (current_room.size - screen_size)
	
	Game.camera = self
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		Game.game_speed = Game.screen_transition_time
		Game.lock_game_speed(self)
		var speed = 300
		var new_camera = Vector2.ZERO
		new_camera.x = clamp(Game.player.position.x - (screen_size.x/2), current_camera_min.x, current_camera_max.x)
		new_camera.y = clamp(Game.player.position.y - (screen_size.y/2), current_camera_min.y, current_camera_max.y)
		position = position.move_toward(new_camera, speed*delta)
		if position == new_camera:
			Game.unlock_game_speed(self)
			Game.reset_game_speed()
			moving = false
			Game.current_dungeon.moving = false
			Game.current_dungeon.previous_room.unload_room()
	else:
		var screen_size = Vector2(256, 208)
		position.x = clamp(Game.player.position.x - (screen_size.x/2), current_camera_min.x, current_camera_max.x)
		position.y = clamp(Game.player.position.y - (screen_size.y/2), current_camera_min.y, current_camera_max.y)
		pass
