extends Node
class_name MovementController

@export_category("Connections")
@export var p: Player

@export_category("General Properties")
## Speed in tiles per second
@export var run_speed: float = 4
@export_group("Jump Props")
@export var jump_height: float = 3
@export var max_fall_speed: float = 8

var jump_time_to_peak: float = 0.5
var jump_time_to_descent: float = 0.4
var fast_fall_factor: float = 2.0
var cut_jump_factor: float = 0.5

var coyote_time: float = 0.2
var coyote_timer: float = 0.0
var coyote_active: bool = false

@onready var move_speed: float = run_speed * Global.TILE_SIZE # Will be calculated based on run_speed
@onready var jump_velocity: float = ((2.0 * (jump_height * Global.TILE_SIZE)) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var terminal_fall_velocity: float = max_fall_speed * Global.TILE_SIZE


func _physics_process(delta: float) -> void:
	p.velocity.y += get_gravity() * delta
	
	if p.velocity.y > terminal_fall_velocity:
		p.velocity.y = terminal_fall_velocity
	
	if p.is_on_floor():
		
		p.reset_jumps()
		coyote_active = true
		coyote_timer = coyote_time
	elif coyote_active:
		coyote_timer -= delta
		if coyote_timer <= 0:
			coyote_active = false
	
	p.velocity.x = p.x_dir_input * move_speed

	p.move_and_slide()


func get_gravity() -> float:
	if p.velocity.y < 0.0:
		return jump_gravity
	else:
		return fall_gravity


func jump(jump_modifier: float = 1.0) -> void:
	if p.jumps_available > 0:
		p.jumps_available -= 1
		p.velocity.y = jump_velocity * jump_modifier
		coyote_active = false
		print_debug("Jumping")

func jump_released() -> void:
	p.velocity.y = abs(cut_jump_factor * p.velocity.y)
