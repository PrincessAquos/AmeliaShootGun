extends Object

class_name Item

var id:String
var item_name:String
var item_description:String
var inventory_img:Texture
var prefer_slot:int
var is_equippable = false
var use_from_menu = false
var have_multiple = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _init(index):
	var entry:Data.ItemIndex.ItemIndexRow = Data.itemindex.all[index]
	id = entry.id
	item_name = entry.iname
	item_description = "This item exists, and this is a placeholder description."
	inventory_img = load(entry.img_path)
	prefer_slot = entry.slot
	is_equippable = entry.equippable
	use_from_menu = entry.menu_use
	have_multiple = entry.have_multiple
	return
