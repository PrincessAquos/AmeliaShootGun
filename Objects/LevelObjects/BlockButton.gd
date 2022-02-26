extends Area2D

class_name BlockButton
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var default_state

var is_activated = false setget set_activation_state

# Called when the node enters the scene tree for the first time.
func _ready():
	default_state = is_activated
	pass # Replace with function body.


func load_object():
	print("YO LOAD THE BUTTON")
	print(default_state)
	#yield(get_tree(), "physics_frame")
	set_activation_state(default_state)


func set_activation_state(new_state):
	is_activated = new_state
	var model = get_node("AnimatedSprite")
	if is_activated:
		model.animation = "Full"
	else:
		model.animation = "Empty"


func activate():
	is_activated = true
	


func _physics_process(delta):
	var colliders = get_overlapping_bodies()
	if !is_activated:
		for collider in colliders:
			if collider in get_tree().get_nodes_in_group("pushblock"):
				set_activation_state(true)
				collider.slot_in(self)
	pass
