extends TextureProgressBar

var bar_red = preload("res://health-bar/barHorizontal_red_mid 200.png")
var bar_green = preload("res://health-bar/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://health-bar/barHorizontal_yellow_mid 200.png")

func update_healthbar(new_value: float) -> void:
	texture_progress = (
		bar_red if new_value < max_value * 0.35 else
		bar_yellow if new_value < max_value * 0.7 else
		bar_green
	)
	value = clampf(new_value, 0, max_value)