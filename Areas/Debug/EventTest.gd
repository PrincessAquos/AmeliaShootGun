extends Dungeon


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t

# Called when the node enters the scene tree for the first time.
func _ready():
	#t = TextEvent.new(self, "This is a test of text events")
	t = ItemTextEvent.new(self, Item.new(4), "You done got an item whoa.")
	add_child(t)
	Game.play_event(t)
	pass # Replace with function body.



