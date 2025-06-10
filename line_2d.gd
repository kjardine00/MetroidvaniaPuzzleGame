extends Line2D

@export var collision_test: CharacterBody2D

# Gravity properties
@export var jump_height := 3.0
@export var jump_time_to_peak := 0.5
@export var jump_time_to_fall := 0.4

@onready var up_gravity := ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var down_gravity := ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_fall * jump_time_to_fall)) * -1.0

func update_trajectory(dir: Vector2, speed: float, delta: float) -> void:
	var max_points = 300
	clear_points()
	var pos: Vector2 = Vector2.ZERO
	var vel = dir * speed
	var bounce_count = 0  # Moved outside the loop to properly track bounces
	
	for i in max_points:
		add_point(pos)
		
		# Apply the same dual gravity system
		if vel.y < 0:
			vel.y += up_gravity * delta
		else:
			vel.y += down_gravity * delta
	
		var collision = collision_test.move_and_collide(vel * delta, true)
		if collision:
			bounce_count += 1
			vel = vel.bounce(collision.get_normal()) * 0.2
			if bounce_count >= 2:  # Changed to >= 2 to ensure exactly 2 bounces
				break

		pos += vel * delta
		collision_test.position = pos
