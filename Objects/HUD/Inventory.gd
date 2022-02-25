extends Control

class_name Inventory

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
	
	for i in range(4):
		var new_item = Item.new(i)
		#print(new_item)
		add_item(new_item)
	return


func add_item(new_item:Item):
	var slot:InvSlot
	if new_item != null:
		slot = slots[new_item.prefer_slot]
		slot.item = new_item
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
