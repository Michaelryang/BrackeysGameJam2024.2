class_name Anchor extends Node2D

@onready var raft : Raft = get_tree().get_first_node_in_group("Raft")
var num_uses : int = 1
var speed_multiplier : float = 0.8
@export var anchor_radius : float = 70.0

signal sig_anchor_dropped(anchor: Anchor)

func _activate() -> void:
	print("anchor activated")
	sig_anchor_dropped.connect(raft.set_anchored)
	_drop_anchor()
	
func _process(delta: float) -> void:
	pass

func _drop_anchor() -> void:
	sig_anchor_dropped.emit(self)
	num_uses -= 1

func _reel_anchor() -> void:
	sig_anchor_dropped.emit(null)
	if num_uses <= 0:
		queue_free()
	
func _ready() -> void:
	pass
