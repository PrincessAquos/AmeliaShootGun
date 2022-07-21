extends Dungeon


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t

# Called when the node enters the scene tree for the first time.
func _ready():
	#t = TextEvent.new(self, "This is a test of text events")
	var item = Item.new_item(4)
	t = ItemTextEvent.new(self, item, "You done got an item whoa. This item is a " + item.item_name + "! That's so cool! Holy shit! There's too much text here!")
	add_child(t)
	Game.play_event(t)
	pass # Replace with function body.



