extends Node	

# Eventually move this to player script and get it on ready.
var maxHealth = 10.0
var currentHealth = maxHealth
var maxSize
var healthBar

func _ready():
	healthBar = get_node("CanvasLayer/ColorRect")
	maxSize = healthBar.size.x
	
func _process(delta):
	var targetSize = maxSize * (currentHealth / maxHealth)
	healthBar.size.x = lerpf(healthBar.size.x, targetSize, 5 * delta)

func _on_player_health_change(health):
	currentHealth = health
