extends StaticBody2D

class_name Door
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var node_trapped_path:NodePath
@export var node_locked_path:NodePath
@export var node_shut_collider_path:NodePath

var node_trapped:Node2D
var node_locked:Node2D
var node_shut_collider:CollisionShape2D

@export var unique_id = -1
@export var is_locked = false: set = set_lock_state
@export var is_trapped = false: set = set_trap_state

var save_door:SaveData.SaveArea.SaveDoor: set = load_save_info


func collect_save_info():
	var door_info = {}
	door_info["is_locked"] = is_locked
	return door_info


func new_save_info():
	var new_save_door:SaveData.SaveArea.SaveDoor = SaveData.SaveArea.SaveDoor.new()
	new_save_door.is_locked = is_locked
	load_save_info(new_save_door)
	return new_save_door


func load_save_info(new_save_door:SaveData.SaveArea.SaveDoor):
	save_door = new_save_door
	set_lock_state(save_door.is_locked)


# Called when the node enters the scene tree for the first time.
func _ready():
	node_trapped = get_node(node_trapped_path)
	node_locked = get_node(node_locked_path)
	node_shut_collider = get_node(node_shut_collider_path)
	pass # Replace with function body.

func load_defaults():
	set_lock_state(is_locked)
	set_trap_state(is_trapped)
	update_shut_collision()
	pass


func set_lock_state(new_state):
	if node_locked == null:
		node_locked = get_node(node_locked_path)
	is_locked = new_state
	if save_door != null:
		save_door.is_locked = new_state
	node_locked.visible = is_locked
	update_shut_collision()
	

func set_trap_state(new_state):
	if node_trapped == null:
		node_trapped = get_node(node_trapped_path)
	is_trapped = new_state
	node_trapped.visible = is_trapped
	update_shut_collision()


func update_shut_collision():
	if node_shut_collider == null:
		node_shut_collider = get_node(node_shut_collider_path)
	node_shut_collider.disabled = !(is_locked || is_trapped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
