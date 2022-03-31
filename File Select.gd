extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currently_selected:int = 0

var file_rows = [
	"Margins/File List/File 1 Row",
	"Margins/File List/File 2 Row",
	"Margins/File List/File 3 Row"
]


func set_currently_selected(new_num_select):
	var old_watson_cursor = get_node(file_rows[currently_selected] + "/WatsonCursor")
	old_watson_cursor.visible = false
	new_num_select = posmod(new_num_select, 3)
	currently_selected = new_num_select
	print(currently_selected)
	var new_watson_cursor = get_node(file_rows[currently_selected] + "/WatsonCursor")
	new_watson_cursor.visible = true


func _unhandled_input(event):
	if event.is_action_pressed("move_up"):
		set_currently_selected(currently_selected - 1)
	if event.is_action_pressed("move_down"):
		set_currently_selected(currently_selected + 1)
	if event.is_action_pressed("move_jump") || event.is_action_pressed("shoot"):
		choose_current_file()
		pass
	pass


func choose_current_file():
	var chosen_file = get_node(file_rows[currently_selected] + "/File " + String(currently_selected + 1))
	chosen_file.choose()
	return


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
