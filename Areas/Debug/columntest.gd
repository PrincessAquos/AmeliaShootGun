extends StaticBody2D

@export var height:int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Game.player.altitude >= height-2:
		collision_layer = 512
	else:
		collision_layer = 2560
		pass
	pass
