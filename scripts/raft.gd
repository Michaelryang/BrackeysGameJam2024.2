class_name Raft extends Node2D

@onready var raft_body : CharacterBody2D = get_node("RaftBody")
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("Player")
var anchor : Anchor = null

signal moved(v : Vector2)

func set_anchored(anchor : Anchor = null):
	self.anchor = anchor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _move_raft(v: Vector2) -> void:
	var old_position = raft_body.position
	raft_body.velocity = v
	
	#if anchor:
	#	raft_body.velocity *= anchor.speed_multiplier
	#	raft_body.move_and_slide()
	#	if raft_body.position.distance_squared_to(old_position) > anchor.anchor_radius * anchor.anchor_radius:
	#		raft_body.position = old_position
	#else:
	#	raft_body.move_and_slide()
	raft_body.move_and_slide()

	#moved.emit(raft_body.position - old_position)
	var delta_pos = raft_body.position - old_position
	print(delta_pos)
	
	for _i in self.get_children():
		if _i.name != "RaftBody":
			if _i is CharacterBody2D:
				_i.position += delta_pos
				
	player.position += delta_pos
	

func _physics_process(delta: float) -> void:
	_move_raft(Vector2(20, 0))
	print("raft position")
	print(position)
	print("raftbody position")
	print($RaftBody.position)
	
	pass
