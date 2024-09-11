class_name Propeller extends Node2D

var direction_normal : Vector2
@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var raft : Raft = get_tree().get_first_node_in_group("Raft")

var active : bool = false
signal applied_propel_force(accel : Vector2)

# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("propel"):
		active = true
	if event.is_action_released("propel"):
		active = false
		
		

func _ready() -> void:
	applied_propel_force.connect(raft._apply_acceleration)
	pass # Replace with function body.

func _apply_propel() -> void:
	applied_propel_force.emit(-direction_normal * 2000)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	direction_normal = (mouse_position - player.position).normalized()
	#print(direction_normal)
	#print(rad_to_deg(direction_normal.angle()))
	rotation = Vector2.UP.angle_to(direction_normal)
	if active:
		_apply_propel()
