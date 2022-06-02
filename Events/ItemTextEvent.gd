extends Event

class_name ItemTextEvent

var text
var item:int


func _init(source, in_item, in_text).(source):
	item = in_item
	text = in_text
	return self


func _start():
	var t = TextEvent.new(self, text)
	var i = ItemEvent.new(self, item)
	i.trigger()
	t.trigger()
	pass # Replace with function body.
