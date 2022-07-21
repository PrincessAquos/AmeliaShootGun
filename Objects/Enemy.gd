extends Character


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var change_dir_time = 2

var change_dir_timer = 0

export var halo_scene:PackedScene

var attack_time_max = 10
var attack_time_min = 5

var attack_timer = 0
var attack_frame = 5

var attacking = false

# Called when the node enters the scene tree for the first time.
func _on_ready():
	._on_ready()
	attack_timer = rand_range(attack_time_min, attack_time_max)
	speed = 8
	#if hurtbox.hitstun_timer > 0:
		#print(hurtbox.hitstun_timer)


func _on_physics_process(delta):
	if is_loaded:
		get_node("Hitbox")._on_physics_process(delta)
		if attack_timer <= 0:
			attacking = true
			attack_timer = rand_range(attack_time_min, attack_time_max)
			for direction in move_dirs:
				move_dirs[direction] = false
		elif !attacking && change_dir_timer <= 0:
			change_dir_timer += change_dir_time
			for direction in move_dirs:
				move_dirs[direction] = false
			var testlist = [Direction.UP, Direction.DOWN, Direction.LEFT, Direction.RIGHT]
			move_dirs[testlist[randi() % 4]] = true
		attack_timer -= delta
		change_dir_timer -= delta
	._on_physics_process(delta)


func _on_process(delta):
	._on_process(delta)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _update_sprite():
	if attacking:
		model.play("Toss" + dir_strings[facing])
	else:
		._update_sprite()
	pass


func die():
	var hitbox = get_node("Hitbox")
	hitbox.monitoring = false
	hitbox.monitorable = false
	hitbox.shape_owner_get_owner(0).disabled = true
	.die()


func _on_AnimatedSprite_frame_changed():
	if not Engine.editor_hint:
		if model.animation.begins_with("Toss"):
			if model.frame == attack_frame:
				model.modulate = Color(1, 1, 0, 1)
				# Throw Halo
				var inst_halo = halo_scene.instance()
				inst_halo.instance_init(position, facing)
				Game.current_dungeon.add_child(inst_halo)
			else:
				model.modulate = Color(1, 1, 1, 1)
		else:
			model.modulate = Color(1, 1, 1, 1)
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if not Engine.editor_hint:
		if model.animation.begins_with("Toss"):
			attacking = false
			_update_sprite()
	pass # Replace with function body.
