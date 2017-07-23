extends KinematicBody2D

export var bounces = false
export var speed = 500
var velocity


func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	move(velocity * delta)
	if is_colliding():
		queue_free()
