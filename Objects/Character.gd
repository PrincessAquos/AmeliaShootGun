extends KinematicBody2D

class_name Character

# This class is abstract, and meant to be extended

# Direction enum
var Direction = Directions.Direction
const dir_strings = Directions.dir_strings

# Required Node Paths
export var node_hurtbox:NodePath
export var node_model:NodePath

# Required Nodes
var hurtbox:Area2D
var model:AnimatedSprite

# State
var facing = Direction.DOWN
var altitude = 0
var prev_vertical_velocity = 0
var vertical_velocity = 0 setget set_vertical_velocity

# Movement
var speed = 96
var jump_height = 16.0
var air_time = 0.8
var move_vector:Vector2 = Vector2(0, 0)
var lock_lateral_velocity = false

var move_dirs = {
	Direction.UP: false,
	Direction.DOWN: false,
	Direction.LEFT: false,
	Direction.RIGHT: false,
}

# Health
var max_health = 2
var current_health = 2 setget set_current_health

# Hitstun Stats
var dmg_knockback = 180

# ==== DO NOT TOUCH; IMPORTANT EQUATIONS ====
 # /////////////////////////////////////////////////////////////////////////////
 # | ~ Calculates gravity & jump speed to match desired jump height & air time 
 # | ~ This allows me to the fine tune the physics for gameplay purposes
 # /////////////////////////////////////////////////////////////////////////////
 #
 # The initial velocity of a jump
var jump_speed = 4*jump_height/air_time
 #
 # The acceleration due to gravity
var gravity = (8*jump_height) / (air_time * air_time)
 #
# ==== DO NOT TOUCH; IMPORTANT EQUATIONS ====

var terminal_velocity = jump_speed * 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_ready()

func _physics_process(delta):
	delta = delta * Game.game_speed
	_on_physics_process(delta)

func _process(delta):
	delta = delta * Game.game_speed
	model.speed_scale = Game.game_speed
	_on_process(delta)


func _on_ready():
	hurtbox = get_node(node_hurtbox)
	model = get_node(node_model)
	print("Character Ready!")

func _on_physics_process(delta):
	# Altitude Hit Detection
	hurtbox.altitude = altitude
	
	# Determine Movement Amount
	if !lock_lateral_velocity:
		move_vector = Vector2.ZERO
		if move_dirs[Direction.UP]:
			move_vector += Vector2(0, -speed)
		if move_dirs[Direction.DOWN]:
			move_vector += Vector2(0, speed)
		if move_dirs[Direction.LEFT]:
			move_vector += Vector2(-speed, 0)
		if move_dirs[Direction.RIGHT]:
			move_vector += Vector2(speed, 0)
	
	#print(hurtbox.hitstun_timer)
	if hurtbox.hitstun_timer > 0:
		move_vector = Vector2.ZERO
		var knockback = (global_position - hurtbox.hit_source).normalized() * dmg_knockback
		if Game.do_time_warp:
			knockback *= Game.game_speed
		move_and_slide(knockback)
	var real_move_vector = move_vector
	if Game.do_time_warp:
		real_move_vector *= Game.game_speed
	move_and_slide(real_move_vector)
	#if move_vector != Vector2.ZERO:
		#print(velocity)


func move_and_slide(linear_velocity: Vector2, up_direction: Vector2 = Vector2( 0, 0 ), stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398, infinite_inertia: bool = true):
	.move_and_slide(linear_velocity * Game.game_speed, up_direction, stop_on_slope, max_slides, floor_max_angle, infinite_inertia)
	pass


func _on_process(delta):
	# Update the facing direction
	var facing_dirs = []
	for direction in move_dirs:
		# If a direction is true and its opposite is not
		if move_dirs[direction] && !move_dirs[-direction]:
			# Add it to the list of possible facings
			facing_dirs.append(direction)
	if !facing_dirs.empty():
		if facing in facing_dirs:
			pass
		else:
			facing = facing_dirs[0]
	if hurtbox.hitstun_timer > 0:
		modulate = Color(1, 0, 0, 1)
	else:
		modulate = Color(1, 1, 1, 1)
	
	if hurtbox.damage_taken > 0:
		set_current_health(current_health - hurtbox.damage_taken)
		hurtbox.damage_taken = 0
	
	# Vertical Movement and Gravity
	if altitude > 0 || (altitude <= 0 && vertical_velocity > 0):
		set_vertical_velocity(vertical_velocity - gravity*delta)
	else:
		altitude = 0
		vertical_velocity = 0
		prev_vertical_velocity = 0
	altitude += (prev_vertical_velocity + vertical_velocity)/2*delta
	if model:
		model.position = Vector2(0, -altitude)
	# Update Sprite
	_update_sprite()
	return

func set_vertical_velocity(new_val):
	prev_vertical_velocity = vertical_velocity
	vertical_velocity = new_val

func moving():
	return move_dirs[Direction.UP] || move_dirs[Direction.DOWN] || move_dirs[Direction.LEFT] || move_dirs[Direction.RIGHT]

func _update_sprite():
	var new_anim = ""
	if vertical_velocity > 0:
		new_anim = "Ascend" + dir_strings[facing]
	elif vertical_velocity < 0:
		new_anim = "Descend" + dir_strings[facing]
	else:
		if moving():
			new_anim = "Run" + dir_strings[facing]
		else:
			new_anim = "Look" + dir_strings[facing]
	if new_anim != model.animation:
		#print("'" + model.animation + "' is not '" + new_anim + "'")
		#print("New Animation!")
		model.play(new_anim)


func set_current_health(new_val):
	current_health = new_val
	if current_health <= 0:
		die()

func die():
	queue_free()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
