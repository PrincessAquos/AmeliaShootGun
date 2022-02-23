tool
extends StaticBody2D

class_name Room

export var active:bool

export var size:Vector2

# Colliders
var collider:CollisionShape2D
#var shape:ConcavePolygonShape2D
var shape:RectangleShape2D


func enable():
	collider = shape_owner_get_owner(0)
	collider.disabled = false
	#for wall in walls:
	#	wall.monitoring = false
	

func disable():
	collider = shape_owner_get_owner(0)
	collider.disabled = true
	#for wall in walls:
	#	wall.monitoring = false

func update_collider_rect():
	collider = shape_owner_get_owner(0)
	shape = collider.shape
	collider.position = size/2
	shape.extents = size/2

func update_collider_concave():
	var points = [Vector2(0,0), Vector2(0, size.y), size, Vector2(size.x, 0)]
	var this_collider = get_node("EnemyBounds").shape_owner_get_owner(0)
	var this_shape = this_collider.shape
	
	this_shape.segments[0] = points[0] + Vector2(18, 18)
	
	this_shape.segments[1] = points[1] + Vector2(18, -18)
	this_shape.segments[2] = points[1] + Vector2(18, -18)
	
	this_shape.segments[3] = points[2] + Vector2(-18, -18)
	this_shape.segments[4] = points[2] + Vector2(-18, -18)
	
	this_shape.segments[5] = points[3] + Vector2(-18, 18)
	this_shape.segments[6] = points[3] + Vector2(-18, 18)
	
	this_shape.segments[7] = points[0] + Vector2(18, 18)
	
	#var top_shape = wall_top.shape_owner_get_shape(0, 0)
	#var bot_shape = wall_bot.shape_owner_get_shape(0, 0)
	#var left_shape = wall_left.shape_owner_get_shape(0, 0)
	#var right_shape = wall_right.shape_owner_get_shape(0, 0)
	
	#top_shape.a = points[0]
	#top_shape.b = points[3]
	
	#bot_shape.a = points[1]
	#bot_shape.b = points[2]
	
	#left_shape.a = points[0]
	#left_shape.b = points[1]
	
	#right_shape.a = points[2]
	#right_shape.b = points[3]
	return

# Called when the node enters the scene tree for the first time.
func _ready():
	#wall_top = get_node(wall_top_path)
	#wall_bot = get_node(wall_bot_path)
	#wall_left = get_node(wall_left_path)
	#wall_right = get_node(wall_right_path)
	#walls = [wall_top, wall_bot, wall_left, wall_right]
	update_collider_rect()
	update_collider_concave()
	if active:
		print(name + " is active")
		disable()
	else:
		enable()
	if not Engine.editor_hint:
		visible = false
	pass

func _process(delta):
	if Engine.editor_hint:
		#if wall_top == null:
		#	wall_top = get_node(wall_top_path)
		#	wall_bot = get_node(wall_bot_path)
		#	wall_left = get_node(wall_left_path)
		#	wall_right = get_node(wall_right_path)
		#	walls = [wall_top, wall_bot, wall_left, wall_right]
		if active:
			disable()
		else:
			enable()
		update_collider_rect()
		update_collider_concave()
	return
	
