class_name Hitbox extends Area2D

@export var damage := 1.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	assert(area is Hurtbox, "The hitbox detected an area that wasn't a hurtbox.")
	var hurtbox = area as Hurtbox
	hurtbox.take_hit(self)
