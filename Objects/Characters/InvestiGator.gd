extends Character


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var change_dir_time = 1

var change_dir_timer = 0


var do_attack = false
var attack_timer = 0
var attack_slide_timer = 0
const attack_delay = 0.45
const attack_slide_delay = 0.2
const attack_slide_skid = 0.5
const attack_skid_bump = 0.1
const slide_speed = 60
const lunge_speed = 90
const lunge_height = 8

# Called when the node enters the scene tree for the first time.
func _on_ready():
	._on_ready()
	speed = 32
	is_loaded = true
	pass # Replace with function body.


func _unhandled_input(event):
	if event.is_action_pressed("move_jump"):
		do_attack = true
		pass
	pass


func _update_sprite():
	var new_anim = null
	if attack_timer > 0:
		new_anim = "BiteOpen" + dir_strings[facing]
	elif attack_slide_timer > 0:
		new_anim = "BiteClose" + dir_strings[facing]
	if new_anim == null:
		#print("'" + model.animation + "' is not '" + new_anim + "'")
		#print("New Animation!")
		._update_sprite()
	elif new_anim != model.animation:
		model.play(new_anim)
	return


func _on_physics_process(delta):
	var dir_vector = Directions.dir_vectors[facing]
	if attack_timer > 0:
		altitude = ((attack_delay - attack_timer)/attack_delay)*lunge_height
		move_and_slide(dir_vector * lunge_speed * ((attack_delay - attack_timer)/attack_delay))
		attack_timer -= delta
		if attack_timer <= 0:
			attack_slide_timer = attack_slide_delay + attack_slide_skid
	elif attack_slide_timer > 0:
		attack_slide_timer -= delta
		var progress = (attack_slide_timer/(attack_slide_delay + attack_slide_skid))
		var progress_altitude = clamp(((attack_slide_timer-attack_slide_skid)/attack_slide_delay), 0, 1)
		var skid_bumps = int(attack_slide_timer/attack_skid_bump) % 2

		print(progress_altitude)
		altitude = progress_altitude*lunge_height
		print(altitude)
		if attack_slide_timer > attack_slide_skid:
			move_and_slide(dir_vector * lunge_speed * progress)
		else:
			print(skid_bumps)
			altitude = 1 * skid_bumps
			move_and_slide(dir_vector * slide_speed * progress)
	elif do_attack:
		#model.play("BiteOpenDown")
		attack_timer = attack_delay
		do_attack = false
	else:
		if change_dir_timer <= 0:
			change_dir_timer += change_dir_time
			for direction in move_dirs:
				move_dirs[direction] = false
			var testlist = [Direction.UP, Direction.DOWN, Direction.LEFT, Direction.RIGHT]
			move_dirs[testlist[randi() % 4]] = true
		change_dir_timer -= delta
		._on_physics_process(delta)
	pass


func _on_AnimatedSprite_animation_finished():
	if model.animation == "BiteCloseDown":
		#attacking = false
		pass
	pass # Replace with function body.
