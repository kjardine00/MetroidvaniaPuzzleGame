class_name Projectile extends CharacterBody2D

@export var dir : Vector2 = Vector2.ZERO
@export var speed : float = 1200.00
@export var rotation_speed : float = 500.0  # Degrees per second

# Gravity properties
@export var jump_height := 3.0
@export var jump_time_to_peak := 0.5
@export var jump_time_to_fall := 0.4

@onready var up_gravity := ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var down_gravity := ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_fall * jump_time_to_fall)) * -1.0

var bounce_count := 0  # Track number of bounces
var has_bounced := false  # Track if projectile has bounced

func _ready() -> void:
	set_trajectory(dir, speed)

func _physics_process(delta) -> void:
	_apply_gravity(delta)
	
	if not has_bounced:
		rotation += deg_to_rad(rotation_speed * delta)
	
	var collision = move_and_collide(velocity * delta)
	if not collision: 
		return

	if bounce_count < 2:  # Only bounce if we haven't hit the limit
		bounce_count += 1
		has_bounced = true  # Stop rotation after first bounce
		velocity = velocity.bounce(collision.get_normal()) * 0.2

func set_trajectory(dir: Vector2, speed: float) -> void:
	self.dir = dir
	self.speed = speed
	velocity = dir * speed
	
func _apply_gravity(delta: float) -> void:
	if velocity.y < 0:
		velocity.y += up_gravity * delta
	else:
		velocity.y += down_gravity * delta
	
