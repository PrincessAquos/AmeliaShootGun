extends CenterContainer

class_name InvSlot
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var item_img_path:NodePath
export var item_count_path:NodePath

var item_icon_node:TextureRect
var item_count_label:Label

var item = null setget set_item
var count:int = 0 setget set_count
var equipped

# Called when the node enters the scene tree for the first time.
func _ready():
	item_icon_node = get_node(item_img_path)
	item_count_label = get_node(item_count_path)
	pass # Replace with function body.


func set_count(new_count):
	count = new_count
	item_count_label.text = String(count)


func set_item(new_item):
	if item != null && item.id == new_item.id:
		set_count(count + 1)
	else:
		item = new_item
		item_icon_node.texture = new_item.inventory_img
		set_count(1)
		if item.have_multiple:
			item_count_label.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
