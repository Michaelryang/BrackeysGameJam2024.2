class_name Player extends Node2D

@onready var player_body : CharacterBody2D = get_node("PlayerBody")
@onready var raft : Raft = get_tree().get_first_node_in_group("Raft")
@export var move_speed: float = 100.0
var interact_radius : float = 200.0

func _draw():
	draw_circle(player_body.position, interact_radius, Color("red"), false, 1.0)

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
		_deploy_anchor()
	elif event.is_action_released("drop_anchor"):
		print("end drop_anchor")
	

func _deploy_anchor() -> void:
	var anchor_scene : PackedScene = preload("res://scenes/anchor.tscn")
	var anchor = anchor_scene.instantiate()
	anchor.position = get_global_mouse_position()
	add_child(anchor)
	print(anchor)
	print(anchor.get_parent())
	print(anchor.position)
	print(player_body.position)
	
	if anchor.has_method("_activate"):
		anchor._activate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raft.sig_raft_moved.connect(_move_player)

func _move_player(delta_pos: Vector2) -> void:
	queue_redraw()
	player_body.position += delta_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var x_direction: float = Input.get_axis("move_left", "move_right")
	var y_direction: float = Input.get_axis("move_up", "move_down")
	
	#for _i in self.get_children():
	#	print(_i)
	
	player_body.velocity.x = x_direction * move_speed
	player_body.velocity.y = y_direction * move_speed
	
	#print(player_body.velocity)
	#print(position)
	
	player_body.move_and_slide()
