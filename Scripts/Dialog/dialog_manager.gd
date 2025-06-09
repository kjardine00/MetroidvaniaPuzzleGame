extends Node

@onready var dialog_box = preload("res://UI/dialog_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index := 0

var text_box
var text_box_position: Vector2

var active_dialog := false
var can_advance := false

func on_interact_action(lines: Array[String], position: Vector2) -> void:
	if active_dialog:
		continue_dialog()
	else: 
		_start_dialog(lines, position)

func _start_dialog(lines: Array[String], position: Vector2) -> void:
	if active_dialog:
		return
	
	dialog_lines = lines
	text_box_position = position
	_show_dialog_box()

	active_dialog = true
	current_line_index = 0

func _show_dialog_box() -> void:
	text_box = dialog_box.instantiate()
	text_box.finished_displaying_text.connect(func(): 
		can_advance = true)
	get_tree().current_scene.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])

	can_advance = false

func continue_dialog() -> void:
	if active_dialog and can_advance:
		text_box.queue_free()

		current_line_index += 1

		if current_line_index >= dialog_lines.size():
			active_dialog = false
			current_line_index = 0
			return

		_show_dialog_box()

func close_dialog() -> void:
	if active_dialog:
		text_box.queue_free()
		active_dialog = false
		current_line_index = 0
