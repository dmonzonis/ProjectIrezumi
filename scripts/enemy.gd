extends KinematicBody2D

export var maxHealth = 5
export var speed = 200
var health

func _ready():
	health = maxHealth
	add_to_group("Enemy")
	set_fixed_process(true)
	
func _fixed_process(delta):
	var player = get_parent().get_node("player")
	var direction = (player.get_pos() - get_pos()).normalized()
	var velocity = direction * speed * delta
	move(velocity)
	
func damage(amount):
	health -= amount
	if health <= 0:
		# Die
		queue_free()
	elif health > maxHealth:
		health = maxHealth
