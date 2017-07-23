extends KinematicBody2D

export var speed = 300
var velocity = Vector2()

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	velocity = Vector2(0, 0)
	if (Input.is_action_pressed("move_up")):
		velocity.y -= 1
	if (Input.is_action_pressed("move_down")):
		velocity.y += 1
	if (Input.is_action_pressed("move_left")):
		velocity.x -= 1
	if (Input.is_action_pressed("move_right")):
		velocity.x += 1
	velocity = velocity.normalized() * speed * delta
	move(velocity)

