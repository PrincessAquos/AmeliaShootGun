extends Event

class_name ItemTextEvent

var text_event:TextEvent
var item_event:ItemEvent

var step = 0

func _init(source, in_item, in_text).(source):
	item_event = ItemEvent.new(self, in_item)
	text_event = TextEvent.new(self, in_text)
	add_child(item_event)
	add_child(text_event)


func _start():
	
	pass # Replace with function body.


func _on_process(delta):
	match step:
		0:
			item_event.trigger()
			step = 1
		1:
			if item_event._is_finished():
				item_event.ack()
				text_event.trigger()
				step = 2
		2:
			if text_event._is_finished():
				text_event.ack()
				complete = true
				step = 3
		3:
			pass
	pass

func _is_finished():
	return complete
