extends Node


func display_number(value:int, position: Vector2, is_critical: bool = false):
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 500
	number.label_settings = LabelSettings.new()
	var color = "#FFF"
	if is_critical:
		color = "#B22"
	if value == 0:
		color = "#FFF8"
	number.label_settings.font_color = color
	number.label_settings.font_size = 25
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	number.scale = Vector2(0.25, 0.25)
	call_deferred("add_child", number)
	await number.resized
	number.pivot_offset = -Vector2(number.size/5)
	var tween = get_tree().create_tween()
	
	tween.set_parallel(true)
	
	tween.tween_property(number, "modulate:a", 0, 0.5).set_ease(1)
	tween.tween_property(number, "position:y", number.position.y - 24, 0.75).set_ease(0)
	await tween.finished
	number.queue_free()
