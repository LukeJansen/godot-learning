extends CharacterBody2D

## Constants
const SPEED = 150.0
const JUMPVELOCITY = 400
const HIT_COOLDOWN = 1.5

## Variables
var cooldown = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var player: Node2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

## Private Functions
## Ready function called when node is initiated
func _ready():
	call_deferred("_navSetup")
	#_updateNavAgent()

func _navSetup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	_updateNavAgent()
	$NavPathUpdate.start()
## Process function called every frame
func _process(delta):
	# Reduce cooldown to 0
	if cooldown > 0:
		cooldown -= delta

## Process function called every frame
func _physics_process(delta):
	_handleMovement(delta)
	_handleCollision()
	_handleAnimation()
	
			
func _handleMovement(delta):

	if navigation_agent.is_navigation_finished():
		return

	var nextPathPosition: Vector2 = navigation_agent.get_next_path_position()

	var newVelocity: Vector2 = nextPathPosition - global_position
	newVelocity = newVelocity.normalized()
	
	if newVelocity.y < 0 and is_on_floor(): 
		velocity.y = -JUMPVELOCITY
	elif not is_on_floor():
		velocity.y += gravity * delta
	
	newVelocity = newVelocity * SPEED

	velocity.x = newVelocity.x
	move_and_slide()
	
func _handleCollision():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		#print("I collided with ", collision.get_collider().name)
		if collider.name == "Player" and cooldown <= 0:
			collider.call("takeDamage", 1)
			cooldown = HIT_COOLDOWN
			
func _handleAnimation():
	$Icon.flip_h = velocity.x < 0
	
func _updateNavAgent():
	$NavigationAgent2D.set_target_position(player.global_position)
	
