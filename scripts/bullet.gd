extends KinematicBody2D

var lifeTime = 2 # Time after which the bullet disappears in seconds
var bounces = false # If true, will bounce on collision with environment instead of exploding
var velocity

func _ready():
	set_fixed_process(true)
	get_node("timer").set_wait_time(lifeTime)
	get_node("timer").start()
	
func _fixed_process(delta):
	move(velocity * delta)
	# TODO: check colliding object type to deal damage
	if is_colliding():
		# If the bullet bounces, get the normal of the collision and compute the new reflected direction using simple math
		if bounces:
			var normal = get_collision_normal()
			velocity -= 2 * velocity.dot(normal) * normal
		else:
			queue_free()

# Signal received when the timer reaches lifeTime. Destroys the bullet.
func _on_timer_timeout():
	queue_free()

# Utility function to initialize the projectile's variables
func initialize(direction, speed, _lifeTime = 2, _bounces = false):
	lifeTime = _lifeTime
	bounces = _bounces
	velocity = direction.normalized() * speed