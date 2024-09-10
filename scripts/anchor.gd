class_name Anchor extends Node2D

@onready var raft : Raft = get_tree().get_first_node_in_group("Raft")
var num_uses : int = 1
var speed_multiplier : float = 0.1
@export var anchor_radius : float = 30.0

signal sig_anchor_dropped(anchor: Anchor)

func _draw():
	draw_circle(position, anchor_radius, Color("green"), false, 1.0)

func _activate() -> void:
	print("anchor activated")
	sig_anchor_dropped.connect(raft.set_anchored)
	_drop_anchor()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _drop_anchor() -> void:
	sig_anchor_dropped.emit(self)
	num_uses -= 1

func _reel_anchor() -> void:
	sig_anchor_dropped.emit(null)
	if num_uses <= 0:
		queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
