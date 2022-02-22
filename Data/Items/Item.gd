extends Resource

class_name Item

export var item_name:String
export var inventory_img:Texture
export var prefer_slot:int
export var is_equippable = false
export var use_from_menu = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _init(iname, iimg, pslot = -1, can_equip = false, use = false):
	item_name = iname
	inventory_img = iimg
	prefer_slot = pslot
	is_equippable = can_equip
	use_from_menu = use
	return
