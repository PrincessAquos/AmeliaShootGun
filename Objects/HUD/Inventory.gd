extends Control

class_name Inventory
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var item_index:Resource
export var key_item_path:NodePath
export var equip_item_path:NodePath

export (Array, NodePath) var slot_paths

var key_item_section
var equippable_item_section
var slots:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.inv_screen = self
	key_item_section = get_node(key_item_path)
	equippable_item_section = get_node(equip_item_path)
	for slot_path in slot_paths:
		slots.append(get_node(slot_path))
	
	#for i in range(5):
	#	print(item_index.items[i])
	#	add_item(item_index.items[i])
	return


func add_item(new_item:Item):
	var slot:InvSlot
	if new_item != null && slots[new_item.prefer_slot] == null:
		slot = slots[new_item.prefer_slot]
		slot.item = new_item
	else:
		# Put in first free slot
		for check_slot in slots:
			if check_slot.item == null:
				slot = check_slot
				break
		slot.item = new_item
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
