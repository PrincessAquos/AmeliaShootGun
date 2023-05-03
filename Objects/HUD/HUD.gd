extends Control

class_name HUD

var num_gears : set = set_num_gears
var current_health : set = set_current_health

@export var healthbar_node_path:NodePath
@export var textbox_node_path:NodePath
var healthbar_node
var textbox_node:TextBox

func _ready():
	Game.hud = self
	healthbar_node = get_node(healthbar_node_path)
	textbox_node = get_node(textbox_node_path)
	pass # Replace with function body.


func new_textbox(title, dialogue):
	textbox_node.initialize(title, dialogue)
	return textbox_node


func set_num_gears(new_val):
	num_gears = new_val
	healthbar_node.num_gears = new_val


func set_current_health(new_val):
	current_health = new_val
	healthbar_node.current_health = current_health
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
