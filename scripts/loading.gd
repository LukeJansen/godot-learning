extends CanvasLayer

signal sceneFadedIn
signal sceneFadedOut

@onready var progressBar: ProgressBar = $Control/Panel/ProgressBar
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

@export var progress: float = 0.0

func _ready():
	animationPlayer.play("fadeIn");

func _process(delta):
	progressBar.value = ceil(lerpf(progressBar.value, progress, delta))
	if progressBar.value >= 100 and $Control/Panel.modulate.a > 0:
		animationPlayer.play("fadeOut")

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fadeIn":
			sceneFadedIn.emit()
		"fadeOut":
			sceneFadedOut.emit()
