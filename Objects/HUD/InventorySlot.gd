extends CenterContainer

class_name InvSlot
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var item_img_path:NodePath
@export var item_count_path:NodePath

var item_icon_node:TextureRect
var item_count_label:Label

var item = null: set = set_item
var count:int = 0: set = set_count
var equipped

var save_slot:SaveData.SaveInventory.SaveInventorySlots

func collect_save_info():
	var inv_slot_info = {}
	if item != null:
		inv_slot_info["item_id"] = item.id
	else:
		inv_slot_info["item_id"] = null
	inv_slot_info["count"] = count
	return inv_slot_info


func load_save_info(inv_slot_info):
	save_slot = inv_slot_info
	var item_id = inv_slot_info.item_id
	if item_id == null:
		item = null
	else:
		print(Data.itemindex.index[item_id])
		var new_item = Item.new_item_by_id(item_id)
		print(new_item)
		set_item(new_item)
	set_count(int(inv_slot_info.count))

# Called when the node enters the scene tree for the first time.
func _ready():
	item_icon_node = get_node(item_img_path)
	item_count_label = get_node(item_count_path)
	pass # Replace with function body.


func set_count(new_count):
	count = new_count
	save_slot.count = new_count
	item_count_label.text = String(count)


func set_item(new_item):
	print("setting item slot")
	if new_item != null:
		if item != null && item.id == new_item.id && item.have_multiple:
			set_count(count + 1)
		else:
			set_count(1)
			#else:
		item = new_item
		save_slot.item_id = item.id
		item_icon_node.texture = new_item.inventory_img
		if item.have_multiple:
			item_count_label.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
