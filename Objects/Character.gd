extends CharacterBody2D

class_name Character

# This class is abstract, and meant to be extended

# Direction enum
var Direction = Directions.Direction
const dir_strings = Directions.dir_strings

# Required Node Paths
@export var node_hurtbox:NodePath
@export var node_model:NodePath
@export var node_shadow:NodePath

# Required Nodes
var hurtbox:Area2D
var model:AnimatedSprite2D
var shadow:Sprite2D

# Identification
@export var uid:int = -1

# State
var is_dead = false
var is_loaded = false: set = set_loaded
var facing = Direction.DOWN
var altitude = 0
var prev_vertical_velocity = 0
var vertical_velocity = 0: set = set_vertical_velocity

var floor_shapes = []
var floor_height = 0

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
var current_health = 2: set = set_current_health

# Hitstun Stats
var dmg_knockback = 120

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
	if not Engine.is_editor_hint():
		_on_ready()
	else:
		_editor_on_ready()

func _physics_process(delta):
	if not Engine.is_editor_hint():
		if !Game.paused && !is_dead:
			delta = delta * Game.game_speed
			_on_physics_process(delta)
	else:
		_editor_on_physics_process(delta)

func _process(delta):
	if not Engine.is_editor_hint():
		if !Game.paused && !is_dead:
			delta = delta * Game.game_speed
			model.speed_scale = Game.game_speed
			_on_process(delta)
	else:
		_editor_on_process(delta)


func _editor_on_ready():
	pass

func _editor_on_physics_process(delta):
	pass

func _editor_on_process(delta):
	pass


func _on_ready():
	# Override properties
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	floor_stop_on_slope = false
	
	# GetNode Properties
	hurtbox = get_node(node_hurtbox)
	model = get_node(node_model)
	shadow = get_node(node_shadow)
	#print("Character Ready!")

func _on_physics_process(delta):
	if is_loaded:
		# Find the floor height
		update_floor_height()
		
		# Vertical Movement and Gravity
		if altitude > floor_height || (altitude <= floor_height && vertical_velocity > 0):
			set_vertical_velocity(vertical_velocity - gravity*delta)
		else:
			altitude = floor_height
			vertical_velocity = 0
			prev_vertical_velocity = 0
		altitude += (prev_vertical_velocity + vertical_velocity)/2*delta
		
		# Altitude Hit Detection
		hurtbox.altitude = altitude
		
		# Altitude Visual Location
		if model:
			model.position = Vector2(0, -altitude)
		if shadow:
			shadow.position = Vector2(0, -floor_height)
			
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
		
		hurtbox._on_physics_process(delta)
		
		#print(hurtbox.hitstun_timer)
		if hurtbox.hitstun_timer > 0:
			move_vector = Vector2.ZERO
			var knockback = (global_position - hurtbox.hit_source).normalized() * dmg_knockback
			move_vector = knockback
		_set_velocity(move_vector)
		move_and_slide()
		#if move_vector != Vector2.ZERO:
			#print(velocity)

func _set_velocity(value:Vector2):
	set_velocity(value * Game.game_speed)


func _on_process(delta):
	if is_loaded:
		# Update the facing direction
		var facing_dirs = []
		for direction in move_dirs:
			# If a direction is true and its opposite is not
			if move_dirs[direction] && !move_dirs[-direction]:
				# Add it to the list of possible facings
				facing_dirs.append(direction)
		if !facing_dirs.is_empty():
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


func set_loaded(new_val):
	is_loaded = new_val
	if is_loaded:
		model.play()
	else:
		model.pause()


func set_current_health(new_val):
	current_health = new_val
	if current_health <= 0:
		die()

func die():
	visible = false
	is_dead = true
	hurtbox.monitorable = false
	hurtbox.monitoring = false
	shape_owner_get_owner(0).disabled = true
	hurtbox.shape_owner_get_owner(0).disabled = true
	pass

func update_floor_height():
	var max_height = -16
	for bundle in floor_shapes:
		# if body is a tilemap
		if bundle.body.is_class("TileMap"):
			var tilemap:TileMap = bundle.body
			var body_rid:RID = bundle.body_rid
			#print("This rid: " + str(body_rid))
			#print("This rid's id: " + str(body_rid.get_id()))
			var coordinate: Vector2i = tilemap.get_coords_for_body_rid(body_rid)
			var data:TileData
			for i in tilemap.get_layers_count():
				data = tilemap.get_cell_tile_data(i, coordinate)
				#collides_with_tile(data, coordinate, tilemap)
				if data:
					var height = data.get_custom_data("height")
					if consider_height(height) and height > max_height:
						max_height = height
		elif bundle.body.is_class("StaticBody2D"):
			var body:StaticBody2D = bundle.body
			if consider_height(body.height) and body.height > max_height:
				max_height = body.height
			
	floor_height = max_height
	

func consider_height(height):
	if height > (altitude + 2):
		return false
	return true


func collides_with_tile(data:TileData, coordinate:Vector2i, tilemap:TileMap):
	var floor_detector:Area2D = get_node("FloorDetection")
	if floor_detector:
		var tile_collision_polygon_points:PackedVector2Array = PackedVector2Array(data.get_collision_polygon_points(1, 0))
		var local_coordinates:Vector2 = tilemap.map_to_local(coordinate)
		var global_coordinates:Vector2 = tilemap.to_global(local_coordinates)
		for i in tile_collision_polygon_points.size():
			tile_collision_polygon_points[i] += global_coordinates
			pass
		print(tile_collision_polygon_points)
		var test:Area2D = Area2D.new()
		
		var feet_rect = floor_detector.shape_owner_get_shape(0, 0).size
		print(floor_detector.global_position)
		print(feet_rect)
		pass
	else:
		return false
	pass


func is_grounded():
	return altitude <= floor_height
