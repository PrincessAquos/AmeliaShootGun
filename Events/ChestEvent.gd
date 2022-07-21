extends Event

class_name ChestEvent

const fixed_text = "You found a "
const item_stuff = "This is a placeholder for item stuff"

var item_id
var event
var step = 0

func _init(source, in_item_id).(source):
	complete = false
	item_id = in_item_id
	pass


func _start():
	var item = Item.new_item(item_id)
	var message = "\n" + fixed_text + item.item_name + "!\n\n" + item.instruction
	# Animate the item rising from the chest
	event = ItemTextEvent.new(self, item, message)
	add_child(event)
	event.trigger()
	pass


func _on_process(delta):
	if event.complete:
		complete = true
	pass


func _is_finished():
	return complete
