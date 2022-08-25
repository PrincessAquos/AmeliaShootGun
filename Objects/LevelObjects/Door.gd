extends StaticBody2D

class_name Door
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var node_trapped_path:NodePath
export var node_locked_path:NodePath
export var node_shut_collider_path:NodePath

var node_trapped:Node2D
var node_locked:Node2D
var node_shut_collider:CollisionShape2D

export var unique_id = -1
export var is_locked = false setget set_lock_state
export var is_trapped = false setget set_trap_state

var save_door:SaveData.SaveArea.SaveDoor setget load_save_info



func collect_save_info():
	var door_info = {}
	door_info["is_locked"] = is_locked
	return door_info


func load_save_info(new_save_door:SaveData.SaveArea.SaveDoor, is_loaded = true):
	save_door = new_save_door
	if is_loaded:
		set_lock_state(save_door.is_locked)
	else:
		save_door.is_locked = is_locked


# Called when the node enters the scene tree for the first time.
func _ready():
	node_trapped = get_node(node_trapped_path)
	node_locked = get_node(node_locked_path)
	node_shut_collider = get_node(node_shut_collider_path)
	
	node_locked.visible = is_locked
	node_trapped.visible = is_trapped
	update_shut_collision()
	pass # Replace with function body.

func set_lock_state(new_state):
	if node_locked == null:
		node_locked = get_node(node_locked_path)
	is_locked = new_state
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
