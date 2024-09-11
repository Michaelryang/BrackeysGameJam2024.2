extends Area2D

func _get_objects_at_mouse() -> Array[Area2D]:
	position = get_global_mouse_position()
	return get_overlapping_areas()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position()
