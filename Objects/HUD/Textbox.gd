extends Control

class_name TextBox


const textbox_scene = preload("res://Objects/HUD/Textbox.tscn")

const nodepath_title = "Textbox/Control3/MarginContainer2/MarginContainer/Name"
const nodepath_dialogue = "Textbox/Control/MarginContainer/Control/Dialogue"

var title setget set_title
var dialogue
var lines
var dismiss_text = false

func _init(in_title, in_dialogue):
	set_anchors_preset(Control.PRESET_WIDE)
	add_child(textbox_scene.instance())
	set_title(in_title)
	set_dialogue(in_dialogue)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_title(new_val):
	if new_val != null:
		get_node(nodepath_title).text = new_val
		title = new_val
	else:
		get_node("Textbox/Control3").visible = false

func set_dialogue(new_val):
	get_node(nodepath_dialogue).text = new_val
	dialogue = new_val

func split_dialogue():
	
	pass

func progress_text():
	var dialogue_label:Label = get_node(nodepath_dialogue)
	if (dialogue_label.get_line_count() - dialogue_label.lines_skipped) > 2:
		dialogue_label.lines_skipped += 2
	else:
		dismiss_text = true
