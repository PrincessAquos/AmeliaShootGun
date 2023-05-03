extends Character

@export var node_run_model:NodePath
@export var node_sound_gunfire:NodePath
@export var node_sound_jump:NodePath
@export var node_interact_area:NodePath
#export (int, 0, 200) var push = 10

var num_gears = 3
# Movement Stats


var buffer_time = 0.3

# Gun Stats
var gun_range = 650
var gun_damage = 1
var gun_hitframes = 0.05
var gun_endlag = 0.5

# Hitstun Stats

# State
var shoot_buffer = 0.1
var shoot_buffer_timer = 0
var shoot_pressed = false
var gun_timer = 0
var debug_gunbox_frame_done = false

var jump_buffer = 0

# Called when the node enters the scene tree for the first time.
func _on_ready():
	Game.player = self
	current_health = 12
	dmg_knockback = 120
	speed = 64
	
	var raycast:RayCast2D = get_node("RayCast2D")
	raycast.add_exception(self)
	raycast.add_exception(get_node("Hurtbox"))
	super._on_ready()
	pass

func _unhandled_input(event):
	if is_loaded:
		if event.is_action_pressed("interact"):
			print("Interact!")
			var things = get_node("Interact").get_overlapping_bodies()
			print(things)
			for thing in things:
				thing.interact()
				pass
			pass

func _on_physics_process(delta):
	if is_loaded:
		# Store the input states for the move keys
		move_dirs[Direction.UP] = Input.is_action_pressed("move_up")
		move_dirs[Direction.DOWN] = Input.is_action_pressed("move_down")
		move_dirs[Direction.LEFT] = Input.is_action_pressed("move_left")
		move_dirs[Direction.RIGHT] = Input.is_action_pressed("move_right")
		
		# =============================================
		# Process whether you should be allowed to jump
		# =============================================
		if Input.is_action_just_pressed("move_jump"):
			if gun_timer <= 0 && is_grounded():
				get_node(node_sound_jump).play()
				vertical_velocity = jump_speed
			else:
				jump_buffer = buffer_time
		if jump_buffer > 0:
			if gun_timer <= 0 && is_grounded():
				get_node(node_sound_jump).play()
				vertical_velocity = jump_speed
				jump_buffer = 0
			jump_buffer -= delta
		
		# ===================================
		# Process whether the gun should fire
		# ===================================
		
		# If the gun is in lag
		if gun_timer > 0:
			# Update the gun timer
			gun_timer -= delta
			
			# Fixes aerial shot gunslide
			if is_grounded():
				move_vector = Vector2.ZERO
		
		# Gun is not in lag, and shoot is pressed
		elif Input.is_action_pressed("shoot"):
			# Only shoot if not in hitstun
			if hurtbox.hitstun_timer <= 0:
				# If you're grounded,  fire a shot and set the endlag
				if is_grounded():
					# Deactivates bullet time if you've just landed
					Game.deactivate_bullet_time()
					
					fire_shot()
					move_vector = Vector2.ZERO
					gun_timer = gun_endlag
				# Otherwise, if this is the first frame pressed, activate bullet time
				elif Input.is_action_just_pressed("shoot"):
					Game.activate_bullet_time()
				lock_lateral_velocity = true
		
		# Gun is not in lag, and shoot was just released
		elif Input.is_action_just_released("shoot"):
			# Only shoot if not in hitstun
			if hurtbox.hitstun_timer <= 0:
				# Fire a shot
				fire_shot()
				Game.deactivate_bullet_time()
				gun_timer = gun_endlag
		
		# Not in lag, shoot been released for 2 frames, currently grounded
		elif is_grounded():
			Game.deactivate_bullet_time()
			lock_lateral_velocity = false

	# Execute the general Character physics process
	super._on_physics_process(delta)

	# Check for any special collisions triggered in the general physics process
	if is_loaded:
		handle_special_collisions()
		#if altitude <= 0 || (shoot_buffer_timer <= 0 && gun_timer <= 0 && !shoot_pressed):
			#Game.reset_game_speed()


func handle_special_collisions():
	var num_slides = get_slide_collision_count()
	for i in num_slides:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print(collider.name)
		if collider.is_in_group("pushblock"):
			if is_grounded():
				print("It's a pushblock!")
				#print(collision.normal)
				#print(collision.collider.push_speed)
				collision.collider.push(-collision.normal)
		if collider in get_tree().get_nodes_in_group("room"):
			Game.current_dungeon.change_rooms(collider)
			#.move_and_slide(collision.position - global_position)
			break
		if collider in get_tree().get_nodes_in_group("door"):
			if collider.is_locked:
				if Game.inv_screen.slots[Data.itemindex.get("scroll").slot].count > 0:
					collider.is_locked = false
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_process(delta):
	if is_loaded:
		check_invuln_flicker()
		update_interact_position()
		# Debug show gunbox
		if debug_gunbox_frame_done:
			get_node("Line2D").visible = false
			debug_gunbox_frame_done = false
		if get_node("Line2D").visible == true:
			debug_gunbox_frame_done = true
	super._on_process(delta)


func set_current_health(new_val):
	super.set_current_health(new_val)
	Game.player_current_health = new_val
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


func fire_shot():
	# Play the sound effect
	var sfx_gunshot:AudioStreamPlayer2D = get_node(node_sound_gunfire)
	sfx_gunshot.play()
	
	# Play the shooting animation
	var model = get_node(node_model)
	model.play("Shoot" + dir_strings[facing])
	
	# Cast the ray
	var raycast:RayCast2D = get_node("RayCast2D")
	var line:Line2D = get_node("Line2D")
	var target = Vector2.ZERO
	target = Directions.dir_vectors[facing] * gun_range
	raycast.target_position = target
	line.points[1] = target
	raycast.force_raycast_update()
	
	# If you hit an object, pass damage info
	if raycast.is_colliding():
		var obj_hit = raycast.get_collider()
		if "enemy_hurtbox" in obj_hit.get_groups():
			obj_hit.hit_source = raycast.get_collision_point()
			obj_hit.hitstun_timer = obj_hit.dmg_hitstun
			obj_hit.damage_taken = gun_damage
	
	# Draw bullet path
	get_node("Line2D").visible = true
	return


func _update_sprite():
	if gun_timer <= 0:
		if !is_grounded() and Input.is_action_pressed("shoot"):
			model.play("ShootBuffer" + dir_strings[facing])
		else:
			super._update_sprite()


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


func _on_floor_detection_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var bundle = {
		"body": body,
		"body_rid": body_rid,
		"body_shape_index": body_shape_index,
		"local_shape_index": local_shape_index,
	}
	if bundle not in floor_shapes:
		floor_shapes.append(bundle)
	pass # Replace with function body.


func _on_floor_detection_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	var bundle = {
		"body": body,
		"body_rid": body_rid,
		"body_shape_index": body_shape_index,
		"local_shape_index": local_shape_index,
	}
	if bundle in floor_shapes:
		floor_shapes.erase(bundle)
	pass # Replace with function body.
