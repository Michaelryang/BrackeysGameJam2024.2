extends ColorRect

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	material.set("shader_parameter/rain_amount", 200.0)
