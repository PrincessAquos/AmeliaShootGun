extends CenterContainer

class_name InvSlot
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var item_img_path:NodePath

var item_icon_node:TextureRect

var item:Item = null setget set_item
var equipped

# Called when the node enters the scene tree for the first time.
func _ready():
	item_icon_node = get_node(item_img_path)
	pass # Replace with function body.


func set_item(new_item:Item):
	item = new_item
	item_icon_node.texture = new_item.inventory_img


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
