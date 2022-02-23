extends Reference

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ilist:Array = [
	Item.new("Notepad", "res://Sprite/Items/Notepad.png", 0, false, true),
	Item.new("Badge", "res://Sprite/Items/Badge.png", 1, false, true),
	Item.new("Gear Part Case", "res://Sprite/Items/GearPartCase.png", 2, false, false),
	Item.new("Gun", "res://Sprite/Items/Gun.png", 3, false, false),
	Item.new("Scroll", "res://Sprite/Items/Scroll.png", 4, false, false)
]

func get_by_name(iname):
	pass

func get_by_id(id):
	pass
