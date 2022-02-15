extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time = 0
var gear_time = 0
var seconds = 12
var angle = PI
var hand_length = 7

var clock_hand:Line2D
# Called when the node enters the scene tree for the first time.
func _ready():
	clock_hand = get_node("Line2D")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta *= Game.game_speed
	time += delta
	#angle = (time/seconds * 2*PI) - 0.5*PI
	angle = (float(gear_time%(seconds))/(seconds) * 2*PI) - 0.5*PI
	
	#angle = time/60 + 90
	clock_hand.points[1] = clock_hand.points[0] + 6 * Vector2(cos(angle), sin(angle))
	pass


func _on_AnimatedSprite_frame_changed():
	gear_time += 1
	return
