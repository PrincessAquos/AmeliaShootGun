extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var unique_id = -1
@export var start_active = true
@export var model_path:NodePath
@export var contains:int = -1
@export var item_model_path:NodePath
var closed = true: set = set_closed

var active = true: set = set_active
var model_node:AnimatedSprite2D

var save_chest:SaveData.SaveArea.SaveChest: set = load_save_info


func collect_save_info():
	var chest_info = {}
	chest_info["active"] = active
	chest_info["closed"] = closed
	return chest_info


func load_save_info(new_save_chest:SaveData.SaveArea.SaveChest):
	save_chest = new_save_chest
	set_active(new_save_chest.is_active)
	set_closed(new_save_chest.is_closed)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Don't disable the collision box yet.
	# If the chest is not active, the room will 
	# disable its collision box after it is registered.
	
	model_node = get_node(model_path)
	pass # Replace with function body.

func load_defaults():
	set_active(start_active)


func deactivate():
	set_active(false)


func activate():
	set_active(true)


func interact():
	open()


func open():
	if closed:
		var item_model = get_node(item_model_path)
		set_closed(false)
		if contains != -1:
			var item_obj = Item.new_item(contains)
			item_model.texture = item_obj.inventory_img
			item_model.visible = true
			var event = ChestEvent.new(self, contains)
			add_child(event)
			Game.play_event(event)
			#Game.inv_screen.add_item(Item.new_item(contains))
	return


func set_active(new_val):
	active = new_val
	visible = new_val
	shape_owner_get_owner(0).disabled = !new_val
	if save_chest != null:
		save_chest.is_active = new_val


func set_closed(new_val):
	closed = new_val
	save_chest.is_closed = new_val
	if new_val:
		model_node.animation = "Closed"
	else:
		model_node.animation = "Open"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
