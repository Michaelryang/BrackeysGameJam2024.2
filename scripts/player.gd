extends CharacterBody2D

@export var move_speed: float = 10000.0

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
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var x_direction: float = Input.get_axis("move_left", "move_right")
	var y_direction: float = Input.get_axis("move_up", "move_down")
	
	velocity.x = x_direction * move_speed * delta
	velocity.y = y_direction * move_speed * delta
	
	#print(velocity)
	print(position)
	
	move_and_slide()
