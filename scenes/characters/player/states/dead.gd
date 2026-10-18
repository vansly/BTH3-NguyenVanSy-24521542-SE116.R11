extends PlayerState

func _enter() -> void:
	obj.change_animation("dead")
	obj.stop_move()
	timer = 2.0

func _update(delta: float) -> void:
	if update_timer(delta):
		obj.get_tree().reload_current_scene.call_deferred()

func take_damage(_damage: int = 1) -> void:
	pass