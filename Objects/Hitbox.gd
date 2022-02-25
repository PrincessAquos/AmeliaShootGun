extends Area2D

class_name Hitbox
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var height = 6
export var damage:int = 1
var altitude = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_physics_process(delta):
	var collision_body_list = get_overlapping_bodies()
	var collision_area_list = get_overlapping_areas()
	var player_hurtbox_list = get_tree().get_nodes_in_group("player_hurtbox")
	
	for player_hurtbox in player_hurtbox_list:
		if player_hurtbox.altitude <= height + altitude && (player_hurtbox in collision_body_list or player_hurtbox in collision_area_list):
			player_hurtbox.hit(get_parent().global_position, damage)
			deliver_damage(player_hurtbox)
	return


func deliver_damage(body):
	body.hit(get_parent().global_position, damage)
