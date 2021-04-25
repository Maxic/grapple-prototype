extends KinematicBody2D

const JUMP_FORCE = 550			# Force applied on jumping
const MOVE_SPEED = 300			# Speed to walk with
const GRAVITY = 30				# Gravity applied every second
const MAX_SPEED = 2000			# Maximum speed the player is allowed to move
const FRICTION_AIR = 0.95		# The friction while airborne
const FRICTION_GROUND = 0.85	# The friction while on the ground
var CHAIN_PULL = 50

var velocity = Vector2(0,0)		# The velocity of the player (kept over time)
var chain_velocity := Vector2(0,0)
var can_jump = false			# Whether the player used their air-jump
var pull = false

func _ready():
	var ui_node = get_node("/root/main/UI")
	ui_node.connect("hook_pull_change", self, "handle_hook_pull_change")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print(event.button_index)
		if event.button_index == 1 and event.pressed and $Chain.flying == false and $Chain.hooked == false:
			# We clicked the mouse -> shoot()
			$Chain.shoot(event.position - get_viewport().size * 0.5)
		if event.button_index == 1 and event.pressed and $Chain.hooked == true:
			pull = true
		elif event.button_index == 2 and event.pressed:
			# We released the mouse -> release()
			$Chain.release()
		else:
			pull = false

func _physics_process(_delta: float) -> void:

	# Get input
	var action_strength_right = Input.get_action_strength("right")
	var action_strength_left = Input.get_action_strength("left")
	var walk = (action_strength_right - action_strength_left) * MOVE_SPEED

	# Falling
	velocity.y += GRAVITY

	# Hook physics
	if pull:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != sign(walk):
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			chain_velocity.x *= 0.7
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
	velocity += chain_velocity

	# apply the walking
	velocity.x += walk		
	move_and_slide(velocity, Vector2.UP)	# Actually apply all the forces
	velocity.x -= walk		# take away the walk speed again
	# ^ This is done so we don't build up walk speed over time

	# Manage max speed
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	# refresh jump and stuff
	var grounded = is_on_floor()
	if grounded:
		velocity.x *= FRICTION_GROUND	# Apply friction only on x (we are not moving on y anyway)
		can_jump = true 				# We refresh our air-jump
		if velocity.y >= 5:		# Keep the y-velocity small such that
			velocity.y = 5		# gravity doesn't make this number huge
	elif is_on_ceiling() and velocity.y <= -5:	# Same on ceilings
		velocity.y = -5

	# Apply air friction
	if !grounded:
		velocity.x *= FRICTION_AIR
		if velocity.y > 0:
			velocity.y *= FRICTION_AIR

	# Jumping
	if Input.is_action_just_pressed("jump"):
		if grounded:
			velocity.y = -JUMP_FORCE	# Apply the jump-force
		elif can_jump:
			can_jump = false	# Used air-jump
			velocity.y = -JUMP_FORCE
	
	# Update the Sprite
	if action_strength_right > 0:
		$AnimatedSprite.play('run')
		$AnimatedSprite.flip_h = false
	elif action_strength_left:
		$AnimatedSprite.play('run')
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play('idle')
	
func handle_hook_pull_change(value):
	CHAIN_PULL = value
