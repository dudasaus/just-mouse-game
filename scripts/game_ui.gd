extends Control

@export var player: Node2D

func _process(delta: float) -> void:
	if player.mode == player.Mode.SHOOTING:
		%ShootForceBar.show()
		%ShootForceBar.value = player.shoot_force / player.max_shoot_force
	else:
		%ShootForceBar.hide()
