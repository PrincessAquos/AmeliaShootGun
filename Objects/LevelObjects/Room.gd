@tool
extends StaticBody2D

class_name Room

@export var active:bool
@export var trapped:bool
#export (Array, NodePath) var doorways
@export var node_room_bounds_path:NodePath
@export var node_enemy_bounds_path:NodePath

@export var size:Vector2: set = change_size
@export var unique_id:int = -1

var finished_registering = false
var node_room_bounds:Area2D = null
var node_enemy_bounds:StaticBody2D = null
# Colliders
var collider:CollisionShape2D
#var shape:ConcavePolygonShape2D
var shape:RectangleShape2D

var chests:Array = []
var doorways:Array = []
var actors:Array = []
var blocks:Array = []
var buttons:Array = []

var solve_func:Callable
var is_solved = false

var save_room:SaveData.SaveArea.SaveRoom


func collect_save_info():
	var room_info = {}
	room_info["is_solved"] = is_solved
	return room_info


func load_save_info(new_save_room:SaveData.SaveArea.SaveRoom, is_loaded = true):
	save_room = new_save_room
	if is_loaded:
		is_solved = new_save_room.is_solved
	else:
		new_save_room.is_solved = is_solved
	if is_solved:
		room_solved()


# Called when the node enters the scene tree for the first time.
func _ready():
	#wall_top = get_node(wall_top_path)
	#wall_bot = get_node(wall_bot_path)
	#wall_left = get_node(wall_left_path)
	#wall_right = get_node(wall_right_path)
	#walls = [wall_top, wall_bot, wall_left, wall_right]
	solve_func = Callable(RoomSolutions, "all_enemies_defeated")
	node_room_bounds = get_node(node_room_bounds_path)
	node_enemy_bounds = get_node(node_enemy_bounds_path)
	if Engine.is_editor_hint():
		update_collider_rect()
		update_collider_concave()
		if active:
			disable_player_collision()
		else:
			enable_player_collision()
	if not Engine.is_editor_hint():
		visible = false
	pass


func update_bounds():
	update_collider_rect()
	update_collider_concave()


func register_contents():
	register_objects()


func enable_player_collision():
	collider = shape_owner_get_owner(0)
	collider.disabled = false
	#for wall in walls:
	#	wall.monitoring = false
	

func disable_player_collision():
	collider = shape_owner_get_owner(0)
	collider.disabled = true
	#for wall in walls:
	#	wall.monitoring = false


func unload_room():
	enable_player_collision()
	unload_actors()
	pass


func load_room():
	disable_player_collision()
	load_actors()
	if trapped:
		for doorway in doorways:
			doorway.is_trapped = true
	for chest in chests:
		if !chest.active:
			chest.deactivate()
	for block in blocks:
		block.load_object()
	for button in buttons:
		button.load_object()
	pass


func register_objects():
	actors.clear()
	doorways.clear()
	var possible_objects = node_room_bounds.get_overlapping_bodies()
	for object in possible_objects:
		if object in get_tree().get_nodes_in_group("enemy"):
			print(object)
			actors.append({"actor": object, "spawn_position": object.position})
		elif object in get_tree().get_nodes_in_group("door"):
			doorways.append(object)
		elif object in get_tree().get_nodes_in_group("chest"):
			chests.append(object)
		elif object in get_tree().get_nodes_in_group("pushblock"):
			blocks.append(object)
		elif object in get_tree().get_nodes_in_group("button"):
			buttons.append(object)
	finished_registering = true
	return


func load_actors():
	for actor in actors:
		actor.actor.position = actor.spawn_position
		actor.actor.is_loaded = true
	return


func unload_actors():
	for actor in actors:
		actor.actor.is_loaded = false
	return


func update_collider_rect():
	if node_room_bounds != null:
		var area_collider = node_room_bounds.shape_owner_get_owner(0)
		collider = shape_owner_get_owner(0)
		shape = RectangleShape2D.new()
		collider.position = size/2
		shape.size = size
		collider.shape = shape
	
		area_collider.position = size/2
		area_collider.shape = shape

func update_collider_concave():
	if node_enemy_bounds != null:
		var points = [Vector2(0,0), Vector2(0, size.y), size, Vector2(size.x, 0)]
		var this_collider = node_enemy_bounds.shape_owner_get_owner(0)
		
		this_collider.polygon = [
			points[0] + Vector2(18, 18),
			points[1] + Vector2(18, -18),
			points[2] + Vector2(-18, -18),
			points[3] + Vector2(-18, 18),
			points[0] + Vector2(18, 18),
			points[0] + Vector2(20, 20),
			points[3] + Vector2(-20, 20),
			points[2] + Vector2(-20, -20),
			points[1] + Vector2(20, -20),
			points[0] + Vector2(20,20)
		]
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

func _unhandled_input(event):
	if event.is_action_pressed("debug_register_actors"):
		register_objects()
	elif event.is_action_pressed("debug_load_actors"):
		load_actors()
	elif event.is_action_pressed("debug_unload_actors"):
		unload_actors()
	pass


func change_size(new_size):
	size = new_size
	if Engine.is_editor_hint():
		update_collider_rect()
		update_collider_concave()
	pass


func room_solved():
	save_room.is_solved = true
	trapped = false
	for door in doorways:
		door.is_trapped = false
	for chest in chests:
		chest.active = true
		chest.activate()
	pass


func _process(delta):
	if not Engine.is_editor_hint():
		if finished_registering:
			if !is_solved:
				if solve_func.call(self):
					room_solved()
					is_solved = true
	
	if Engine.is_editor_hint():
		#if wall_top == null:
		#	wall_top = get_node(wall_top_path)
		#	wall_bot = get_node(wall_bot_path)
		#	wall_left = get_node(wall_left_path)
		#	wall_right = get_node(wall_right_path)
		#	walls = [wall_top, wall_bot, wall_left, wall_right]
		if active:
			disable_player_collision()
		else:
			enable_player_collision()
	return
	
