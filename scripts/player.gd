extends CharacterBody2D

signal healthChange(health)

@export var SPEED = 300.0
@export var JUMP_HEIGHT = 400.0
@export var ATTACK_COOLDOWN = 1

var health = 10
var attackRange = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Emit Starting Health
	healthChange.emit(health)
	
	# Resize Attack Hit Box
	var playerSize = $Icon.get_rect().size
	var attackArea = get_node("AttackArea/CollisionShape2D")
	attackArea.shape.size.y = playerSize.y
	attackArea.shape.size.x = attackRange
	attackArea.position.x = (playerSize.x / 2) + (attackArea.shape.size.x / 2) + 1
	
	
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		print($AttackArea.get_overlapping_bodies())
		

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_HEIGHT

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("move_left"):
		$Icon.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		$Icon.flip_h = false

	move_and_slide()
	
func takeDamage(damage):
	health = clamp((health - damage), 0, health)
	healthChange.emit(health)
