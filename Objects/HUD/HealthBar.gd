extends SubViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var num_gears : set = set_num_gears
var current_health : set = set_current_health

# Called when the node enters the scene tree for the first time.
func _ready():
	return

func set_num_gears(new_val):
	num_gears = new_val
	get_node("SubViewport/HealthBar/OverGears/UnderGears").num_gears = new_val


func set_current_health(new_val):
	current_health = new_val
	get_node("SubViewport/HealthBar/OverGears").current_health = current_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
