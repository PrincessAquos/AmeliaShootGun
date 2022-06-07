extends Event

class_name ItemEvent

var item:Item = null


func _init(source, in_item).(source):
	item = in_item


func _start():
	Game.inv_screen.add_item(item)
	print("Added " + item.item_name + " to the inventory.")
	pass
