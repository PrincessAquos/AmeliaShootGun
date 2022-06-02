extends Event

class_name ChestEvent

const fixed_text = "This is fixed text or something "
const item_stuff = "This is a placeholder for item stuff"

var item_id

func _init(source, in_item_id).(source):
	item_id = in_item_id
	pass


func _start():
	var item = Item.new(item_id)
	var message = fixed_text + item.item_name + ". " # + item description
	# Animate the item rising from the chest
	var ite = ItemTextEvent.new(self, item, message)
	ite.trigger()
	pass
