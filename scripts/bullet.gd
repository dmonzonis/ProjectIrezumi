extends KinematicBody2D

export var damageValue = 1
var bounces # If true, will bounce on collision with environment instead of exploding
var velocity

func _ready():
	add_to_group("Bullet")
	
func _fixed_process(delta):
	# TODO: check colliding object type to deal damage
	if is_colliding():
		# Check if the collider is the player, damage it and destroy the bullet if it is
		var other = get_collider()
		if other.is_in_group("Player"):
			other.call("damage", damageValue)
			queue_free()
			return
		# If the bullet bounces, get the normal of the collision and compute the new reflected direction using simple math
		if bounces:
			var normal = get_collision_normal()
			velocity -= 2 * velocity.dot(normal) * normal
		else:
			queue_free()
	
	move(velocity * delta)

# Signal received when the timer reaches lifeTime. Destroys the bullet.
func _on_timer_timeout():
	queue_free()

# Utility function to initialize the projectile, setting its velocity and starting the timer
func initialize(position, direction, speed, lifeTime = 2, _bounces = false):
	bounces = _bounces
	set_pos(position)
	velocity = direction.normalized() * speed
	# Start the timer after which the bullet is destroyed
	get_node("timer").set_wait_time(lifeTime)
	get_node("timer").start()
	set_fixed_process(true)
	