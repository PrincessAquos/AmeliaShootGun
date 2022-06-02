extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t

# Called when the node enters the scene tree for the first time.
func _ready():
	t = TextEvent.new(self, "This is a test of text events")
	add_child(t)
	Game.play_event(t)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
