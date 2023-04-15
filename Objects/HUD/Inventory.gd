extends Control

class_name Inventory

@export var key_item_path:NodePath
@export var equip_item_path:NodePath

@export (Array, NodePath) var slot_paths

var key_item_section
var equippable_item_section
var slots:Array = []
var save_inventory:SaveData.SaveInventory

func collect_save_info():
	var inventory_info = []
	for i in range(slots.size()):
		inventory_info.append(slots[i].collect_save_info())
	return inventory_info


func load_save_info(inventory_info):
	print("loading inventory")
	save_inventory = inventory_info
	for i in range(slots.size()):
		slots[i].load_save_info(inventory_info.slots[i])


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.inv_screen = self
	key_item_section = get_node(key_item_path)
	equippable_item_section = get_node(equip_item_path)
	for slot_path in slot_paths:
		slots.append(get_node(slot_path))
	return


func add_item(new_item):
	var slot:InvSlot
	if new_item != null:
		slot = slots[new_item.prefer_slot]
		slot.item = new_item
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
