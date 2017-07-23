extends KinematicBody2D

export var lifeTime = 2 # Time after which the bullet disappears
export var bounces = false # If true, will bounce on collision with environment instead of exploding
export var speed = 500 # Speed of the bullet in pixels/s
var velocity


func _ready():
	set_fixed_process(true)
	get_node("timer").set_wait_time(lifeTime)
	get_node("timer").start()
	
func _fixed_process(delta):
	move(velocity * delta)
	if is_colliding():
		# If the bullet bounces, get the normal of the collision and compute the new reflected direction using simple math
		if bounces:
			var normal = get_collision_normal()
			velocity -= 2 * velocity.dot(normal) * normal
		else:
			queue_free()

func _on_timer_timeout():
	queue_free()
