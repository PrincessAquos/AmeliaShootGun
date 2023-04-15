extends Event

class_name ItemEvent

var item = null


func _init(source, in_item):
	super(source)
	item = in_item


func _start():
	Game.inv_screen.add_item(item)
	print("Added " + item.item_name + " to the inventory.")
	pass
