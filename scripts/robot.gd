class_name Player extends CharacterBody2D

@onready var raft : Raft = get_tree().get_first_node_in_group("Raft")
@export var move_speed: float = 100.0
@onready var mouse_collider : Area2D = get_tree().get_first_node_in_group("MouseCollider")
var interact_radius : float = 200.0
var on_raft : bool = true

func _draw():
	draw_circle(Vector2(0,0), interact_radius, Color("red"), false, 1.0)

func _input(event):
	#print(event.as_text())
	
	if event.is_action_pressed("move_left"):
		print("move_left")
	elif event.is_action_released("move_left"):
		print("end move_left")
	elif event.is_action_pressed("move_right"):
		print("move_right")
	elif event.is_action_released("move_right"):
		print("end move_right")
	elif event.is_action_pressed("move_up"):
		print("move_up")
	elif event.is_action_released("move_up"):
		print("end move_up")
	elif event.is_action_pressed("move_down"):
		print("move_down")
	elif event.is_action_released("move_down"):
		print("end move_down")
	elif event.is_action_pressed("drop_anchor"):
		print("drop_anchor")
		_toggle_anchor()
	elif event.is_action_released("drop_anchor"):
		print("end drop_anchor")
	elif event.is_action_pressed("switch_raft_land"):
		print("switch raft/land")
		_switch_raft_land()
	elif event.is_action_released("switch_raft_land"):
		print("end switch raft/land")

func _toggle_anchor() -> void:
	if !on_raft:
		return
	
	if raft.anchor:
		raft.anchor._reel_anchor()
	else:
		var anchor_scene : PackedScene = preload("res://scenes/anchor.tscn")
		var anchor : Anchor = anchor_scene.instantiate()
		anchor.position = get_global_mouse_position()
		get_parent().add_child(anchor)
		
		if anchor.has_method("_activate"):
			anchor._activate()

func _raft_to_land() -> void:
	var clicked_cell = %LandLayer.local_to_map(%LandLayer.get_local_mouse_position())
	var data = %LandLayer.get_cell_tile_data(clicked_cell)
	#if data:
	#	return data.get_custom_data("power")
	#else:
	#	return 0
	#var tile_coords = %LandLayer.local_to_map(%LandLayer.to_local(position))
	print(clicked_cell)
	print(data)
	if !data:
		return
		
	on_raft = false
	position = get_global_mouse_position()
	raft._disable_raft_player_border(true)
	set_collision_mask_value(1, true)
	
func _land_to_raft() -> void:
	var object_list = mouse_collider._get_objects_at_mouse()
	print(object_list)
	for _i in object_list:
		if _i.get_parent() is Raft:
			position = get_global_mouse_position()
			on_raft = true
			raft._disable_raft_player_border(false)
			set_collision_mask_value(1, false)
	
func _switch_raft_land() -> void:
	if !raft.anchor:
		# need anchor
		return
	
	var mouse_position = get_global_mouse_position()
	
	if position.distance_to(mouse_position) > interact_radius:
		# too far
		return
	
	if on_raft:
		_raft_to_land()
	else:
		_land_to_raft()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raft.moved.connect(_move_player_from_raft)
	var propeller_scene : PackedScene = preload("res://scenes/hand_propeller.tscn")
	var propeller : Propeller = propeller_scene.instantiate()
	add_child(propeller)


func _move_player_from_raft(v: Vector2) -> void:
	if on_raft:
		position += v
	queue_redraw()

func _physics_process(delta: float) -> void:
	var x_direction: float = Input.get_axis("move_left", "move_right")
	var y_direction: float = Input.get_axis("move_up", "move_down")
	
	velocity.x = x_direction * move_speed
	velocity.y = y_direction * move_speed
	
	move_and_slide()
