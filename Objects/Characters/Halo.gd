extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Direction enum
var Direction = Directions.Direction
const dir_strings = Directions.dir_strings

var speed = 32

var current_direction = Direction.DOWN
var exist_time = 3

var exist_timer = 0

func instance_init(start_location, direction):
	position = start_location
	current_direction = direction
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	exist_timer = exist_time
	pass # Replace with function body.


func _physics_process(delta):
	delta = delta * Game.game_speed
	var move_by = delta * speed * Directions.dir_vectors[current_direction]
	position += move_by
	
	exist_timer -= delta
	if exist_timer <= 0:
		queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
