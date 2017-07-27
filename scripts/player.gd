extends KinematicBody2D

const DASH_CD = 1 # Cooldown in seconds for the dash
const DASH_BOOST = 4 # Speed multiplier for the initial dash speed
const DASH_DECAY = 1.15 # Rate at which the velocity decays after dashing
const DASH_THRESHOLD = 1 # Speed at which the dash is considered over

const MELEE_OFFSET = 60 # Distance of the melee collider with the attacker
const MELEE_CD = 0.2 # Cooldown in seconds for the melee attacking

export var speed = 300 # Normal movement speed in pixels/s
export var maxHealth = 10 # Maximum health
export var melee_damage = 1
var health
var velocity = Vector2()
var dashTimer = DASH_CD
var dashing = false
var attacking = true
var attackTimer = MELEE_CD
var targetsInRange = []

func _ready():
	health = maxHealth
	set_fixed_process(true)
	
func _fixed_process(delta):
	# If in the middle of a dash, decelerate until velocity reaches threshold
	if dashing:
		move(velocity)
		velocity /= DASH_DECAY
		if velocity.length() <= DASH_THRESHOLD:
			dashing = false
	else:
		# Handle user input and set velocity
		velocity = Vector2()
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		velocity = velocity.normalized() * speed * delta
		
		# If the player can dash, give it a velocity boost and set it to dashing mode
		if Input.is_action_pressed("dash") and not dashing and dashTimer >= DASH_CD and velocity.length() != 0:
			dashing = true
			dashTimer = 0
			velocity *= DASH_BOOST
		elif dashTimer < DASH_CD:
			dashTimer += delta
			
		# If the player is attacking, move the attack collider using the position of the mouse and
		# set it to attacking mode. In attacking mode, it will get all targets which are in the
		# attack collision area and deal the appropriate damage. This has to be done one frame after
		# having moved the attack collider so all bodies entering after the movement are registered
		# correctly. After the attack, send the attacking to cooldown.
		if Input.is_action_pressed("attack") and not attacking and attackTimer >= MELEE_CD:
			var direction = (get_global_mouse_pos() - get_pos()).normalized()
			get_node("attackArea").set_pos(direction * MELEE_OFFSET)
			attacking = true
		elif attacking:
			for target in targetsInRange:
				if target.is_in_group("Enemy"):
					target.call("damage", melee_damage)
			attacking = false
			attackTimer = 0
		else:
			attackTimer += delta
			
	move(velocity)

func damage(amount):
	health -= amount
	if health <= 0:
		# Die
		queue_free()
	elif health > maxHealth:
		health = maxHealth

func _on_attackArea_body_enter(body):
	targetsInRange.append(body)

func _on_attackArea_body_exit(body):
	targetsInRange.erase(body)
