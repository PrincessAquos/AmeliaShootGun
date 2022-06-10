extends Control


var num_gears setget set_num_gears
var current_health setget set_current_health


func _ready():
	Game.hud = self
	pass # Replace with function body.


func set_num_gears(new_val):
	num_gears = new_val
	get_node("MarginContainer/HealthBar").num_gears = new_val


func set_current_health(new_val):
	current_health = new_val
	get_node("MarginContainer/HealthBar").current_health = current_health
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
