class_name Heart extends CharacterBody2D

@export var collection_area: Area2D

func _ready() -> void:
	collection_area.body_entered.connect(func(_body: Player): 
		# print_debug("[Heart] heart should be collected by : " + _body.name)
		_body.stats.add_health(1)
		queue_free()
	)

func _physics_process(delta: float) -> void:
	## TODO: Revisit this, I want the heart to be very floaty
	velocity.y += 25 * delta

	move_and_slide()

## TODO: I want to make it so the heart kinda sways back and forth as it falls