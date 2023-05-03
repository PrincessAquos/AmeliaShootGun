extends Control

class_name TextBox


@export var title_tab_nodepath:NodePath
@export var title_nodepath:NodePath
@export var dialogue_nodepath:NodePath
var title_tab_node:Control
var title_node:Label
var dialogue_node:Label

var title : set = set_title
var dialogue : set = set_dialogue
var lines
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	title_tab_node = get_node(title_tab_nodepath)
	title_node = get_node(title_nodepath)
	dialogue_node = get_node(dialogue_nodepath)
	pass # Replace with function body.

func initialize(new_title, new_dialogue):
	set_title(new_title)
	set_dialogue(new_dialogue)
	visible = true
	active = true

func set_title(new_val):
	if new_val != null:
		title_node.text = new_val
		title = new_val
	else:
		title_tab_node.visible = false

func set_dialogue(new_val):
	dialogue_node.text = new_val
	dialogue = new_val

func split_dialogue():
	
	pass

func progress_text():
	if (dialogue_node.get_line_count() - dialogue_node.lines_skipped) > dialogue_node.max_lines_visible:
		dialogue_node.lines_skipped += dialogue_node.max_lines_visible
	else:
		active = false
		visible = false
