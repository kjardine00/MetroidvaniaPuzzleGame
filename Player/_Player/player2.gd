class_name Player extends CharacterBody2D

enum STATE { MOVE, CLIMB, ON_WALL, HURT }
@export var state : STATE = STATE.MOVE

@export var anchor: Node2D
@export var sprite: Sprite2D
@export var anim_player: AnimationPlayer
@export var wall_raycast_upper: RayCast2D
@export var wall_raycast_lower: RayCast2D
@export var hurtbox: Hurtbox
@export var camera: Camera2D
@export var interact_area: InteractionManager

@export var inv: Inventory
@export var stats: Stats:
	set(value):
		stats = value
		if value is not Stats: return
		stats = stats.duplicate()

@export_category("Movement Properties")
@export var max_speed := 75
@export var acceleration := 10000
@export var air_acceleration := 2000
@export var friction := 10000
@export var air_friction := 500

#region Gravity Calculations
@export var jump_height := 3.0
@export var jump_time_to_peak := 0.5
@export var jump_time_to_fall := 0.4
@export var wall_cut := 0.3

var coyote_time := 0.0

@onready var jump_vel := ((2.0 * (jump_height * Global.TILE_SIZE)) / jump_time_to_peak) * -1.0
@onready var up_gravity := ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var down_gravity := ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_fall * jump_time_to_fall)) * -1.0
#endregion

var pause_anim: bool = false

@onready var shaker := Shaker.new(sprite)

func _ready() -> void:
	stats.no_health.connect(func():
		queue_free()
		camera.reparent(get_tree().current_scene)
	)

	anim_player.animation_finished.connect(func(anim_name: String):
		match anim_name:
			"attack": pause_anim = false
			"wall_jump": pause_anim = false
			_: return
	)

	hurtbox.hurt.connect(func(other_hitbox: Hitbox):
		state = STATE.HURT

		var x_dir = sign(other_hitbox.global_position.direction_to(global_position).x)
		if x_dir == 0: x_dir = -1 
		velocity.x = x_dir * max_speed
		_jump(0.5)

		stats.health -= other_hitbox.damage

		shaker.shake(2.0, 0.3)
	)

func _physics_process(delta: float) -> void:
	match state:
		STATE.MOVE:
			coyote_time -= delta

			var x_input = Input.get_axis("move_left", "move_right")

			if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_time > 0):
				_jump()

			_apply_gravity(delta)

			if Input.is_action_just_pressed("attack"):
				pause_anim = true
				anim_player.play("attack")

			if x_input == 0:
				_apply_friction(delta)
			else:
				_accelerate_h(x_input, delta)
				anchor.scale.x = sign(x_input)

			var was_on_floor = is_on_floor()

			move_and_slide()

			if was_on_floor and not is_on_floor() and velocity.y >= 0:
					coyote_time = 0.2

			if _check_wall_latch():
				velocity.y = 0
				state = STATE.ON_WALL

			if Input.is_action_just_pressed("interact"):
				interact_area.interact(self)
			
		STATE.ON_WALL:
			var wall_normal = get_wall_normal()			
			var x_input = Input.get_axis("move_left", "move_right")

			_apply_wall_gravity(delta)

			move_and_slide()

			var request_detach: bool = (sign(x_input) == wall_normal.x)

			if Input.is_action_just_pressed("jump"):
				velocity.x = wall_normal.x * max_speed
				anchor.scale.x = sign(velocity.x)
				_jump()
				anim_player.play("wall_jump")
				state = STATE.MOVE

			if not _check_wall_latch() or request_detach: 
				state = STATE.MOVE

		STATE.CLIMB:
			var y_input = Input.get_axis("move_up", "move_down")
			velocity.y = y_input * max_speed * 0.8

			# Check if the player is no longer on climable surface / or jump is pressed tranisisiton to different state

		STATE.HURT:
			move_and_slide()
			_apply_friction(delta)
			_apply_gravity(delta)
			# AnimationPlayer should reset state to STATE.MOVE

	_animations(state)

#region Movement Functions
func _jump(jump_modifier: float = 1.0):
	velocity.y = jump_vel * jump_modifier

func _accelerate_h(h_dir: float, delta: float) -> void:
	var acceleration_amount = acceleration
	# if not is_on_floor(): acceleration_amount = air_acceleration

	velocity.x = move_toward(velocity.x, max_speed * h_dir, acceleration_amount * delta * abs(h_dir))

func _apply_friction(delta: float) -> void:
	var friction_amount = friction
	if not is_on_floor(): friction_amount = air_friction

	if abs(velocity.x) > 0.01:
		velocity.x = move_toward(velocity.x, 0, friction_amount * delta)

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += up_gravity * delta
		else:
			velocity.y += down_gravity * delta

func _apply_wall_gravity(delta: float) -> void:
	velocity.y += down_gravity * wall_cut * delta 

#endregion

func _check_wall_latch() -> bool:
	return (
		wall_raycast_upper.is_colliding() and
		wall_raycast_lower.is_colliding() and
		not is_on_floor() and 
		not anim_player.current_animation == "attack"
	)

func _animations(current_state: STATE = STATE.MOVE):
	match current_state:
		STATE.MOVE:
			if pause_anim: return
			# inAir animations
			if not is_on_floor():
				if velocity.y < 0:
					anim_player.play("jump")
				else:
					anim_player.play("fall")
			# onGround animations
			else:
				if velocity.x:
					anim_player.play("run")
				else: 
					anim_player.play("idle")
		
		STATE.ON_WALL:
			anim_player.play("wall_latch")

		STATE.CLIMB:
			if velocity.y == 0:
				anim_player.pause()
			else: 
				anim_player.play("climb")
		
		STATE.HURT:
			anim_player.play("hurt")
