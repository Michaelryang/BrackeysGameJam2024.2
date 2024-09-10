class_name Raft extends Node2D

@onready var raft_body : CharacterBody2D = get_node("RaftBody")
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("Player")
var anchor : Anchor = null
var raft_anchor_point : Vector2 # this is NOT the anchor position, but rather the position of the raft when the anchor is dropped

signal moved(v : Vector2) # signal from raft movement

func _draw() -> void:
	if anchor:
		#print
		#print("anchor point")
		#print(raft_anchor_point)
		#print("raft pos")
		#print(raft_body.position)
		#print(raft_anchor_point - raft_body.position)
		draw_circle(Vector2(0,0), anchor.anchor_radius, Color("orange"), false, 2.0)
		draw_line(Vector2(0,0), raft_body.position - raft_anchor_point, Color("yellow"), 5.0)

func set_anchored(new_anchor : Anchor = null):
	self.anchor = new_anchor
	
	if new_anchor:
		raft_anchor_point = raft_body.position
		queue_redraw()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _move_raft(v: Vector2, delta: float) -> void:
	var old_position = raft_body.position
	raft_body.velocity = v
	
	if anchor:
		raft_body.velocity *= anchor.speed_multiplier
		if (raft_body.position + raft_body.velocity * delta).distance_squared_to(raft_anchor_point) > anchor.anchor_radius * anchor.anchor_radius:
			return
		else:
			raft_body.move_and_slide()
	else:
		raft_body.move_and_slide()
	#raft_body.move_and_slide()

	#moved.emit(raft_body.position - old_position)
	var delta_pos = raft_body.position - old_position
	#print(delta_pos)
	
	for _i in self.get_children():
		if _i.name != "RaftBody":
			if _i is CharacterBody2D:
				_i.position += delta_pos
				
	#player.position += delta_pos
	moved.emit(delta_pos)
	

func _disable_raft_player_border(is_disabled: bool) -> void:
	$PlayerCageBody._toggle_enabled(is_disabled)


func _physics_process(delta: float) -> void:
	_move_raft(Vector2(20, 20), delta)
	#print("raft position")
	#print(position)
	#print("raftbody position")
	#print($RaftBody.position)
	queue_redraw()
	pass
