extends Node

## Variables
# Eventually move this to player script and get it on ready.
var maxHealth = 10.0
var currentHealth = maxHealth
var maxSize
var healthBar
var healthDamage

## Private Functions
## Ready function called when node is initiated
func _ready():
	healthBar = get_node("CanvasLayer/HealthContainer/HealthBar")
	healthDamage = get_node("CanvasLayer/HealthContainer/HealthBar/HealthDamage")
	maxSize = healthBar.size.x

## Process function called every frame
func _process(delta):
	if healthDamage.size.x > 0:
		healthDamage.size.x = lerpf(healthDamage.size.x, 0, 5 * delta)

## Signal Functions
## Function called from healthChange signal on Player
func _on_player_health_change(health):
	var previousHealth = currentHealth
	currentHealth = health
	
	var targetSize = maxSize * (currentHealth / maxHealth)
	healthDamage.position.x = targetSize
	healthDamage.size.x = maxSize * ((previousHealth - currentHealth)/maxHealth)
	
	healthBar.size.x = targetSize;
