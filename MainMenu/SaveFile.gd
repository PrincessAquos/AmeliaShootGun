extends MarginContainer

var savedata

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var file_num:int = 1 setget set_file_number
export var file_name:String = "NO DATA" setget set_file_name 
export var num_gears:int = 3 setget set_num_gears
# Called when the node enters the scene tree for the first time.
func _ready():
	savedata = SaveData.new(file_num-1)
	var data = savedata.data
	set_file_name(data["file_name"])
	set_num_gears(data["num_gears"])
	pass # Replace with function body.


func set_file_number(new_num):
	file_num = new_num
	get_node("VBoxContainer/HBoxContainer/File").text = "File " + String(file_num) + ":"


func set_file_name(new_name):
	file_name = new_name
	get_node("VBoxContainer/HBoxContainer/Filename").text = file_name


func set_num_gears(new_num_gears):
	num_gears = new_num_gears
	var healthbar = get_node("VBoxContainer/Health/HealthBar")
	healthbar.num_gears = num_gears
	healthbar.current_health = num_gears * 4


func choose():
	Game.load_save_file(file_num)
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
