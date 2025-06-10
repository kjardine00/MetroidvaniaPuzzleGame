class_name AttackComp extends Node2D

var player : Player
@export var trajectory_line: Line2D

func _ready() -> void: 
	player = get_owner() as Player

var projectile_speed: float = 125
var projectile_dir: Vector2 = Vector2(0.35, -0.93)

func _process(delta: float) -> void:

	## DEBUG CONTROLS TO FIGURE OUT PROJECTILE NUMBERS
	if Input.is_action_pressed("ui_left"):
		projectile_dir.x -= 1 * delta
	elif Input.is_action_pressed("ui_right"):
		projectile_dir.x += 1 * delta
	
	if Input.is_action_pressed("ui_up"):
		projectile_dir.y -= 1 * delta
	elif Input.is_action_pressed("ui_down"):
		projectile_dir.y += 1 * delta

	if Input.is_action_pressed("ui_page_up"):
		projectile_speed += 10 * delta
	elif Input.is_action_pressed("ui_page_down"):
		projectile_speed -= 10 * delta

	# projectile_dir = projectile_dir.normalized()
	trajectory_line.update_trajectory(projectile_dir, projectile_speed, delta)
		
func attack() -> void:
	## TODO: Remove this because there should be the default weapon and never a null weapon option
	if player.inv.active_item == null : return

	var weapon = player.inv.active_item
	print_debug("[AttackComp] Attacking with : " , weapon.name)

	if weapon.type == "Linear" : 
		_linear_projectile(weapon.projectile)
	elif weapon.type == "Arc" : 
		_arc_projectile(weapon.projectile)
	else : 
		_default_attack()


func _default_attack() -> void: 
	return

func _linear_projectile(item:) -> void: 
	return

func _arc_projectile(item) -> void:
	print_debug("[AttackComp] Speed: ", projectile_speed, "   Direction: ", projectile_dir)

	var inst = item.instantiate()
	inst.set_trajectory(projectile_dir.normalized(), projectile_speed)
	get_tree().get_root().add_child(inst)
	inst.global_position = player.global_position


#Speed: 22.7659972222225   Direction: (0.363376, -0.931643)
