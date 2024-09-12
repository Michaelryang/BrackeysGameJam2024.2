extends CanvasModulate

@onready var weather_manager : WeatherManager = get_tree().get_first_node_in_group("WeatherManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weather_manager.canvas_color_change.connect(_set_color)
	pass # Replace with function body.
	
func _set_color(new_color : Color) -> void:
	color = new_color
