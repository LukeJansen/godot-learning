extends CharacterBody2D

## Signals
signal healthChange(health)

## Exported Variables
@export var SPEED = 300.0
@export var JUMP_HEIGHT = 400.0
@export var ATTACK_COOLDOWN = 1

## Variables
var sprite
var health = 10
var attackRange = 100
var isInAir = false
## Get the global gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## Private Functions
## Ready function called when node is initiated
func _ready():
	
	# Emit Starting Health
	healthChange.emit(health)
	
	# Get Sprite reference
	sprite = $Sprite
	
	# Resize Attack Hit Box
	var playerSize = (sprite.sprite_frames.get_frame_texture("default", 0).get_size()) * sprite.scale
	var attackArea = get_node("AttackArea/CollisionShape2D")
	attackArea.shape.size.y = playerSize.y
	attackArea.shape.size.x = attackRange
	attackArea.position.x = (playerSize.x / 2) + (attackArea.shape.size.x / 2) + 1

## Process function called every frame
func _process(_delta):
	# Check for attack button press
	if Input.is_action_just_pressed("attack"):
		print($AttackArea.get_overlapping_bodies())
		

## Physics function called 60 times per second
func _physics_process(delta):
	# Call handle functions
	_handleMovement(delta)
	_handleAnimation()

## Function to handle all movement calculations
func _handleMovement(delta):
	# Add gravity to the player if they are not on floor
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_HEIGHT
		isInAir = true
	
	# Get the input direction and handle the movement/deceleration
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

## Function to handle all animation
func _handleAnimation():
	if isInAir and is_on_floor():
		sprite.animation = 'land'
	elif velocity.y < 0:
		sprite.animation = "jump"
	elif velocity.y > 0:
		sprite.animation = 'fall'
	elif velocity.x != 0 and is_on_floor():
		sprite.animation = 'walk'
	else:
		sprite.animation = 'default'
	sprite.play()
	
	if Input.is_action_just_pressed("move_left"):
		sprite.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		sprite.flip_h = false 

## Signal Functions
## Function called when sprite animation finished
func _on_icon_animation_finished():
	# When 'land' animation finishes mark player as not in air
	if sprite.animation == 'land':
		isInAir = false
		
## Public Functions
## Function to be called from other nodes to apply damage to Player
func takeDamage(damage):
	health = clamp((health - damage), 0, health)
	healthChange.emit(health)
