class_name WeatherManager extends Node2D

@onready var level = get_tree().get_first_node_in_group("Levels")
@onready var ui_layer = get_tree().get_first_node_in_group("UILayer")
@export var world_canvas_modulate : CanvasModulate
@export var time_scale : float = 3600.0 # seconds per real life second
@export var minimum_global_light : float = 0.5
@export var night_color : Color = Color.BLUE
@export var dawn_color : Color = Color.GREEN
@export var dusk_color : Color = Color.GREEN
@export var day_color : Color = Color.WHITE

# start lerp night and dawn
@export var start_dawn_hr : float = 5.0
@export var dawn_length_hrs: float = 2.0

@export var start_dusk_hr : float = 18.0
@export var dusk_length_hrs : float = 2.0

enum WeatherState {WEATHER_CLEAR, WEATHER_RAINY, WEATHER_STORMY}
@export var weather = WeatherState.WEATHER_CLEAR

var days_survived : int = 0
var time_of_day: float = 0.0
var global_light_scale = 1.0
const seconds_in_day = 86400
var debug_text : RichTextLabel

signal canvas_color_change(new_color : Color)

func _ready() -> void:
	world_canvas_modulate = CanvasModulate.new()
	#get_parent().add_child(world_canvas_modulate)
	add_child(world_canvas_modulate)
	world_canvas_modulate.color = Color.WHITE
	debug_text = ui_layer.get_node("DebugText")

func _current_hour(time : float = time_of_day) -> int:
	return int(time / ( 60 * 60 ))

func _hrs_to_secs(hrs : float) -> float:
	return hrs * 60 * 60
	
func _secs_to_hrs(secs : float) -> float:
	return secs / 3600

func _is_night(time : float = time_of_day) -> bool:
	var dawn_secs = _hrs_to_secs(start_dawn_hr)
	var dawn_length_secs = _hrs_to_secs(dawn_length_hrs)
	var dusk_secs =  _hrs_to_secs(start_dusk_hr)
	var dusk_length_secs = _hrs_to_secs(dusk_length_hrs)
	
	return time < dawn_secs + dawn_length_secs / 2.0 || time > dusk_secs + dusk_length_secs / 2.0
	
func _is_day(time : float = time_of_day) -> bool:
	return !_is_night()

func _is_dawn(time : float = time_of_day) -> bool:
	return time >= _hrs_to_secs(start_dawn_hr) && time <= _hrs_to_secs(start_dawn_hr + dawn_length_hrs)

func _is_dusk(time : float = time_of_day) -> bool:
	return time >= _hrs_to_secs(start_dusk_hr) && time <= _hrs_to_secs(start_dusk_hr + dusk_length_hrs)

func _get_world_color(time_of_day: float) -> Color:
	var color : Color
	if _is_night():
		if _is_dawn():
			var weight = (time_of_day - _hrs_to_secs(start_dawn_hr)) / (_hrs_to_secs(dawn_length_hrs) / 2.0)
			color = lerp(night_color, dawn_color, weight)
		elif _is_dusk():
			var weight = (time_of_day - _hrs_to_secs(start_dusk_hr + dusk_length_hrs / 2.0)) / (_hrs_to_secs(dusk_length_hrs) / 2.0)
			color = lerp(dusk_color, night_color, weight)
		else:
			color = night_color
	else:
		if _is_dawn():
			var weight = (time_of_day - _hrs_to_secs(start_dawn_hr + dawn_length_hrs / 2.0)) / (_hrs_to_secs(dawn_length_hrs) / 2.0)
			color = lerp(dawn_color, day_color, weight)
		elif _is_dusk():
			var weight = (time_of_day - _hrs_to_secs(start_dusk_hr)) / (_hrs_to_secs(dusk_length_hrs) / 2.0)
			color = lerp(day_color, dusk_color, weight)
		else:
			color = day_color
	
	return color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_of_day += delta * time_scale
	if time_of_day > seconds_in_day:
		days_survived += 1
		time_of_day -= seconds_in_day
		print(days_survived)
	
	global_light_scale = -cos(time_of_day * 2 * PI / seconds_in_day)
	global_light_scale = lerp(minimum_global_light, 1.0, (global_light_scale + 1.0)/2.0)
	
	world_canvas_modulate.color = _get_world_color(time_of_day) * global_light_scale
	world_canvas_modulate.color.a = 1.0
	
	canvas_color_change.emit(world_canvas_modulate.color)
	
	debug_text.text = " is night: " + str(_is_night()) 
	debug_text.text += "\n is dawn: " + str(_is_dawn())
	debug_text.text += "\n is day: " + str(_is_day())
	debug_text.text += "\n is dusk: " + str(_is_dusk())
	debug_text.text += "\n time: " + str(days_survived) + " days, " + str(int(_secs_to_hrs(time_of_day))) + " hours"
	debug_text.text += "\n weather: " + WeatherState.keys()[weather] 
	#print(time_of_day)
