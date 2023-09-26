extends CharacterBody2D


const SPEED = 300.0
const HIT_COOLDOWN = 1.5
var cooldown = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player

func _ready():
	player = get_node("../Player")


func _physics_process(delta):
	# Reduce cooldown to 0
	if cooldown > 0:
		cooldown -= delta
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	var playerLocation = player.position
	var direction = playerLocation.x - position.x
	#direction = 0
	
	if direction >= 5:
		velocity.x = SPEED
	elif direction <= -5:
		velocity.x = -SPEED
	else:
		velocity.x = 0
		
	$Icon.flip_h = velocity.x < 0

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		#print("I collided with ", collision.get_collider().name)
		if collider.name == "Player" and cooldown <= 0:
			collider.call("takeDamage", 1)
			cooldown = HIT_COOLDOWN
			
