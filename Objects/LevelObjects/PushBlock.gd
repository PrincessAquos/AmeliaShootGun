extends CharacterBody2D

@export var static_friction = 0.25
@export var push_speed = 25

var spawn_position

var push_timer = 0.0

var is_push = false
var push_direction = Vector2.ZERO

var is_slotted = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_position = position
	pass # Replace with function body.


func load_object():
	is_slotted = false
	position = spawn_position
	visible = true


func push(direction):
	is_push = true
	push_direction = direction
	pass


func slot_in(button):
	position = button.position
	is_slotted = true
	visible = false


func _physics_process(delta):
	var velocity = Vector2.ZERO
	if !is_slotted:
		if is_push:
			push_timer += delta * Game.game_speed
		else:
			push_timer = 0
		
		if push_timer > static_friction:
			velocity = push_direction * push_speed
		#print(linear_velocity)
		#Vector2
		is_push = false
		set_velocity(velocity * Game.game_speed)
		move_and_slide()
	pass
