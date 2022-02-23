extends Character

export var node_run_model:NodePath
export var node_sound_gunfire:NodePath
export var node_sound_jump:NodePath
export var node_interact_area:NodePath

var num_gears = 3
# Movement Stats


var buffer_time = 0.15

# Ground Pound Stats
var gp_hang_time = 0.2
var gp_accel = gravity * 4
var gp_hitframes = 0.1
var gp_endlag = 0.3
var gp_hitbox:Area2D = null

# Gun Stats
var gun_range = 650
var gun_damage = 1
var gun_hitframes = 0.05
var gun_endlag = 0.5

# Hitstun Stats

# State
var shoot_buffer = 0.05
var shoot_buffer_timer = 0
var shoot_pressed = false
var gun_timer = 0
var debug_gunbox_frame_done = false

var jump_buffer = 0
var ground_pound_state = 0
var gp_timer = 0

# Called when the node enters the scene tree for the first time.
func _on_ready():
	Game.player = self
	current_health = 12
	dmg_knockback = 180
	speed = 96
	
	var raycast:RayCast2D = get_node("RayCast2D")
	raycast.add_exception(self)
	raycast.add_exception(get_node("GPHitbox"))
	raycast.add_exception(get_node("Hurtbox"))
	gp_hitbox = get_node("GPHitbox")
	._on_ready()
	pass

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		print("Interact!")
		var things = get_node("Interact").get_overlapping_bodies()
		print(things)
		for thing in things:
			thing.interact()
			pass
		pass
	
	if event.is_action_pressed("move_jump"):
		print("panic")
		if gun_timer <= 0:
			if altitude == 0 && ground_pound_state == 0:
				get_node(node_sound_jump).play()
				vertical_velocity = jump_speed
			#elif altitude > 10 && ground_pound_state == 0:
			#	ground_pound_state = 1
			else:
				jump_buffer = buffer_time
	
	if event.is_action_pressed("move_up"):
		move_dirs[Direction.UP] = true
	if event.is_action_pressed("move_down"):
		move_dirs[Direction.DOWN] = true
	if event.is_action_pressed("move_left"):
		move_dirs[Direction.LEFT] = true
	if event.is_action_pressed("move_right"):
		move_dirs[Direction.RIGHT] = true
	
	if event.is_action_released("move_up"):
		move_dirs[Direction.UP] = false
	if event.is_action_released("move_down"):
		move_dirs[Direction.DOWN] = false
	if event.is_action_released("move_left"):
		move_dirs[Direction.LEFT] = false
	if event.is_action_released("move_right"):
		move_dirs[Direction.RIGHT] = false
	
	
	#if event.is_action_pressed("time_warp"):
	#	Game.do_time_warp = true
	#if event.is_action_released("time_warp"):
	#	Game.do_time_warp = false
	
	if event.is_action_pressed("shoot"):
		
		#	Game.do_time_warp = true
		shoot_pressed = true
		shoot_buffer_timer = 0
		if altitude > 0:
			Game.activate_bullet_time()
			shoot_buffer_timer = shoot_buffer * 2
	if event.is_action_released("shoot"):
		Game.deactivate_bullet_time()
		shoot_pressed = false

func _on_physics_process(delta):
	if gun_timer > 0:
		if altitude <= 0:
			move_vector = Vector2.ZERO
		lock_lateral_velocity = true
		gun_timer -= delta
	elif altitude <= 0:
		lock_lateral_velocity = false
	
	var fire_shot = false
	if shoot_buffer_timer > 0:
		model.play("ShootBuffer" + dir_strings[facing])
		shoot_buffer_timer -= delta
		lock_lateral_velocity = true
	elif shoot_pressed && gun_timer <= 0:
		fire_shot = true
		lock_lateral_velocity = true
	
	if hurtbox.hitstun_timer <= 0:
		if fire_shot:
			var sfx_gunshot:AudioStreamPlayer2D = get_node(node_sound_gunfire)
			sfx_gunshot.play()
			var model = get_node(node_model)
			model.frame = 0
			model.play("Shoot" + dir_strings[facing])
			print("blam")
			var raycast:RayCast2D = get_node("RayCast2D")
			var line:Line2D = get_node("Line2D")
			var target = Vector2.ZERO
			target = Directions.dir_vectors[facing] * gun_range
			raycast.cast_to = target
			line.points[1] = target
			raycast.force_raycast_update()
			print(raycast.is_colliding())
			if raycast.is_colliding():
				var obj_hit = raycast.get_collider()
				if "enemy_hurtbox" in obj_hit.get_groups():
					obj_hit.hit_source = raycast.get_collision_point()
					obj_hit.hitstun_timer = obj_hit.dmg_hitstun
					obj_hit.damage_taken = gun_damage
			get_node("Line2D").visible = true
			gun_timer = gun_endlag
	._on_physics_process(delta)
	var num_slides = get_slide_count()
	for i in num_slides:
		var collision = get_slide_collision(i)
		var collider = collision.collider
		print(collider.name)
		if collider in get_tree().get_nodes_in_group("room"):
			Game.current_dungeon.change_rooms(collider)
			#.move_and_slide(collision.position - global_position)
			break
		elif collider in get_tree().get_nodes_in_group("door"):
			if collider.is_locked:
				if Game.inv_screen.slots[Data.itemindex.get("scroll").slot].count > 0:
					collider.is_locked = false
	
	if altitude <= 0 || (shoot_buffer_timer <= 0 && gun_timer <= 0 && !shoot_pressed):
		Game.reset_game_speed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_process(delta):
	check_invuln_flicker()
	update_interact_position()
	# Debug show gunbox
	if debug_gunbox_frame_done:
		get_node("Line2D").visible = false
		debug_gunbox_frame_done = false
	if get_node("Line2D").visible == true:
		debug_gunbox_frame_done = true
		
		
	#print(get_node("Line2D").visible)
			
	
	# Handle the jump buffer time
	if ground_pound_state == 0:
		if jump_buffer > 0:
			if altitude == 0:
				vertical_velocity = jump_speed
				jump_buffer = 0
	jump_buffer = max(jump_buffer - delta, 0)
	
	# Calculate the altitude
	
	# Ground Pounding
	if ground_pound_state == 1:
		ground_pound_state = 2
		gp_timer = gp_hang_time
		vertical_velocity = 0
		prev_vertical_velocity = 0
	elif ground_pound_state == 2:
		if gp_timer > 0 && delta > gp_timer:
			delta = delta - gp_timer
			gp_timer = 0
		else:
			gp_timer -= delta
		
		if gp_timer <= 0:
			
			if altitude > 0 || (altitude == 0 && vertical_velocity > 0):
				vertical_velocity -= gp_accel*delta
			else:
				altitude = 0
				vertical_velocity = 0
				prev_vertical_velocity = 0
				ground_pound_state = 3
				gp_timer = gp_endlag
				get_node("GPHitbox").visible = true
				gp_hitbox.monitoring = true
	elif ground_pound_state == 3:
		gp_timer -= delta
		if gp_timer < gp_endlag - gp_hitframes:
			get_node("GPHitbox").visible = false
			gp_hitbox.monitoring = false
		if gp_timer < 0:
			ground_pound_state = 0
	._on_process(delta)


func set_current_health(new_val):
	.set_current_health(new_val)
	Game.update_hud_health(num_gears, current_health)
	return


func die():
	print("This is when Game Over would happen")
	pass


func check_invuln_flicker():
	if hurtbox.invuln_timer > 0:
		invuln_flicker_active()
	else:
		invuln_flicker_inactive()


func invuln_flicker_active():
	var flicker_time = 0.2
	var frame = hurtbox.invuln_timer / flicker_time
	#print(abs(((frame - int(frame)) * 2) - 1))
	model.modulate = Color(1, 1, 1, abs(((frame - int(frame)) * 2) - 1))
	pass


func invuln_flicker_inactive():
	model.modulate = Color(1, 1, 1, 1)
	pass


func _update_sprite():
	if gun_timer <= 0:
		._update_sprite()
	if shoot_buffer_timer > 0:
		model.play("ShootBuffer" + dir_strings[facing])


func update_interact_position():
	var interact_pos = Vector2(0, 0)
	match facing:
		Direction.DOWN:
			interact_pos = Vector2(0, 10)
		Direction.UP:
			interact_pos = Vector2(0, -4)
		Direction.LEFT:
			interact_pos = Vector2(-9, 3)
		Direction.RIGHT:
			interact_pos = Vector2(9, 3)
	get_node(node_interact_area).position = interact_pos

func _on_GPHitbox_body_entered(body):
	if body in get_tree().get_nodes_in_group("enemies"):
		body.queue_free()
	pass


func _on_GPHitbox_area_entered(area):
	if area in get_tree().get_nodes_in_group("enemies"):
		area.queue_free()
	pass
