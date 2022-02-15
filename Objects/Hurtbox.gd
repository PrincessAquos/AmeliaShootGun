extends Area2D

class_name Hurtbox

var dmg_hitstun = 0.2
var dmg_invuln_frames = 0.7


var altitude = 0
# Global position of the hit
var hit_source = Vector2(0,0)
var hitstun_timer = 0
var damage_taken = 0
var invuln_timer = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.do_time_warp:
		delta *= Game.warp_time_by
	if invuln_timer > 0:
		invuln_timer -= delta
	if hitstun_timer > 0:
		hitstun_timer -= delta
	pass


func hit(source_pos, damage):
	# source_pos should use global coordinates
	if invuln_timer <= 0:
		hit_source = source_pos
		hitstun_timer = dmg_hitstun
		invuln_timer = dmg_invuln_frames
		damage_taken = damage
	return
