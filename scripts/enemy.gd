extends KinematicBody2D

export var maxHealth = 5
var health

func _ready():
	health = maxHealth
	add_to_group("Enemy")

func damage(amount):
	health -= amount
	if health <= 0:
		# Die
		queue_free()
	elif health > maxHealth:
		health = maxHealth
