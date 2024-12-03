extends CharacterBody2D

@export var movement_data : PlayerMovementData

var air_jump = false
var just_wall_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var count = 0
# { "0": [position, h_flip, animation] }
var player_record: Dictionary = { "0": [Vector2(0,0), true, 'idle'] }

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var starting_position = global_position
@onready var jump_buffer_timer = $JumpBufferTimer
@onready var gun = $Gun
@onready var jump_audio = $JumpAudio

func _physics_process(delta):
	record()
	apply_gravity(delta)

	handle_wall_jump()
	handle_jump()
	
	var input_axis = Input.get_axis("left", "right")
	
	handle_acceleration(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	
	update_animations(input_axis)
	
	var was_on_floor = is_on_floor()

	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	
	if just_left_ledge:
		coyote_jump_timer.start()
		
	just_wall_jumped = false
		
	#if Input.is_action_just_pressed("ui_accept"):
		#movement_data = load("res://FasterMovementData.tres")

func apply_gravity(delta):
	if not is_on_floor():
		if is_on_wall_only() and velocity.y > 0:
			velocity.y += gravity * 0.05 * delta
		else:
			velocity.y += gravity * movement_data.gravity_scale * delta
			

func handle_wall_jump():
	if not is_on_wall_only(): return
	
	var wall_normal = get_wall_normal()
	if Input.is_action_just_pressed("left") and wall_normal == Vector2.LEFT:
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity
		just_wall_jumped = true
		jump_audio.play()
		
	if Input.is_action_just_pressed("right") and wall_normal == Vector2.RIGHT:
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity
		just_wall_jumped = true
		jump_audio.play()

func handle_jump():
	if is_on_floor(): air_jump = true
	
	if not is_on_floor() and Input.is_action_just_pressed("jump") and not air_jump:
		jump_buffer_timer.start()
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump") or jump_buffer_timer.time_left > 0.0:
			velocity.y = movement_data.jump_velocity
			jump_audio.play()
	
	elif not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
			
		if Input.is_action_just_pressed("jump") and air_jump and not just_wall_jumped:
			velocity.y = movement_data.jump_velocity * 0.8
			jump_audio.play()
			air_jump = false

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
		
	if input_axis:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	
	if input_axis:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite.play("run")
		animated_sprite.flip_h = input_axis < 0
		gun.scale.x = -1 if input_axis < 0 else 1
	else:
		animated_sprite.play("idle")
		
	if not is_on_floor():
		animated_sprite.play("jump")

func record():
	count += 1
	player_record[count] = [global_position, animated_sprite.flip_h, animated_sprite.animation]











