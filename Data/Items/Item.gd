extends RefCounted

class_name Item

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


static func new_item(index):
	var entry:Data.ItemIndex.ItemIndexRow = Data.itemindex.all[index]
	var item_dat = {}
	item_dat["id"] = entry.id
	item_dat["item_name"] = entry.iname
	item_dat["description"] = entry.description
	item_dat["instruction"] = entry.instruction
	item_dat["inventory_img"] = load(entry.img_path)
	item_dat["prefer_slot"] = entry.slot
	item_dat["is_equippable"] = entry.equippable
	item_dat["use_from_menu"] = entry.menu_use
	item_dat["have_multiple"] = entry.have_multiple
	return item_dat

static func new_item_by_id(item_id):
	var index = Data.itemindex.index[item_id]
	return new_item(index)
