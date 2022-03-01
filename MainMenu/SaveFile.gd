extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var file_name:String = "NO DATA" setget set_file_name 
export var num_gears:int = 3 setget set_num_gears
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_file_name(new_name):
	file_name = new_name
	get_node("VBoxContainer/HBoxContainer/Filename").text = file_name


func set_num_gears(new_num_gears):
	num_gears = new_num_gears
	var healthbar = get_node("VBoxContainer/Health/HealthBar")
	healthbar.num_gears = num_gears
	healthbar.current_health = num_gears * 4
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
