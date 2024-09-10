extends CharacterBody2D

func _toggle_enabled(is_disabled: bool) -> void:
	for _i in get_children():
		if _i is CollisionShape2D:
			_i.disabled = is_disabled
