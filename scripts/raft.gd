class_name Raft extends Node2D

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var raft_body : CharacterBody2D = get_node("RaftBody")

signal raft_moved(delta_pos: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _move_raft(v: Vector2, delta: float) -> void:
	var old_position = raft_body.position
	raft_body.velocity = v * delta
	raft_body.move_and_slide()
	var delta_pos = raft_body.position - old_position
	
	for _i in self.get_children():
		if _i.name != "RaftBody":
			if _i is CharacterBody2D:
				_i.position += delta_pos
				
	raft_moved.emit(delta_pos)
	

func _physics_process(delta: float) -> void:
	_move_raft(Vector2(2000, 2000), delta)
	pass
 
