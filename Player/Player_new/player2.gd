extends CharacterBody2D

enum STATE { MOVE, CLIMB }

@export var anchor: Node2D
@export var anim_player: AnimationPlayer

@export_category("Movement Properties")
@export var max_speed := 75
@export var acceleration := 1000
@export var air_acceleration := 1500
@export var friction := 1000
@export var air_friction := 500

#region Gravity Calculations
@export var jump_height := 3.0
@export var jump_time_to_peak := 0.5
@export var jump_time_to_fall := 0.4

var coyote_time := 0.0

@onready var jump_vel := ((2.0 * (jump_height * Global.TILE_SIZE)) / jump_time_to_peak) * -1.0
@onready var up_gravity := ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var down_gravity := ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_fall * jump_time_to_fall)) * -1.0
#endregion

var state : STATE = STATE.MOVE
var pause_anim: bool = false

func _ready() -> void:
	anim_player.animation_finished.connect(func(anim_name: String):
		if anim_name == "attack": pause_anim = false
	)

func _physics_process(delta: float) -> void:
	match state:
		STATE.MOVE:
			coyote_time -= delta

			var x_input = Input.get_axis("move_left", "move_right")

			if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_time > 0):
				velocity.y = jump_vel

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

		STATE.CLIMB:
			pass

	_animations()

func _accelerate_h(h_dir: float, delta: float) -> void:
	var acceleration_amount = acceleration
	if not is_on_floor(): acceleration_amount = air_acceleration

	velocity.x = move_toward(velocity.x, max_speed * h_dir, acceleration_amount * delta * abs(h_dir))

func _apply_friction(delta: float) -> void:
	var friction_amount = friction
	if not is_on_floor(): friction_amount = air_friction

	if is_on_floor() and abs(velocity.x) > 0.01:
		velocity.x = move_toward(velocity.x, 0, friction_amount * delta)

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += up_gravity * delta
		else:
			velocity.y += down_gravity * delta

func _animations():
	if pause_anim: return
	
	# Air animations
	if not is_on_floor():
		if velocity.y < 0:
			anim_player.play("jump")
		else:
			anim_player.play("fall")
	# Ground animations
	else:
		if velocity.x:
			anim_player.play("run")
		else: 
			anim_player.play("idle")
