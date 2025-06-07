extends Sprite3D

func _ready():
	texture = $SubViewport.get_texture()

func update_healthbar(value) -> void:
	$SubViewport/HealthBar2d.update_healthbar(value)

func set_max_value(value) -> void:
	$SubViewport/HealthBar2d.max_value = value