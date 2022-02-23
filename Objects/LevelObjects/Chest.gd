extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var model_path:NodePath
export var contains:int = -1
var closed = true

var model_node:AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	model_node = get_node(model_path)
	pass # Replace with function body.


func interact():
	open()


func open():
	if closed:
		model_node.animation = "Open"
		if contains != -1:
			Game.inv_screen.add_item(Item.new(contains))
		closed = false
	return
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
